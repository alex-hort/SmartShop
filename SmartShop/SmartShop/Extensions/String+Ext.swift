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
}
