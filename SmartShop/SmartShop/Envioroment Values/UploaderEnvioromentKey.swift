//
//  UploaderEnvioromentKey.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 13/12/25.
//

import Foundation
import SwiftUI


private struct UploaderEnvioromentKey: EnvironmentKey{
    static let defaultValue = Uploader(httpClient: HTTPClient())
}


extension EnvironmentValues{
    var uploader: Uploader{
        get {self[UploaderEnvioromentKey.self]}
        set {self[UploaderEnvioromentKey.self] = newValue}
    }
}
