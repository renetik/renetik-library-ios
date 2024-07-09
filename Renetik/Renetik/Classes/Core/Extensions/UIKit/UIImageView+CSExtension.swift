//
// Created by Rene Dohan on 3/4/20.
//

import Foundation

public extension UIImageView {
    class func construct(_ image: UIImage) -> Self {
        construct().image(image)
    }

    override func construct() -> Self {
        super.construct().aspectFit().clipsToBounds()
        return self
    }

    func resizableImage(capInsets insets: UIEdgeInsets) -> Self {
        invoke { image = image!.resizableImage(withCapInsets: insets) }
    }

    @discardableResult
    func image(_ image: UIImage?) -> Self { invoke { self.image = image } }

    @discardableResult
    func image(template image: UIImage) -> Self { self.image(image.template) }

    func stretchableImage(leftCapWidth: Int, topCapHeight: Int) -> Self {
        image = image!.stretchableImage(withLeftCapWidth: leftCapWidth, topCapHeight: topCapHeight)
        return self
    }

    @discardableResult
    func roundImageCorners(_ radius: Int = 5) -> Self {
        if let image = image {
            let boundsScale = bounds.size.width / bounds.size.height
            let imageScale = image.size.width / image.size.height
            var drawingRect = bounds
            if boundsScale > imageScale {
                drawingRect.size.width = drawingRect.size.height * imageScale
                drawingRect.origin.x = (bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: CGFloat(radius))
            layer.mask = CAShapeLayer().also { $0.path = path.cgPath }
            layer.masksToBounds = true
            clipsToBounds = true
        }
        return self
    }
}
