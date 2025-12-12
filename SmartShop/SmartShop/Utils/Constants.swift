//
//  Constants.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 09/12/25.
//

import Foundation


struct Constants{
    struct Urls {
        static let register: URL = URL(string: "http://localhost:8080/api/auth/register")!
        static let login: URL = URL(string: "http://localhost:8080/api/auth/login")!
        static let products: URL = URL(string: "http://localhost:8080/api/products")!
        static let createProduct: URL = URL(string: "http://localhost:8080/api/products")!
        static func myProducts(_ userId: Int) -> URL{
            URL(string: "http://localhost:8080/api/products/user/\(userId)")!
        }
    }
}
