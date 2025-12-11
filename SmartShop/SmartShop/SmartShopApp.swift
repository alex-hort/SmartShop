//
//  SmartShopApp.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 09/12/25.
//

import SwiftUI

@main
struct SmartShopApp: App {
    
    @State private var token: String?
    @State private var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                
                Group{
                    
                    if isLoading{
                        ProgressView("Loading..")
                    } else {
                        if JWTTokenValidator.validate(token: token){
                            Text("HomeView")
                        } else {
                            LoginView()
                        }
                    }
                    
                    
                    
                }
               
            }.environment(\.authenticationController, .development)
                .onAppear {
                    token = Keychain.get("jwttoken")
                    isLoading = false
                }
        }
    }
}
