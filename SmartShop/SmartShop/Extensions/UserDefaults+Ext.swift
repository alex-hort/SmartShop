//
//  UserDefaults+Ext.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 18/12/25.
//

import Foundation

extension UserDefaults{
    private enum Keys{
        static let userId = "userId"
    }
    
    var userId: Int? {
        get {
            let id = integer(forKey: Keys.userId)
            return id == 0 ? nil : id
        }
        set {
            set(newValue, forKey: Keys.userId)
        }
    }
}
