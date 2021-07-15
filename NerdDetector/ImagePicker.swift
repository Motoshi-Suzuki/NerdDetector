//
//  ImagePicker.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/13.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: Image?
    
    var pickerConfig: PHPickerConfiguration {
        var pickerConfig = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        pickerConfig.filter = .images
        pickerConfig.selectionLimit = 1
        return pickerConfig
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> PHPickerViewController {
        let picker = PHPickerViewController(configuration: pickerConfig)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { selectedImage, error in
                        if let selectedImage = selectedImage as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.image = Image(uiImage: selectedImage)
                                print("didFinishPicking")
                            }
                        }
                        if let error = error {
                            print("error in didFinishPicking")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            self.parent.presentationMode.wrappedValue.dismiss()
        }
        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                parent.image = uiImage
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
    }
}
