//
// Created by Rene Dohan on 12/23/19.
//

import Foundation
import RenetikObjc
import SDWebImage
import UIKit

public extension UIImageView {
    @discardableResult
    func image(url: URL, onSuccess: ((UIImageView) -> Void)? = nil) -> UIImageView {
        sd_imageIndicator = SDWebImageProgressIndicator.default
        sd_setImage(with: url, placeholderImage: nil, options: .retryFailed, progress: nil,
                    completed: { _, error, _, _ in error.isNil { onSuccess?(self) } })
        return self
    }

    @discardableResult
    func image(url: String, onSuccess: ((UIImageView) -> Void)? = nil) -> UIImageView {
        URL(string: url).notNil { image(url: $0, onSuccess: onSuccess) }
            .elseDo { "Url for image was invalid: \(url)" }
        return self
    }
}
