//
//  CartItemListView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 18/12/25.
//

import SwiftUI

struct CartItemListView: View {
    
    let cartItems: [CartItem]
    var body: some View {
        ForEach(cartItems) { cartItem in
            CartItemView(cartItem: cartItem)
        }.listStyle(.plain)
    }
}

#Preview {
    CartItemListView(cartItems: Cart.preview.cartItems)
}
