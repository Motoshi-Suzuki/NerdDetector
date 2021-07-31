//
//  Extension.swift
//  NerdDetector
//
//  Created by Motoshi Suzuki on 2021/07/20.
//

import UIKit

extension UIImage {
    func resize(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

extension Notification.Name {
    static let detectFacesFinished = Notification.Name("detectFacesFinished")
}
