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
    @State private var isLoading = false
    
    @AppStorage("userId") private var userId: Int?
    
    private var isFormValid: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    private func login() async {
        isLoading = true
        message = ""
        do {
            let response = try await authenticationController.login(
                username: username,
                password: password
            )
            
            guard let token = response.token,
                  let userId = response.userId,
                  response.success else {
                message = response.message ?? "No se pudo iniciar sesión"
                isLoading = false
                return
            }
            
            Keychain.set(token, forKey: "jwttoken")
            self.userId = userId
            
        } catch {
            message = error.localizedDescription
        }
        isLoading = false
    }
    
    var body: some View {
        ZStack {
            // MARK: Background
            LinearGradient(
                colors: [.black, .gray.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                // MARK: Header
                VStack(spacing: 8) {
                    Image(systemName: "music.note.house.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.white)
                    
                    Text("Bienvenido")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    
                    Text("Inicia sesión para continuar")
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                // MARK: Card
                VStack(spacing: 20) {
                    
                    inputField(
                        icon: "person.fill",
                        placeholder: "Usuario",
                        text: $username,
                        isSecure: false
                    )
                    
                    inputField(
                        icon: "lock.fill",
                        placeholder: "Contraseña",
                        text: $password,
                        isSecure: true
                    )
                    
                    if !message.isEmpty {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        Task { await login() }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .disabled(!isFormValid || isLoading)
                }
                .padding(24)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Custom Input
    @ViewBuilder
    private func inputField(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.gray)
            
            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
                    .textInputAutocapitalization(.never)
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .foregroundStyle(.white)
    }
}

#Preview {
    LoginView()
        .environment(\.authenticationController, .development)
}
