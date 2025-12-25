//
//  CartView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 18/12/25.
//

import SwiftUI

struct CartView: View {
    @Environment(CartStore.self) private var cartStore
    var body: some View {
        List{
        
            if let cart = cartStore.cart{
                
                HStack{
                    Text("Total: ")
                        .font(.title)
                    Text(cartStore.total, format: .currency(code: "USD"))
                        .font(.title)
                        .bold()
                }
                Button(action: {
                    
                }) {
                    Text("Proceed to checkout ^[\(cartStore.itemsCount) Item](inflect: true)")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(.borderless)


                
                
                CartItemListView(cartItems: cart.cartItems)
                
            } else{
                ContentUnavailableView("No items in the cart", systemImage: "cart")
            }
        }.task {
            try? await cartStore.loadCart()
        }
    }
}


#Preview {
    NavigationStack{
        CartView().environment(CartStore(httpClient: .development))
    }
}
