//
//  Errors.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 12/12/25.
//

import Foundation


enum ProductSaveError: Error{
    case missingUserId
    case invalidPrice
    case operationFailed(String)
    case missingImage
}


enum UserError: Error{
    case missingId
}
