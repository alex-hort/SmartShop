//
//  CartItemQuantityView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 19/12/25.
//

import SwiftUI

enum QuantityChangeType: Equatable {
    case update(Int)
    case delete
}

struct CartItemQuantityView: View {
    
    let cartItem: CartItem
    @State private var quantity: Int = 0
    @State private var quantityChangeType: QuantityChangeType?
    
    @Environment(CartStore.self) private var cartStore
    
    var body: some View {
        HStack {
            Button {
                if quantity == 1 {
                    quantityChangeType = .delete
                } else {
                    quantity -= 1
                    quantityChangeType = .update(quantity) // Enviar la nueva cantidad
                }
            } label: {
                Image(systemName: quantity == 1 ? "trash" : "minus")
            }

            Text("\(quantity)")

            Button {
                quantity += 1
                quantityChangeType = .update(quantity) // Enviar la nueva cantidad
            } label: {
                Image(systemName: "plus")
            }
        }
        .task(id: quantityChangeType) {
            // Solo se ejecuta cuando quantityChangeType cambia
            if let changeType = quantityChangeType {
                switch changeType {
                case .update(_):
                    do{
                        try await cartStore.updateItemQuantity(productId: cartItem
                            .product.id!, quantity: quantity)
                    }catch{
                        print(error)
                    }
                case .delete:
                    do{
                        try await cartStore.deleteCartItem(cartItemId: cartItem.id!)
                        
                    }catch{
                        print(error)
                    }
                }
            }
            self.quantityChangeType = nil // Resetear después de procesar
        }
        .onAppear {
            quantity = cartItem.quantity
        }
        .frame(width: 150)
        .background(.gray)
        .foregroundStyle(.background)
        .buttonStyle(.borderedProminent)
        .tint(.gray)
        .cornerRadius(15.0)
    }
}

// Para el preview (manteniendo tu código original)
#Preview {
    CartItemQuantityView(cartItem: Cart.preview.cartItems[0])
        .environment(CartStore(httpClient: .development))
}
