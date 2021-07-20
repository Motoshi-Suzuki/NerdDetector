//
//  Rekognition.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/20.
//

import Foundation
import AWSRekognition

class Rekognition {
    private var rekognition: AWSRekognition?
    private var imageSizeKB: Double = 0.0
    
    func detectFaces(image: UIImage) {
        rekognitionImage(image: image)
    }
    
    func rekognitionImage(image: UIImage) {
        
        let rekognitionImage = AWSRekognitionImage()

        // Image must be .jpeg or .png format.
        guard let originalImageData = image.jpegData(compressionQuality: 1.0) else {
            print("Image data is nill.")
            return
        }
                
        self.calculateImageSize(imageData: originalImageData)
        
        // Image must not be larger than 5MB.
        if imageSizeKB <= 5000.0 {
            rekognitionImage?.bytes = originalImageData
            print("The original size of this image is \(imageSizeKB)KB.")
           
        // If image was larger than 5MB,
        } else {
            print("This image is too big. Size is \(imageSizeKB)KB.")
            
            if let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                self.calculateImageSize(imageData: compressedImageData)
                print("The size of compressed image is \(imageSizeKB)KB.")
                
                if imageSizeKB <= 5000.0 {
                    rekognitionImage?.bytes = compressedImageData
                
                // In case of unexpected large bytes.
                } else {
                    if let maxCompressedImageData = image.jpegData(compressionQuality: 0.1) {
                        self.calculateImageSize(imageData: maxCompressedImageData)
                        print("The size of MaxCompressed image is \(imageSizeKB)KB.")
                        
                        if imageSizeKB <= 5000.0  {
                            rekognitionImage?.bytes = maxCompressedImageData
                            
                        // In case of vaey unexpected huge bytes.
                        } else {
                            var resizedUiImage = image
                            
                            while imageSizeKB > 5000.0 {
                                resizedUiImage = resizedUiImage.resize(withPercentage: 0.9)!
                                
                                if let resizedImageData = resizedUiImage.jpegData(compressionQuality: 1.0) {
                                    self.calculateImageSize(imageData: resizedImageData)
                                    print("The size of resized image is \(imageSizeKB)KB.")
                                    
                                    if imageSizeKB <= 5000.0 {
                                        rekognitionImage?.bytes = resizedImageData
                                    }
                                }
                            }
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
