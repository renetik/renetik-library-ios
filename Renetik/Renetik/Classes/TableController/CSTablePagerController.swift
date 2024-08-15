//
// Created by Rene Dohan on 12/25/19.
//

import Foundation
import RenetikObjc
import UIKit

public class CSTablePagerController<Row: CSTableControllerRow, Data>: NSObject {
    var table: CSTableController<Row, Data>!
    var onLoadPage: ((Int) -> CSOperation<Data>)!
    private var pageIndex = -1
    private var noNext = false
    private var loadNextView: UIView?
    private var loadNextColor: UIColor? = .gray

    public var onShouldLoadNext: ((IndexPath) -> Bool)?

    public func construct(by controller: CSTableController<Row, Data>,
                          onLoadPage: @escaping (Int) -> CSOperation<Data>) -> Self
    {
        table = controller
        self.onLoadPage = onLoadPage
        table.loadData = onLoad
        return self
    }

    func onLoad() -> CSOperation<Data> {
        noNext = false
        pageIndex = 0
        return onLoadPage(pageIndex)
    }

    @discardableResult
    public func load(_ array: [Row]) -> Self {
        (pageIndex == 0).then { table.load(array) }.elseDo { table.load(add: array) }
        (array.hasItems).then { pageIndex += 1 }.elseDo { noNext = true }
        return self
    }

    public func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt path: IndexPath) {
        if shouldLoadNext(path: path) { loadNext() }
    }

    private func shouldLoadNext(path: IndexPath) -> Bool {
        if table.isLoading { return false }
        var loadStartIndex = 5
        if UIScreen.isPortrait && UIDevice.isTablet { loadStartIndex = 10 }
        if UIScreen.isLandscape && UIDevice.isTablet { loadStartIndex = 9 }
        if UIScreen.isPortrait && UIDevice.isPhone { loadStartIndex = 8 }
        if UIScreen.isLandscape && UIDevice.isPhone { loadStartIndex = 7 }
        let pathInPositionForLoadNext = path.row >= table.dataCount - loadStartIndex
        return !noNext && pathInPositionForLoadNext && (onShouldLoadNext?(path) ?? true)
    }

    private func loadNext() {
        if table.isLoading { return }
        table.isLoading = true
        showLoadNextIndicator()
        onLoadPage(pageIndex).send().onFailed { _ in
            self.table.parentController.toast(CSStrings.tableLoadNextFailed)
        }.onDone { _ in
            self.table.isLoading = false
            self.loadNextView?.removeFromSuperview()
        }
    }

    private func showLoadNextIndicator() {
        table.tableView.superview!.add(view: loadNextView ?? createLoadNextView())
            .from(bottom: 15).centeredHorizontal()
    }

    private func createLoadNextView() -> UIView {
        UIActivityIndicatorView(style: .large).also { view in
            loadNextColor.notNil { view.color = $0 }
            view.startAnimating()
            self.loadNextView = view
        }
    }
}
