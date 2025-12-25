//
//  ProfileView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 11/12/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("userId") private var userId: String?
    @Environment(CartStore.self) private var cartStore
    @Environment(UserStore.self) private var userStore
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state : String = ""
    @State private var zipCode: String = ""
    @State private var country: String = ""
    @State private var updatingUserInfo: Bool = false
    @State private var validationErrors: [String] = []
    
    private func validateForm() -> Bool {
        validationErrors = []
        
        if firstName.isEmptyOrWhitespace {
            validationErrors.append("First name is required.")
        }
        
        if lastName.isEmptyOrWhitespace {
            validationErrors.append("Last name is required.")
        }
        
        if street.isEmptyOrWhitespace {
            validationErrors.append("Street is required.")
        }
        
        if city.isEmptyOrWhitespace {
            validationErrors.append("City is required.")
        }
        
        if state.isEmptyOrWhitespace {
            validationErrors.append("State is required.")
        }
        
        if !zipCode.isZipCode {
            validationErrors.append("Invalid ZIP code.")
        }
        
        if country.isEmptyOrWhitespace {
            validationErrors.append("Country is required.")
        }
        
        return validationErrors.isEmpty
    }
    
    private func updateUserInfo() async {
        //create userinfo
        do{
            let userInfo = UserInfo(firstName: firstName, lastName: lastName, street: street, city: city, state: state, zipCode: zipCode, country: country)
            
            try await userStore.updateUserInfo(userInfo: userInfo)
             
        } catch{
            print(error)
        }
        
        
        
        //userStore.updateUserinfo
    }
    
    
    var body: some View {
        List{
            
            Section("User Profile"){
                TextField("Firts name", text: $firstName)
                TextField("Last name", text: $lastName)
            }
            Section("Address"){
                TextField("Street", text: $street)
                TextField("City",text: $city)
                TextField("State", text: $state)
                TextField("ZipCode", text: $zipCode)
                TextField("Country", text: $country)
            }
            
            
            ForEach(validationErrors, id: \.self){ errorMessage in
                Text(errorMessage)
            }
            
            HStack{
                
                VStack{
                    
                    Button("Sign out"){
                        let _ = Keychain<String>.delete("jwttoken")
                        userId = nil
                        cartStore.emptyCart()
                    }
                }.padding(.horizontal)
                
                
                
                
            }
        }
        .onChange(of: userStore.userInfo, initial: true , {
            if let userInfo = userStore.userInfo{
                firstName = userInfo.firstName ?? ""
                lastName = userInfo.lastName ?? ""
                street = userInfo.street ?? ""
                city = userInfo.city ?? ""
                state = userInfo.state ?? ""
                zipCode = userInfo.zipCode ?? ""
                country = userInfo.country ?? ""
            }
        })
        
        
        
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save"){
                    if validateForm(){
                        updatingUserInfo = true
                    }
                }
            }
        }.task(id: updatingUserInfo) {
            if updatingUserInfo{
                await updateUserInfo()
            }
        }
        
    }
}

#Preview {
    NavigationStack{
        ProfileView()
            .environment(CartStore(httpClient: .development))
            .environment(UserStore(httpClient: .development))
    }
}
