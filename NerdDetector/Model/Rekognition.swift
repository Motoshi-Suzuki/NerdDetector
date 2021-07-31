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
    let detectFacesResult = DetectFacesResult()
    
    func detectFaces(imageData: Data) {
        
        SharedInstance.positiveScore = 0.0
        SharedInstance.negativeScore = 0.0
        SharedInstance.noFaceDetected = false
                
        self.rekognition = AWSRekognition.default()
        let detectFacesRequest = AWSRekognitionDetectFacesRequest()
        let rekognitionImage = AWSRekognitionImage()
        
        rekognitionImage?.bytes = imageData
        detectFacesRequest?.image = rekognitionImage
        detectFacesRequest?.attributes = ["ALL"]
        
        guard let request = detectFacesRequest else {
            print("DetectFaces request is nil.")
            self.detectFacesResult.terminateDetectFaces()
            return
        }
        
        // Ask AWSRekogniton to detect faces in an image.
        self.rekognition?.detectFaces(request) { response, error in
            if let response = response {
                print("\n-----success-----")
                
                let faceDetails: [AWSRekognitionFaceDetail]? = response.faceDetails
                guard faceDetails?.isEmpty != true else {
                    print("...but no face detected.")
                    SharedInstance.noFaceDetected = true
                    SharedInstance.resultUiImage = SharedInstance.uiImage
                    self.detectFacesResult.terminateDetectFaces()
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
                    
                    // Access BoundingBox.
                    if let boundingBox: AWSRekognitionBoundingBox = attributes.boundingBox {
                        let boundingBoxDict = ["height" : boundingBox.height,
                                               "left" : boundingBox.left,
                                               "top" : boundingBox.top,
                                               "width" : boundingBox.width] as! [String : CGFloat]
                        self.detectFacesResult.synthesiseBoundingBox(boundingBoxInfo: boundingBoxDict)
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
                        print("\nPositive Score: \(SharedInstance.positiveScore)", "\nNegative Score: \(SharedInstance.negativeScore)")
                    }
                    
                    // Access Eyeglasses.
                    if let eyeglasses: AWSRekognitionEyeglasses = attributes.eyeglasses {
                        let eyeglassesValue: Int = eyeglasses.value!.intValue
                        let eyeglassesConfidence: Double = eyeglasses.confidence!.doubleValue
                        let eyeglassesBool = Eyeglasses(rawValue: eyeglassesValue)?.returnBool(confidence: eyeglassesConfidence)
                        print("\n-----Result of Eyeglasses-----", "\nThis face is wearing eye glasses: \(eyeglassesBool!)")
                        print("\nPositive Score: \(SharedInstance.positiveScore)", "\nNegative Score: \(SharedInstance.negativeScore)")
                    }
                    
                    // Access EyesOpen.
                    if let eyesOpen: AWSRekognitionEyeOpen = attributes.eyesOpen {
                        let eyesOpenValue: Int = eyesOpen.value!.intValue
                        let eyesOpenConfidence: Double = eyesOpen.confidence!.doubleValue
                        let eyesOpenBool = EyeOpen(rawValue: eyesOpenValue)?.returnBool(confidence: eyesOpenConfidence)
                        print("\n-----Result of EyesOpen-----", "\nThe eyes on this face are open: \(eyesOpenBool!)")
                        print("\nPositive Score: \(SharedInstance.positiveScore)", "\nNegative Score: \(SharedInstance.negativeScore)")
                    }
                    
                    // Access Gender.
                    if let gender: AWSRekognitionGender = attributes.gender {
                        let genderName = Gender(rawValue: gender.value.rawValue)?.returnGenderName()
                        print("\n-----Result of Gender-----", "\nThe predicted gender of this face is \(genderName!).")
                    }
                    
                    // Access Landmarks.
//                    if let landmarks: [AWSRekognitionLandmark] = attributes.landmarks {
//                        for i in landmarks {
//                            let landmarkDict = ["x" : i.x, "y" : i.y] as! [String : CGFloat]
//                            self.detectFacesResult.synthesiseLandmarks(landmarkInfo: landmarkDict)
//                        }
//                    }
                    
                    // Access Smile.
                    if let smile: AWSRekognitionSmile = attributes.smile {
                        let smileValue: Int = smile.value!.intValue
                        let smileConfidence: Double = smile.confidence!.doubleValue
                        let smileBool = Smile(rawValue: smileValue)?.returnBool(confidence: smileConfidence)
                        print("\n-----Result of Smile-----", "\nThis face is smiling: \(smileBool!)")
                        print("\nPositive Score: \(SharedInstance.positiveScore)", "\nNegative Score: \(SharedInstance.negativeScore)")
                    }
                    
                    // Access Sunglasses.
                    if let sunglasses: AWSRekognitionSunglasses = attributes.sunglasses {
                        let sunglassesValue: Int = sunglasses.value!.intValue
                        let sunglassesConfidence: Double = sunglasses.confidence!.doubleValue
                        let sunglassesBool = Sunglasses(rawValue: sunglassesValue)?.returnBool(confidence: sunglassesConfidence)
                        print("\n-----Result of Sunglasses-----", "\nThis face is wearing sun glasses: \(sunglassesBool!)")
                        print("\nPositive Score: \(SharedInstance.positiveScore)", "\nNegative Score: \(SharedInstance.negativeScore)")
                    }
                }
                print("\n-----complete-----")
                self.detectFacesResult.terminateDetectFaces()
                
            } else if let error = error {
                print("\n-----failure-----", "\n\(error)")
                self.detectFacesResult.terminateDetectFaces()
            }
        }
    }
    
}
