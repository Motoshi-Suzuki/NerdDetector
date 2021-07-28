//
//  RekognitionImage.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/28.
//

import Foundation

class RekognitionImage {
    
    private var imageSizeKB: Double = 0.0
    private var imageData: Data?
    let rekognition = Rekognition()
    
    func prepareForDetectFaces() {
        self.prepareImage()
        
        guard self.imageData != nil else {
            print("Image data is nil.")
            return
        }
        rekognition.detectFaces(imageData: self.imageData!)
    }
    
    func prepareImage() {
        let uiImage = SharedInstance.uiImage
        
        // Image must be .jpeg or .png format.
        guard let originalImageData = uiImage.jpegData(compressionQuality: 1.0) else {
            print("UIImage is nill.")
            return
        }
        
        self.calculateImageSize(imageData: originalImageData)
        
        // Image must not be larger than 5MB.
        if imageSizeKB <= 5000.0 {
            self.imageData = originalImageData
            print("The original size of this image is \(imageSizeKB)KB.")
            
        // If image was larger than 5MB,
        } else {
            print("This image is too big. Size is \(imageSizeKB)KB.")
            
            if let compressedImageData = uiImage.jpegData(compressionQuality: 0.5) {
                self.calculateImageSize(imageData: compressedImageData)
                print("The size of compressed image is \(imageSizeKB)KB.")
                
                if imageSizeKB <= 5000.0 {
                    self.imageData = compressedImageData
                    
                // In case of unexpected large bytes.
                } else {
                    if let maxCompressedImageData = uiImage.jpegData(compressionQuality: 0.1) {
                        self.calculateImageSize(imageData: maxCompressedImageData)
                        print("The size of MaxCompressed image is \(imageSizeKB)KB.")
                        
                        if imageSizeKB <= 5000.0  {
                            self.imageData = maxCompressedImageData
                            
                        // In case of very unexpected huge bytes.
                        } else {
                            var resizedUiImage = uiImage
                            
                            while imageSizeKB > 5000.0 {
                                resizedUiImage = resizedUiImage.resize(withPercentage: 0.9)!
                                
                                if let resizedImageData = resizedUiImage.jpegData(compressionQuality: 1.0) {
                                    self.calculateImageSize(imageData: resizedImageData)
                                    print("The size of resized image is \(imageSizeKB)KB.")
                                    
                                    if imageSizeKB <= 5000.0 {
                                        self.imageData = resizedImageData
                                    }
                                }
                            }
                            SharedInstance.uiImage = resizedUiImage
                        }
                    }
                }
            }
        }
    }
    
    func calculateImageSize(imageData: Data) {
        let imageSize: Int = NSData(data: imageData).count
        self.imageSizeKB = Double(imageSize) / 1000.0
    }
}
