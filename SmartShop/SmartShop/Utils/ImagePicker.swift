//
//  ImagePicker.swift
//  SmartShop
//
//  Created by Alexis Horteales Espinosa on 13/12/25.
//


import Foundation
import SwiftUI

import Foundation
import SwiftUI

// Wrapper para usar UIImagePickerController (UIKit) dentro de SwiftUI
struct ImagePicker: UIViewControllerRepresentable {

    // Permite cerrar la vista (sheet) desde SwiftUI
    @Environment(\.dismiss) private var dismiss

    // Tipo de UIViewController que se va a representar
    typealias UIViewControllerType = UIImagePickerController

    // Define si se usa cámara o galería
    var sourceType: UIImagePickerController.SourceType = .camera

    // Conecta SwiftUI con UIKit usando un Coordinator
    typealias Coordinator = ImagePickerCoordinator

    // Imagen seleccionada (se pasa de vuelta a SwiftUI)
    @Binding var image: UIImage?

    // Crea el Coordinator (delegate)
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(self)
    }

    // Crea el UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false          // No permite editar la imagen
        picker.sourceType = sourceType        // Cámara o galería
        picker.delegate = context.coordinator // Asigna el delegate
        return picker
    }

    // Se usa cuando el UIViewController se actualiza
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {}
    
    class ImagePickerCoordinator: NSObject,
                                  UINavigationControllerDelegate,
                                  UIImagePickerControllerDelegate {

        var picker: ImagePicker

        init(_ picker: ImagePicker) {
            self.picker = picker
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.picker.image = uiImage
            }

            self.picker.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.picker.dismiss()
        }
    }

}

