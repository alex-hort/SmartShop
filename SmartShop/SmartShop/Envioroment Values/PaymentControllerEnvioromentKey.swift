//
//  PaymentControllerEnvioromentKey.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 28/12/25.
//

import SwiftUI

extension EnvironmentValues{
    @Entry var paymentController = PaymentController(httpClient: HTTPClient())
}
