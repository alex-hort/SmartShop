//
//  AddProductView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 12/12/25.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: Double?
    @Environment(\.dismiss) private  var dismiss
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var isCameraSelected: Bool = false
    @State private var uiImage : UIImage?
    
    @Environment(ProductStore.self) private var productSore
    @AppStorage("userId") private var userId: Int?
    
    @Environment(\.uploader) private var uploader
    
    private var isFormValid: Bool{
        !name.isEmptyOrWhitespace && !description.isEmptyOrWhitespace
        && (price ?? 0) > 0
    }
    
    private func saveProduct() async{
        do{
            
            guard let uiImage = uiImage, let imageData = uiImage.pngData() else {
                throw ProductError.missingImage
            }
            
            let uploadDataResponse = try await uploader.upload(data: imageData)
            
            guard let downloadURL = uploadDataResponse.downloadUrl, uploadDataResponse.success else {
                throw ProductError.operationFailed(uploadDataResponse.message ?? "")
            }
            
            guard let  userId = userId else{
                throw ProductError.missingUserId
            }
            guard let price = price else {
                throw ProductError.invalidPrice
            }
            
            print(downloadURL)
            let product = Product(name: name, description: description, price: price, photoUrl: downloadURL, userId: userId)
            
            try await productSore.saveProduct(product)
            dismiss()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        Form{
            TextField("Enter name", text: $name)
            TextEditor(text: $description)
                .frame(height: 100)
            TextField("Enter price", value: $price, format: .number)
            
            HStack{
                Button {
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                        isCameraSelected = true
                    } else{
                        print("Camera is not sopported")
                    }
                    
                } label: {
                    Image(systemName: "camera")
                }
                Spacer().frame(width: 20)
                PhotosPicker( selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()){
                    Image(systemName: "photo.on.rectangle")
                }
                if let uiImage{
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
          
        
            
            
            .onChange(of: selectedPhotoItem, {
                selectedPhotoItem?.loadTransferable(type: Data.self) {  result in
                    switch result {
                    case .success(let data):
                        if let data {
                            uiImage = UIImage(data: data)
                        }
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            })
            
            .sheet(isPresented: $isCameraSelected) {
                ImagePicker(sourceType: .camera, image: $uiImage)
            }
            
               
                
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save"){
                    Task{
                        await saveProduct()
                    }
                }.disabled(!isFormValid)
            }
        }
    }
}

#Preview {
    NavigationStack{
        AddProductView()
    }.environment(ProductStore(httpClient: .development))
        .environment(\.uploader, Uploader(httpClient: .development))
}
