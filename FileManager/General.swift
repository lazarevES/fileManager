//
//  General.swift
//  FileManager
//
//  Created by Егор Лазарев on 07.07.2022.
//

import UIKit

extension UIImage {
    func imageWithAlpha(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
