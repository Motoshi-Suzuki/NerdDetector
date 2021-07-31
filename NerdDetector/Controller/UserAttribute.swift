//
//  UserAttribute.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/12.
//

import SwiftUI

class UserAttribute {
    
    func setAttribute(isNerdArray: [Bool]) {
        if isNerdArray == [true, false] {
            SharedInstance.isNerd = true
            
        } else if isNerdArray == [false, true] {
            SharedInstance.isNerd = false
        }
    }
    
    func printMessage(messageForNerd: String, messageForNonNerd: String) {
        switch SharedInstance.isNerd {
        case true:
            print(messageForNerd)
        case false:
            print(messageForNonNerd)
        }
    }
    
    func showMessage() -> String {
        
        if SharedInstance.failedToDetectFaces != true {
            if SharedInstance.noFaceDetected != true {
                
                switch SharedInstance.isNerd {
                case true:
                    if SharedInstance.positiveScore > SharedInstance.negativeScore {
                        return "Oh, you may not be a Nerd."
                    } else {
                        return "You are a real Nerd!!"
                    }
                case false:
                    if SharedInstance.positiveScore > SharedInstance.negativeScore {
                        return "You are not a Nerd."
                    } else {
                        return "Oh, it seems you are a Nerd."
                    }
                }
            // if noFaceDetected == true,
            } else {
                return "No face detected."
            }
        // if failedToDetectFaces == true,
        } else {
            return "Oops...something went wrong."
        }
    }
}
