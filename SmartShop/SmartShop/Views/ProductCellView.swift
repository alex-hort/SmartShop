//
//  ProductCellView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 12/12/25.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            AsyncImage(url: product.photoUrl){ img in
                img.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .scaledToFit()
                
            } placeholder: {
                ProgressView("Loading...")
            }
            
            HStack{
                VStack{
                    Text(product.name)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                    
                    HStack{
                        Text(product.price, format: .currency(code: "USD"))
                            .font(.system(size: 20))
                            .fontWeight(.light)
                        
                    }
                    
                  
                }
                
                
            }.padding(.horizontal,8)
            
        }.padding(.horizontal)
    }
}

#Preview {
    ProductCellView(product: Product.preview)
}
