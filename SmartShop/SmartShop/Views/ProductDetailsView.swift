//
//  ProductDetailsView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 18/12/25.
//

import SwiftUI

struct ProductDetailsView: View {
    
    let product: Product
    @Environment(CartStore.self) private var cartStore
    @State private var quantity: Int = 1
    
    var body: some View {
        ScrollView{
            AsyncImage(url: product.photoUrl){ img in
                img.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .scaledToFit()
                
            } placeholder: {
                ProgressView("Loading..")
            }
            HStack{
                VStack{
                    Text(product.name)
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontDesign(.serif)
                    
                    Text(product.description)
                        .padding([.top], 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.thin)
                        .fontDesign(.serif)
                    
                    Text(product.price, format: .currency(code: "USD"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.title)
                        .bold()
                        .padding([.top], 2)
                    
                    Stepper(value: $quantity) {
                        Text("Quanity : \(quantity)")
                    }
                    
                    
                    Button{
                        Task{
                            do{
                                try await cartStore.addItemToCart(productId: product.id!, quantity: quantity)
                            }catch{
                                print(error)
                            }
                        }
                    }label: {
                        Text("Add to Cart")
                            .frame(maxWidth:.infinity)
                            .frame(height: 44)
                            .foregroundStyle(.white)
                            .background(.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .circular))
                        
                    }
                }
            }.padding(.horizontal)
        }
    }
}

#Preview {
    ProductDetailsView(product: Product.preview)
        .environment(CartStore(httpClient: .development))
}
