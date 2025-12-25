//
//  String+Ext.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 09/12/25.
//

import Foundation


extension String{
    
    var isEmptyOrWhitespace: Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isZipCode: Bool {
        // Ajusta el regex según el país (este es formato US)
        let zipCodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
        return NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
            .evaluate(with: self)
    }

}
