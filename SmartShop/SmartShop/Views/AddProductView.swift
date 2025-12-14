//
//  AddProductView.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 12/12/25.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    let product: Product?
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var price: Double?
    @Environment(\.dismiss) private  var dismiss
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var isCameraSelected: Bool = false
    @State private var uiImage : UIImage?
    
    @Environment(ProductStore.self) private var productSore
    @AppStorage("userId") private var userId: Int?
    
    @Environment(\.uploaderDownloader) private var uploaderDownloader
    
    init(product: Product? = nil ){
        self.product = product
    }
    private var isFormValid: Bool{
        !name.isEmptyOrWhitespace && !description.isEmptyOrWhitespace
        && (price ?? 0) > 0
    }
    
    private func saveOrUpdateProduct() async{
        do{
            
            guard let uiImage = uiImage, let imageData = uiImage.pngData() else {
                throw ProductError.missingImage
            }
            
            let uploadDataResponse = try await uploaderDownloader.upload(data: imageData)
            
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
            let product = Product(id: self.product?.id, name: name, description: description, price: price, photoUrl: downloadURL, userId: userId)
            
            if self.product != nil {
                try await productSore.updateProduct(product)
            } else {
                try await productSore.saveProduct(product)
            }
            
            try await productSore.saveProduct(product)
            dismiss()
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private var actionTitle: String{
        product != nil ? "Update Product": "Add product"
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
            
        
            .task {
                do{
                    guard let product = product else {return}
                    name = product.name
                    description = product.description
                    price = product.price
                    
                    if let photoUrl = product.photoUrl{
                        guard let data = try await uploaderDownloader.download(from: photoUrl) else {
                            return
                        }
                        
                        uiImage = UIImage(data: data)
                    }
                } catch{
                    print(error.localizedDescription)
                }
            }
            .task(id: selectedPhotoItem, {
                if let selectedPhotoItem{
                    do{
                        if let data = try await selectedPhotoItem.loadTransferable(type: Data.self){
                            uiImage = UIImage(data: data)
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            })
          
        
            
            .sheet(isPresented: $isCameraSelected) {
                ImagePicker(sourceType: .camera, image: $uiImage)
            }
            
               
                
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(actionTitle){
                    Task{
                        await saveOrUpdateProduct()
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
        .environment(\.uploaderDownloader, UploaderDownloader(httpClient: .development))
}

#Preview ("Updating product"){
    NavigationStack{
        AddProductView(product: Product.preview)
    }.environment(ProductStore(httpClient: .development))
        .environment(\.uploaderDownloader, UploaderDownloader(httpClient: .development))
}
