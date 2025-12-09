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

struct ErrorResponse: Codable{
    let message: String?
}
