//
//  KeychainWrapper.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 10/12/25.
//

import Foundation
import Security

// A generic Keychain helper that can save, read, and delete any Codable type.
struct Keychain<T: Codable> {
    
    // Save a value into the Keychain
    static func set(_ value: T, forKey key: String) {
        do {
            // Convert the value into Data using JSON
            let data = try JSONEncoder().encode(value)
            
            // Build the keychain query (like a dictionary with instructions)
            let query: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword, // Type of item
                kSecAttrAccount: key,               // Key (identifier)
                kSecValueData: data                 // The actual data to store
            ]
            
            // Delete any existing value with the same key
            SecItemDelete(query as CFDictionary)
            
            // Add the new item to the keychain
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Error saving item to keychain \(status)")
            }
        } catch {
            print("Error encoding data: \(error)")
        }
    }
    
    // Read a value from the Keychain
    static func get(_ key: String) -> T? {
        // Build the query to find the item
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword, // Type
            kSecAttrAccount: key,               // Key to match
            kSecReturnData: kCFBooleanTrue as Any, // We want the data back
            kSecMatchLimit: kSecMatchLimitOne      // Only one item
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        // If found successfully, decode the data back into type T
        if status == errSecSuccess, let data = item as? Data {
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        return nil
    }
    
    // Delete a value from the Keychain
    static func delete(_ key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword, // Type
            kSecAttrAccount: key                // Key to delete
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess // Return true if deleted successfully
    }
}

