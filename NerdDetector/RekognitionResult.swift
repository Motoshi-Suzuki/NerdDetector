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
        
        print("synthesiseBoundingBox")
        let uiImage = SharedInstance.uiImage
        let imageOrigin = CGPoint(x: 0, y: 0)
        let imageSize = CGSize(width: uiImage.size.width, height: uiImage.size.height)
        
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
        uiImage.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        boundingBoxImage?.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        SharedInstance.resultUiImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        print("\n-----BoundingBox Synthesised-----")
    }
    
    func synthesiseLandmarks(landmarkInfo: [String : CGFloat]) {
        
        var resultUiImage = SharedInstance.resultUiImage
        let imageOrigin = CGPoint(x: 0, y: 0)
        let imageSize = CGSize(width: resultUiImage.size.width, height: resultUiImage.size.height)
        
        let dotOrigin = CGPoint(x: imageSize.width * landmarkInfo["x"]! - 2, y: imageSize.height * landmarkInfo["y"]! - 2)
        let dotSize = CGSize(width: 4, height: 4)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(origin: imageOrigin, size: imageSize)
        let path = UIBezierPath(ovalIn: CGRect(origin: dotOrigin, size: dotSize))
        path.fill()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        
        // Render Landmark to UIImage.
        UIGraphicsBeginImageContext(imageSize)
        let context = UIGraphicsGetCurrentContext()
        shapeLayer.render(in: context!)
        let dotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Synthesise original image and Landmark image.
        UIGraphicsBeginImageContext(imageSize)
        resultUiImage.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        dotImage?.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        resultUiImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    
    func terminateDetectFaces() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .detectFacesFinished, object: nil)
        }
        print("DetectFaces is terminated.")
    }
}
