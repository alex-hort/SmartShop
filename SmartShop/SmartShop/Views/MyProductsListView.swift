//
//  MyProductsListView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 12/12/25.
//

import SwiftUI

struct MyProductsListView: View {
    
    @Environment(ProductStore.self) private var productStore
    @State private var isPresented: Bool = false
    @AppStorage("userId") private var userId: Int?
    
    private func loadMyProducts() async{
        
       
        do{
            guard let userId = userId else {
                throw UserError.missingId
            }
            try await productStore.loadMyProducts(by: userId)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        List(productStore.myProducts){ product in
            Text(product.name)
               
        }.task {
           await loadMyProducts()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Product"){
                    isPresented = true
                }
            }
        }.sheet(isPresented: $isPresented) {
            NavigationStack{
                AddProductView()
            }
        }
    }
}

#Preview {
    NavigationStack{
        MyProductsListView()
    }.environment(ProductStore(httpClient: .development))
}
