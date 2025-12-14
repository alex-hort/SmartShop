//
//  UploaderEnvioromentKey.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 13/12/25.
//

import Foundation
import SwiftUI


private struct UploaderEnvioromentKey: EnvironmentKey{
    static let defaultValue = UploaderDownloader(httpClient: HTTPClient())
}


extension EnvironmentValues{
    var uploaderDownloader: UploaderDownloader{
        get {self[UploaderEnvioromentKey.self]}
        set {self[UploaderEnvioromentKey.self] = newValue}
    }
}
