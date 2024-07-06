//
// Created by Rene Dohan on 3/10/20.
// Copyright (c) 2020 Renetik Software. All rights reserved.
//

import Foundation
import MaterialComponents.MDCCard
import Renetik
import RenetikObjc

open class CSTitleSubtitleCell: CSTableViewCell {
    public let card = MDCCard.construct()
    public let titleLabel = UILabel.construct()
    public let subtitleLabel = UILabel.construct()

    var onCLick: Func?

    override open func construct() -> Self {
        super.construct()
        contentView.add(card).matchParent(margin: 5)
        layout(card.add(titleLabel).from(top: 7).matchParentWidth(margin: 7)) {
            $0.heightToFit()
        }
        layout(card.add(subtitleLabel).matchParentWidth(margin: 7)) {
            $0.from(self.titleLabel, top: 7).heightToFit()
        }
        card.onTouchUp { self.onCLick?() }
        return self
    }

    public func load(title: String, subtitle: String? = nil, onCLick: Func? = nil) -> Self {
        self.onCLick = onCLick
        titleLabel.text(title)
        subtitleLabel.text(subtitle)
        return self
    }

    public func heightFor(title: String, subtitle: String? = nil) -> CGFloat {
        titleLabel.text(title)
        subtitleLabel.text(subtitle)
        layoutSubviews()
        return 5 + subtitleLabel.bottom + 7 + 5
    }
}
