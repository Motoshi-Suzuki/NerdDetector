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

class SharedInstance {
    static var isNerd = false
    static var uiImage = UIImage()
    static var positiveScore: Double = 0.0
    static var negativeScore: Double = 0.0
}
