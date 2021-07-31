//
//  RekognitionResult.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/29.
//

import Foundation
import UIKit

class DetectFacesResult {
        
    func synthesiseBoundingBox(boundingBoxInfo: [String : CGFloat]) {
        
        let resultUiImage = SharedInstance.resultUiImage
        let imageOrigin = CGPoint(x: 0, y: 0)
        let imageSize = CGSize(width: resultUiImage.size.width, height: resultUiImage.size.height)
        
        let boxOrigin = CGPoint(x: imageSize.width * boundingBoxInfo["left"]!, y: imageSize.height * boundingBoxInfo["top"]!)
        let boxSize = CGSize(width: imageSize.width * boundingBoxInfo["width"]!, height: imageSize.height * boundingBoxInfo["height"]!)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(origin: imageOrigin, size: imageSize)
        shapeLayer.path = UIBezierPath(rect: CGRect(origin: boxOrigin, size: boxSize)).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 10.0
        
        // Render BoundingBox to UIImage.
        UIGraphicsBeginImageContext(imageSize)
        let context = UIGraphicsGetCurrentContext()
        shapeLayer.render(in: context!)
        let boundingBoxImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Synthesise original image and BoundingBox image.
        UIGraphicsBeginImageContext(imageSize)
        resultUiImage.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        boundingBoxImage?.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        SharedInstance.resultUiImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        print("\n-----BoundingBox Synthesised-----")
    }
    
//    func synthesiseLandmarks(landmarkInfo: [[String : CGFloat]]) {
//
//        var resultUiImage = SharedInstance.resultUiImage
//        let shapeLayer = CAShapeLayer()
//
//        let imageOrigin = CGPoint(x: 0, y: 0)
//        let imageSize = CGSize(width: resultUiImage.size.width, height: resultUiImage.size.height)
//
//        for (index, element) in landmarkInfo.enumerated() {
//
//            guard index < 10 else {
//                print("Stop synthesising Landmarks.")
//                break
//            }
//
//            let dotOrigin = CGPoint(x: imageSize.width * element["x"]! - 20, y: imageSize.height * element["y"]! - 20)
//            let dotSize = CGSize(width: 40, height: 40)
//
//            // Draw Landmark dots.
//            shapeLayer.frame = CGRect(origin: imageOrigin, size: imageSize)
//            let path = UIBezierPath(ovalIn: CGRect(origin: dotOrigin, size: dotSize))
//            path.fill()
//            shapeLayer.path = path.cgPath
//            shapeLayer.fillColor = UIColor.white.cgColor
//        }
//
//        // Render Landmark dots to UIImage.
//        UIGraphicsBeginImageContext(imageSize)
//        let context = UIGraphicsGetCurrentContext()
//        shapeLayer.render(in: context!)
//        let dotImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        // Synthesise original image and Landmark image.
//        UIGraphicsBeginImageContext(imageSize)
//        resultUiImage.draw(in: CGRect(origin: imageOrigin, size: imageSize))
//        dotImage?.draw(in: CGRect(origin: imageOrigin, size: imageSize))
//        resultUiImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//    }
    
    func terminateDetectFaces() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NotificationCenter.default.post(name: .detectFacesFinished, object: nil)
        }
        print("DetectFaces is terminated.")
    }
}
