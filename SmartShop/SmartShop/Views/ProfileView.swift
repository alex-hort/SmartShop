//
//  ProfileView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 11/12/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("userId") private var userId: String?
    @Environment(CartStore.self) private var cartStore
    var body: some View {
        Button("Sign out"){
            let _ = Keychain<String>.delete("jwttoken")
            userId = nil
            cartStore.emptyCart()
        }
    }
}

#Preview {
    ProfileView()
        .environment(CartStore(httpClient: .development))
}
