//
//  AuthenticationEnvioromentKey.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 09/12/25.
//

import Foundation
import SwiftUI



private struct AuthenticationEnvioromentKey: EnvironmentKey{
    static let defaultValue = AuthenticationController(httpClient: HTTPClient())
}


extension EnvironmentValues{
    var authenticationController: AuthenticationController{
        get {self[AuthenticationEnvioromentKey.self]}
        set {self[AuthenticationEnvioromentKey.self] = newValue}
    }
}
