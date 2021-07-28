//
//  RekognitionModel.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/27.
//

import Foundation

enum Emotions: Int {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    
    func returnEmotionName(confidence: Double) -> String {
        switch self {
        case .zero:
            return "unknown"
        case .one:
            SharedInstance.positiveScore += confidence
            return "happy"
        case .two:
            SharedInstance.negativeScore += confidence
            return "sad"
        case .three:
            SharedInstance.negativeScore += confidence
            return "angry"
        case .four:
            SharedInstance.negativeScore += confidence
            return "confused"
        case .five:
            SharedInstance.negativeScore += confidence
            return "disgusted"
        case .six:
            SharedInstance.positiveScore += confidence
            return "surprised"
        case .seven:
            SharedInstance.positiveScore += confidence
            return "calm"
        case .eight:
            SharedInstance.negativeScore += confidence
            return "fear"
        }
    }
}

enum Eyeglasses: Int {
    case zero
    case one
    
    func returnBool(confidence: Double) -> Bool {
        switch self {
        case .zero:
            return false
        case .one:
            SharedInstance.negativeScore += (confidence / 2)
            return true
        }
    }
}

enum EyeOpen: Int {
    case zero
    case one
    
    func returnBool(confidence: Double) -> Bool {
        switch self {
        case .zero:
            SharedInstance.negativeScore += confidence
            return false
        case .one:
            return true
        }
    }
}

enum Gender: Int {
    case zero
    case one
    case two
    
    func returnGenderName() -> String {
        switch self {
        case .zero:
            return "unknown"
        case .one:
            return "male"
        case .two:
            return "female"
        }
    }
}

enum Smile: Int {
    case zero
    case one
    
    func returnBool(confidence: Double) -> Bool {
        switch self {
        case .zero:
            SharedInstance.negativeScore += (confidence / 4)
            return false
        case .one:
            SharedInstance.positiveScore += confidence
            return true
        }
    }
}

enum Sunglasses: Int {
    case zero
    case one
    
    func returnBool(confidence: Double) -> Bool {
        switch self {
        case .zero:
            return false
        case .one:
            SharedInstance.positiveScore += (confidence / 2)
            SharedInstance.negativeScore -= (confidence / 2)
            return true
        }
    }
}
