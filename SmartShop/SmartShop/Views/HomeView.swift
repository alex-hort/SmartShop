//
//  HomeView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 11/12/25.
//

import SwiftUI

enum AppView: Hashable, Identifiable, CaseIterable{
    case home
    case myProducts
    case cart
    case profile
    
    var id: AppView{self}
}

extension AppView{
    
    @ViewBuilder
    var label: some View{
        switch self {
        case .home:
            Label("Home", systemImage: "heart")
        case .myProducts:
            Label("My Products", systemImage: "star")
        case .cart:
            Label("Cart", systemImage: "cart")
        case .profile:
            Label("Profile", systemImage: "person.fill")
        }
    }
    
    @MainActor
    @ViewBuilder
    var destination: some View{
        switch self{
        case .home:
            NavigationStack{
                ProductListView()
            }
        case .myProducts:
            NavigationStack{
               MyProductsListView()
                    .requiresAuthentication()
            }
        case .cart:
            NavigationStack{
                CartView()
                    .requiresAuthentication()
            }
        case .profile:
            NavigationStack{
                ProfileView()
                    .requiresAuthentication()
            }
        }
    }
}

struct HomeView: View {
    
    @State var selection: AppView?
    @Environment(CartStore.self) private var cartSore
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppView.allCases){ view in
               view.destination
                    .tag(view as AppView?)
                    .tabItem{view.label}
                    .badge((view as AppView?) == .cart ? cartSore.itemsCount: 0 )
            }
        }
    }
}

#Preview {
    
    
    HomeView()
        .environment(ProductStore(httpClient: .development))
        .environment(CartStore(httpClient: .development))
}
