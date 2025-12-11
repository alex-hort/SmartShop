//
//  DTOs.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 09/12/25.
//


import Foundation

struct RegisterResponse: Codable{
    let message: String?
    let success: Bool
}

struct LoginResponse: Codable{
    let message: String?
    let token: String?
    let success: Bool
    let userId: Int?
    let username: String?
}

struct ErrorResponse: Codable{
    let message: String?
}
