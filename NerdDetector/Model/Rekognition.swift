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
    private var imageData: Data?
    static var positiveScore: Double = 0.0
    static var negativeScore: Double = 0.0
    
    func detectFaces(image: UIImage) {
        
        Self.positiveScore = 0.0
        Self.negativeScore = 0.0
                
        self.rekognition = AWSRekognition.default()
        let detectFacesRequest = AWSRekognitionDetectFacesRequest()
        let rekognitionImage = AWSRekognitionImage()
        
        self.processImage(image: image) { imageData in
            rekognitionImage?.bytes = imageData
        }
        detectFacesRequest?.image = rekognitionImage
        detectFacesRequest?.attributes = ["ALL"]
        
        guard let request = detectFacesRequest else {
            return
        }
        
        // Ask AWSRekogniton to detect faces in an image.
        self.rekognition?.detectFaces(request) { response, error in
            if let response = response {
                print("\n-----success-----")
                
                let faceDetails: [AWSRekognitionFaceDetail]? = response.faceDetails
                guard faceDetails?.isEmpty != true else {
                    print("...but no face detected.")
                    return
                }
                // Print all results.
                print(faceDetails!)
                
                // Access properties of faceDetails.
                for attributes in faceDetails! {
                    // Access AgeRagne.
                    if let ageRange: AWSRekognitionAgeRange = attributes.ageRange {
                        print("\n-----Result of AgeRange-----", "\nThe estimated age range is \(ageRange.low!) - \(ageRange.high!).")
                    }
                    
                    // Access Emotions.
                    if let emotions: [AWSRekognitionEmotion] = attributes.emotions {
                        var emotionDict: [String : Double] = [:]
                        
                        for i in emotions {
                            let emotionTypes: AWSRekognitionEmotionName = i.types
                            let emotionConfidence: Double = i.confidence!.doubleValue

                            let emotionName = Emotions(rawValue: emotionTypes.rawValue)?.returnEmotionName(confidence: emotionConfidence)
                            emotionDict[emotionName!] = emotionConfidence
                        }
                        let sortedEmotionDict = emotionDict.sorted {
                            return $0.value > $1.value
                        }
                        print("\n-----Results of Emotions-----", "\n\(sortedEmotionDict)")
                        print("\nPositive Score: \(Self.positiveScore)", "\nNegative Score: \(Self.negativeScore)")
                    }
                    
                    // Access Eyeglasses.
                    if let eyeglasses: AWSRekognitionEyeglasses = attributes.eyeglasses {
                        let eyeglassesValue: Int = eyeglasses.value!.intValue
                        let eyeglassesConfidence: Double = eyeglasses.confidence!.doubleValue
                        let eyeglassesBool = Eyeglasses(rawValue: eyeglassesValue)?.returnBool(confidence: eyeglassesConfidence)
                        print("\n-----Result of Eyeglasses-----", "\nThis face is wearing eye glasses: \(eyeglassesBool!)")
                        print("\nPositive Score: \(Self.positiveScore)", "\nNegative Score: \(Self.negativeScore)")
                    }
                    
                    // Access EyesOpen.
                    if let eyesOpen: AWSRekognitionEyeOpen = attributes.eyesOpen {
                        let eyesOpenValue: Int = eyesOpen.value!.intValue
                        let eyesOpenConfidence: Double = eyesOpen.confidence!.doubleValue
                        let eyesOpenBool = EyeOpen(rawValue: eyesOpenValue)?.returnBool(confidence: eyesOpenConfidence)
                        print("\n-----Result of EyesOpen-----", "\nThe eyes on this face are open: \(eyesOpenBool!)")
                        print("\nPositive Score: \(Self.positiveScore)", "\nNegative Score: \(Self.negativeScore)")
                    }
                    
                    // Access Gender.
                    if let gender: AWSRekognitionGender = attributes.gender {
                        let genderName = Gender(rawValue: gender.value.rawValue)?.returnGenderName()
                        print("\n-----Result of Gender-----", "\nThe predicted gender of this face is \(genderName!).")
                    }
                    
                    // Access Smile.
                    if let smile: AWSRekognitionSmile = attributes.smile {
                        let smileValue: Int = smile.value!.intValue
                        let smileConfidence: Double = smile.confidence!.doubleValue
                        let smileBool = Smile(rawValue: smileValue)?.returnBool(confidence: smileConfidence)
                        print("\n-----Result of Smile-----", "\nThis face is smiling: \(smileBool!)")
                        print("\nPositive Score: \(Self.positiveScore)", "\nNegative Score: \(Self.negativeScore)")
                    }
                    
                    // Access Sunglasses.
                    if let sunglasses: AWSRekognitionSunglasses = attributes.sunglasses {
                        let sunglassesValue: Int = sunglasses.value!.intValue
                        let sunglassesConfidence: Double = sunglasses.confidence!.doubleValue
                        let sunglassesBool = Sunglasses(rawValue: sunglassesValue)?.returnBool(confidence: sunglassesConfidence)
                        print("\n-----Result of Sunglasses-----", "\nThis face is wearing sun glasses: \(sunglassesBool!)")
                        print("\nPositive Score: \(Self.positiveScore)", "\nNegative Score: \(Self.negativeScore)")
                    }
                }
                                
            } else if let error = error {
                print("\n-----failure-----", "\n\(error)")
            }
        }
    }
    
    func processImage(image: UIImage, completion: (Data) -> Void) {
        // Image must be .jpeg or .png format.
        guard let originalImageData = image.jpegData(compressionQuality: 1.0) else {
            print("Image data is nill.")
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
            
            if let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                self.calculateImageSize(imageData: compressedImageData)
                print("The size of compressed image is \(imageSizeKB)KB.")
                
                if imageSizeKB <= 5000.0 {
                    self.imageData = compressedImageData
                
                // In case of unexpected large bytes.
                } else {
                    if let maxCompressedImageData = image.jpegData(compressionQuality: 0.1) {
                        self.calculateImageSize(imageData: maxCompressedImageData)
                        print("The size of MaxCompressed image is \(imageSizeKB)KB.")
                        
                        if imageSizeKB <= 5000.0  {
                            self.imageData = maxCompressedImageData
                            
                        // In case of very unexpected huge bytes.
                        } else {
                            var resizedUiImage = image
                            
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
                        }
                    }
                }
            }
        }
        completion(self.imageData!)
    }
    
    func calculateImageSize(imageData: Data) {
        let imageSize: Int = NSData(data: imageData).count
        self.imageSizeKB = Double(imageSize) / 1000.0
    }
}
