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
    @State private var cartStore = CartStore(httpClient: HTTPClient())
    @State private var userStore = UserStore(httpClient: HTTPClient())
    
    
    private func loadUserInfoCart() async {
        await cartStore.loadCart()
        do{
            try await userStore.loadUserInfo()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    @AppStorage("userId") private var userId: String?
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.authenticationController, .development)
                .environment(productStore)
                .environment(cartStore)
                .environment(userStore)
                .environment(\.uploaderDownloader, UploaderDownloader(httpClient: HTTPClient()))
                .task(id:userId){
                  
                    if userId != nil {
                        await loadUserInfoCart()
                    }
                }
        }
    }
}
