//
// Created by Rene Dohan on 11/17/20.
//

import Foundation
import UIKit

public class CSImageView: UIImageView {
    enum HorizontalAlignment {
        case left, center, right
    }

    enum VerticalAlignment {
        case top, center, bottom
    }

    var horizontalAlignment: HorizontalAlignment = .center
    var verticalAlignment: VerticalAlignment = .bottom

    override public var image: UIImage? {
        didSet {
            updateContentsRect()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateContentsRect()
    }

    private func updateContentsRect() {
        var contentsRect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))

        guard let imageSize = image?.size else {
            layer.contentsRect = contentsRect
            return
        }

        let viewBounds = bounds
        let imageViewFactor = viewBounds.size.width / viewBounds.size.height
        let imageFactor = imageSize.width / imageSize.height

        if imageFactor > imageViewFactor {
            // Image is wider than the view, so height will match
            let scaledImageWidth = viewBounds.size.height * imageFactor
            var xOffset: CGFloat = 0.0

            if case .left = horizontalAlignment {
                xOffset = -(scaledImageWidth - viewBounds.size.width) / 2
            } else if case .right = horizontalAlignment {
                xOffset = (scaledImageWidth - viewBounds.size.width) / 2
            }

            contentsRect.origin.x = xOffset / scaledImageWidth
        } else {
            let scaledImageHeight = viewBounds.size.width / imageFactor
            var yOffset: CGFloat = 0.0

            if case .top = verticalAlignment {
                yOffset = -(scaledImageHeight - viewBounds.size.height) / 2
            } else if case .bottom = verticalAlignment {
                yOffset = (scaledImageHeight - viewBounds.size.height) / 2
            }

            contentsRect.origin.y = yOffset / scaledImageHeight
        }

        layer.contentsRect = contentsRect
    }
}
