//
//  CSTableController+Data.swift
//
//  Created by Rene Dohan on 3/8/19.
//

import RenetikObjc
import UIKit

public extension CSTableController {
    func data(for path: IndexPath) -> Row { data[path.row] }

    func height<View: CSTableHeightCalculatingCell>(for path: IndexPath, _ view: View) -> CGFloat
        where View.Row == Row
    {
        view.height(for: data(for: path))
    }

    @discardableResult
    func add(item: Row) -> Self {
        _data.add(item)
        filterDataAndReload()
        return self
    }

    @discardableResult
    func insert(item: Row, index: Int) -> Self {
        _data.insert(item, at: index)
        filterDataAndReload()
        return self
    }

    @discardableResult
    func remove(item index: Int) -> Self {
        _data.remove(at: index)
        filterDataAndReload()
        return self
    }

    @discardableResult
    func clear() -> Self {
        _data.removeAll()
        filterDataAndReload()
        return self
    }
}

public extension CSTableController where Row: Equatable {
    @discardableResult
    func reload(row: Row) -> Self {
        let tableIsAtBottom = isAtBottom()
        let index = data.index(of: row)!
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        if tableIsAtBottom { scrollToBottom() }
        return self
    }

    @discardableResult
    func remove(item: Row) -> Self {
        _data.remove(item)
        filterDataAndReload()
        return self
    }
}
