//
// Created by Rene Dohan on 2/18/20.
//

import UIKit

open class CSCollectionViewCell: UICollectionViewCell {
    private let layoutFunctions: CSEvent<Void> = event()

    @discardableResult
    public func layout(function: @escaping Func) -> Self {
        layoutFunctions.invoke { function() }
        function()
        return self
    }

    @discardableResult
    public func layout<View: UIView>(_ view: View, function: @escaping (View) -> Void) -> View {
        layoutFunctions.invoke { function(view) }
        function(view)
        return view
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        onLayoutSubviews()
        updateLayout()
    }

    open func onLayoutSubviews() {}

    private func updateLayout() { layoutFunctions.fire() }
}
