//
//  ImagePicker.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/13.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: Image?
    @Environment(\.presentationMode) var presentationMode
    
    var pickerConfig: PHPickerConfiguration {
        var pickerConfig = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        pickerConfig.filter = .images
        pickerConfig.selectionLimit = 1
        return pickerConfig
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
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
                                SharedInstance.uiImage = selectedImage
                                self.parent.image = Image(uiImage: SharedInstance.uiImage)
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
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> PHPickerViewController {
        let picker = PHPickerViewController(configuration: pickerConfig)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}
