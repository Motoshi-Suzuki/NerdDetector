//
//  UserAttribute.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/12.
//

import SwiftUI

class UserAttribute {
    
    func setAttribute(feelinGoodArray: [Bool]) {
        if feelinGoodArray == [true, false] {
            SharedInstance.feelinGood = true
            
        } else if feelinGoodArray == [false, true] {
            SharedInstance.feelinGood = false
        }
    }
    
    func printMessage(messageForGood: String, messageForBad: String) {
        switch SharedInstance.feelinGood {
        case true:
            print(messageForGood)
        case false:
            print(messageForBad)
        }
    }
    
    func showMessage() -> String {
        
        if SharedInstance.failedToDetectFaces != true {
            if SharedInstance.noFaceDetected != true {
                return SharedInstance.sortedEmotionDict.first?.key ?? "good"
            // if noFaceDetected == true,
            } else {
                return "No face detected..."
            }
        // if failedToDetectFaces == true,
        } else {
            return "Something went wrong..."
        }
    }
}
