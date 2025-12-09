//
//  RegisterView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 09/12/25.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.authenticationController) private var authenticationController
    @Environment(\.dismiss) private var dismiss
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    
    
    private var isFormValid: Bool{
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    private func register() async{
        do {
            let response = try await authenticationController.register(username: username, password: password)
            print(response)
            if response.success{
                //dismiss the shet
                dismiss()
            } else {
                message = response.message ?? ""
            }
        }catch{
            message = error.localizedDescription
        }
        username = ""
        password = ""
    }
    
    var body: some View {
        Form{
            TextField("User name", text: $username)
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text: $password)
            
            Button("Register"){
                Task{
                    await register()
                }
            }.disabled(!isFormValid)
            
            Text(message)
            
            
        }.navigationTitle("Register")
        
            
    }
}

#Preview {
    RegisterView()
        .environment(\.authenticationController, .development)
}
