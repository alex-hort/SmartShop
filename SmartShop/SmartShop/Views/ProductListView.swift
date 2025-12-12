//
//  ProductListView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 12/12/25.
//

import SwiftUI

struct ProductListView: View {
    
    @Environment(ProductStore.self) private var productStore
    
    var body: some View {
        List(productStore.products){ product in
            ProductCellView(product: product)
          
        }.task {
            do{
                try await productStore.loadAllProducts()
            }catch{
                
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack{
        ProductListView()
    }.environment(ProductStore(httpClient: .development))
}
