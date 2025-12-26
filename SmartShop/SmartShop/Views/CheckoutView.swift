//
//  CheckoutView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 26/12/25.
//

import SwiftUI

struct CheckoutView: View {
    let cart: Cart
    @Environment(UserStore.self) private var userStore
    
    
    var body: some View {
        List{
            VStack(spacing: 10){
                Text("Place your order")
                    .font(.title3)
                HStack{
                    Text("Items")
                    Spacer()
                    Text(cart.total, format: .currency(code: "USD"))
                }
                
                if let userInfo = userStore.userInfo{
                    Text("Delivering to \(userInfo.fullName)")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(userInfo.addredd)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Plese update your profile and add the missing info")
                        .foregroundStyle(.red )
                }
            }.padding()
            ForEach(cart.cartItems){ cartItem in
                CartItemView(cartItem: cartItem)
            }
        }
    }
}





#Preview {
    NavigationStack{
        CheckoutView(cart: Cart.preview)
    }
    .environment(UserStore(httpClient: .development))
    .environment(CartStore(httpClient: .development))
    
}
