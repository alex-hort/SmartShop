//
//  Errors.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 12/12/25.
//

import Foundation


enum ProductError: Error{
    case missingUserId
    case invalidPrice
    case operationFailed(String)
    case missingImage
    case productNotFound
}


enum UserError: Error{
    case missingId
}

enum CartError: Error{
    case operationFailed(String)
}
