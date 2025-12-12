//
//  SmartShopApp.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 09/12/25.
//

import SwiftUI

@main
struct SmartShopApp: App {
    @State private var productStore = ProductStore(httpClient: HTTPClient())
    var body: some Scene {
        WindowGroup {
              HomeView()
            }.environment(\.authenticationController, .development)
            .environment(productStore)
        
    }
}
