//
// Created by Rene Dohan on 12/22/19.
//

import UIKit

open class CSView: UIView {
    public let layoutFunctions: CSEvent<Void> = event()
    public let eventLayoutSubviewsFirstTime: CSEvent<Void> = event()

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

    private var isDidLayoutSubviews = false

    override open func layoutSubviews() {
        super.layoutSubviews()
        if !isDidLayoutSubviews {
            isDidLayoutSubviews = true
            onLayoutSubviewsFirstTime()
            onCreateLayout()
            onLayoutCreated()
            eventLayoutSubviewsFirstTime.fire()
        } else {
            onUpdateLayout()
        }
        updateLayout()
        onLayoutSubviews()
    }

    open func onLayoutSubviewsFirstTime() {}

    open func onCreateLayout() {}

    open func onLayoutCreated() {}

    open func onUpdateLayout() {}

    open func onLayoutSubviews() {}

    @discardableResult
    public func updateLayout() -> Self { layoutFunctions.fire(); return self }
}
