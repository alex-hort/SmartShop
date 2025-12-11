//
//  LoginView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 10/12/25.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.authenticationController) private var authenticationController
    @Environment(\.dismiss) private var dismiss
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    
    
    @AppStorage("userId") private var userId: Int?
    
    
    
    private var isFormValid:Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    private func login() async{
        do {
           let response = try await authenticationController.login(username: username, password: password)
            
            guard let token = response.token,
                  let userId = response.userId,
                  response.success else {
                message = response.message ?? "Request cannot be completed"
                return
            }
            print(token)
            ///set the token in keycain
            Keychain.set(token, forKey: "jwttoken")
            ///set userId in the user defaults
    
            self.userId = userId
                    
            
        }catch{
            message = error.localizedDescription
        }
    }
    
    var body: some View {
        
        Form{
            TextField("User name", text: $username)
            
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Login"){
                Task{
                    await login()
                }
            }.disabled(!isFormValid)
            Text(message)
             
        }
        .navigationDestination(item: $userId, destination: { _ in
            Text("Home View")
        })
        .navigationTitle("Login")
    }
}

#Preview {
    LoginView().environment(\.authenticationController, .development)
}
