//
//  CSTableListDataLoader.swift
//
//  Created by Rene Dohan on 3/8/19.
//

import UIKit
import RenetikObjc

extension CSTableController {

    public func data(for path: IndexPath) -> RowType { filteredData[path.row] }

    public func add(item: RowType) {
        data.add(item)
        filterDataAndReload()
    }

    public func insert(item: RowType, index: Int) {
        data.insert(item, at: index)
        filterDataAndReload()
    }

    public func remove(item: RowType) {
        data.remove(item)
        filterDataAndReload()
    }

    public func remove(item index: Int) {
        data.remove(at: index)
        filterDataAndReload()
    }

    public func clear() {
        data.removeAll()
        filteredData.removeAll()
        tableView.reloadData()
    }
}