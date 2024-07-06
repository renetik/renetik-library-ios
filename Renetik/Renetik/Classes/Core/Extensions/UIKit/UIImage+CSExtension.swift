//
// Created by Rene Dohan on 9/22/19.
//

import RenetikObjc
import UIKit

public extension UIImage {
    convenience init(_ fileName: String) {
        self.init(named: fileName)!
    }

    func imageWith(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func inverseColor() -> UIImage {
        var coreImage = CIImage(cgImage: cgImage!)
        var filter = CIFilter(name: "CIColorInvert")!
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        let result = filter.value(forKey: kCIOutputImageKey) as! CIImage
        return UIImage(ciImage: result)
    }

    var template: UIImage {
        withRenderingMode(.alwaysTemplate)
    }

    func scale(width: CGFloat) -> UIImage {
        let oldWidth = size.width
        let scaleFactor = width / oldWidth
        return scale(width: oldWidth * scaleFactor, height: size.height * scaleFactor)
    }

    func scale(height: CGFloat) -> UIImage {
        let oldHeight = size.height
        let scaleFactor = height / oldHeight
        return scale(width: size.width * scaleFactor, height: oldHeight * scaleFactor)
    }

    func scale(width newWidth: CGFloat, height newHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    func scaleAndRotateFromCamera(_ maxResolution: CGFloat) -> UIImage {
        let imgRef = cgImage!
        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        if width > maxResolution || height > maxResolution {
            let ratio = width / height
            if ratio > 1 {
                bounds.size.width = maxResolution
                bounds.size.height = CGFloat(roundf(Float(bounds.size.width / ratio)))
            } else {
                bounds.size.height = maxResolution
                bounds.size.width = CGFloat(roundf(Float(bounds.size.height * ratio)))
            }
        }
        let scaleRatio = bounds.size.width / width
        let imageSize = CGSize(width: width, height: height)
        var transform: CGAffineTransform? = nil

        switch imageOrientation {
        case .up /* EXIF = 1 */:
            transform = CGAffineTransform.identity
        case .upMirrored /* EXIF = 2 */:
            transform = CGAffineTransform(translationX: width, y: 0.0).scaledBy(x: -1.0, y: 1.0)
        case .down /* EXIF = 3 */:
            transform = CGAffineTransform(translationX: width, y: height).rotated(by: .pi)
        case .downMirrored /* EXIF = 4 */:
            transform = CGAffineTransform(translationX: 0.0, y: height).scaledBy(x: 1.0, y: -1.0)
        case .leftMirrored:
            bounds.size.height = bounds.size.width
            bounds.size.width = bounds.size.height
            transform = CGAffineTransform(translationX: height, y: width)
                .scaledBy(x: -1.0, y: 1.0).rotated(by: 3.0 * .pi / 2.0)
        case .left:
            bounds.size.height = bounds.size.width
            bounds.size.width = bounds.size.height
            transform = CGAffineTransform(translationX: 0.0, y: width).rotated(by: 3.0 * .pi / 2.0)
        case .rightMirrored:
            bounds.size.height = bounds.size.width
            bounds.size.width = bounds.size.height
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0).rotated(by: .pi / 2.0)
        case .right:
            bounds.size.height = bounds.size.width
            bounds.size.width = bounds.size.height
            transform = CGAffineTransform(translationX: height, y: 0.0).rotated(by: .pi / 2.0)
        @unknown default:
            NSException(name: "Invalid image orientation").raise()
        }

        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()!
        if imageOrientation == .right || imageOrientation == .left {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -height)
        }
        context.concatenate(transform!)
        context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageCopy!
    }
}
