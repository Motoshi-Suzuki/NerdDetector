//
//  Instance.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/18.
//

import SwiftUI

class ImageClass: ObservableObject {
    @Published var image: Image?
}

struct SharedInstance {
    static var isNerd = false
    static var failedToDetectFaces = false
    static var noFaceDetected = false
    static var uiImage = UIImage()
    static var resultUiImage = UIImage()
    static var positiveScore: Double = 0.0
    static var negativeScore: Double = 0.0
}
