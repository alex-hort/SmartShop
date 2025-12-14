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
            
            NavigationLink {
                MyProductDetailScreen(product: product)
            } label: {
                MyProductCellView(product: product)
            }
           
               
        }
        .listStyle(.plain)
        .task {
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
        .overlay(alignment: .center){
            if productStore.myProducts.isEmpty{
                ContentUnavailableView("No products man", systemImage: "cart")
            }
        }
    }
}


struct MyProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: product.photoUrl) { img in
                img.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView("Loading...")
            }
            Spacer()
                .frame(width: 20)
            
            VStack{
                Text(product.name)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(product.price, format: .currency(code: "USD"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    NavigationStack{
        MyProductsListView()
    }.environment(ProductStore(httpClient: .development))
}
