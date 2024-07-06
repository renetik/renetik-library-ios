//
// Created by Rene on 2018-11-29.
//

import RenetikObjc
import UIKit

public extension UITableView {
    override open func construct() -> Self {
        super.construct()
        return self
    }

    @discardableResult
    func reloadKeepSelection() -> Self {
        let paths = indexPathsForSelectedRows
        reload()
        paths?.forEach { path in selectRow(at: path, animated: false, scrollPosition: .none) }
        return self
    }

    func cell(style: UITableViewCell.CellStyle,
              onCreate: ((UITableViewCell) -> Void)? = nil) -> UITableViewCell
    {
        cell(with: "Cell", style: style, onCreate: onCreate)
    }

    func cell(with identifier: String, style: UITableViewCell.CellStyle,
              onCreate: ((UITableViewCell) -> Void)? = nil) -> UITableViewCell
    {
        var cell = dequeueCellWith(identifier: identifier)
        if cell.isNil {
            cell = UITableViewCell(style: style, reuseIdentifier: identifier)
            onCreate?(cell!.construct())
        }
        return cell!
    }

    @discardableResult
    func register<CellType: UITableViewCell>(cell type: CellType.Type) -> Self {
        register(type, forCellReuseIdentifier: type.className())
        return self
    }

    private func dequeue<CellType: UITableViewCell>(cell type: CellType.Type) -> CellType {
        let cell = dequeueCellWith(identifier: type.className()) as? CellType
        return cell.isNil ? register(cell: type).dequeueCellWith(identifier: type.className()) as! CellType : cell!
    }

    func dequeue<CellType: UITableViewCell>(
        cell type: CellType.Type, onCreate: ((CellType) -> Void)? = nil
    ) -> CellType {
        var cell = dequeue(cell: type)
        if cell.contentView.isEmpty {
            onCreate?(cell)
            cell.contentView.matchParent()
            cell.width(width, height: width)
            cell.construct()
        }
        return cell
    }

    @discardableResult
    func toggleEditing(animated: Bool = true) -> Self {
        setEditing(!isEditing, animated: animated)
        return self
    }

    /*
     * This triggers table reload !!!
     */
    @discardableResult
    func hideEmptyCellsSeparatorByEmptyFooter() -> Self {
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        return self
    }

    func deselectSelectedRow(animated: Bool = true) {
        indexPathForSelectedRow?.then { path in deselectRow(at: path, animated: animated) }
    }

    func deselectSelectedRows(animated: Bool = true) {
        for path in indexPathsForSelectedRows ?? [] {
            deselectRow(at: path, animated: animated)
        }
    }

    func dequeueCellWith(identifier: String?) -> UITableViewCell? {
        dequeueReusableCell(withIdentifier: identifier ?? "")
    }

    @discardableResult
    func reload() -> Self {
        reloadData()
        return self
    }

    @discardableResult
    func set<View: UIView>(header view: View) -> View {
        tableHeaderView = view
        return view
    }

    @discardableResult
    func set(footer view: UIView?) -> UIView? {
        tableFooterView = view
        return view
    }

    @discardableResult
    func delegates(_ delegates: UITableViewDelegate & UITableViewDataSource) -> Self {
        delegate = delegates
        dataSource = delegates
        return self
    }

    @discardableResult
    func header<View: UIView>(_ view: View) -> View { tableHeaderView = view; return view }
}
