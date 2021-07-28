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
            Rekognition.positiveScore += confidence
            return "happy"
        case .two:
            Rekognition.negativeScore += confidence
            return "sad"
        case .three:
            Rekognition.negativeScore += confidence
            return "angry"
        case .four:
            Rekognition.negativeScore += confidence
            return "confused"
        case .five:
            Rekognition.negativeScore += confidence
            return "disgusted"
        case .six:
            Rekognition.positiveScore += confidence
            return "surprised"
        case .seven:
            Rekognition.positiveScore += confidence
            return "calm"
        case .eight:
            Rekognition.negativeScore += confidence
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
            Rekognition.negativeScore += (confidence / 2)
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
            Rekognition.negativeScore += confidence
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
            Rekognition.negativeScore += (confidence / 4)
            return false
        case .one:
            Rekognition.positiveScore += confidence
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
            Rekognition.positiveScore += (confidence / 2)
            Rekognition.negativeScore -= (confidence / 2)
            return true
        }
    }
}
