//
// Created by Rene on 2018-11-29.
//

import UIKit

private let DEFAULT_CELL_ID = "emptyCellIdentifier"

public extension UICollectionView {
    override open func construct() -> Self {
        super.construct()
        return background(.clear)
    }

    @discardableResult
    func construct(_ parent: UICollectionViewDelegate & UICollectionViewDataSource) -> Self {
        construct()
        delegates(parent)
        registerDefaultCell()
        reloadData()
        return self
    }

    @discardableResult
    func delegates(_ parent: UICollectionViewDelegate & UICollectionViewDataSource) -> Self {
        delegate = parent
        dataSource = parent
        return self
    }

    @discardableResult
    func register<CellType: UICollectionViewCell>(cell cellType: CellType.Type) -> Self {
        register(cellType, forCellWithReuseIdentifier: cellType.className())
        return self
    }

    func dequeue<CellType: UICollectionViewCell>(
        cell cellType: CellType.Type, _ path: IndexPath, onCreate: ((CellType) -> Void)? = nil
    ) -> CellType {
        var cell = dequeueReusableCell(withReuseIdentifier: cellType.className(), for: path) as! CellType
        if cell.contentView.isEmpty {
//            cell.contentView.matchParent()
            cell.construct()
            onCreate?(cell)
        }
        return cell
    }

    func scrollToPage() {
        var currentCellOffset = contentOffset
        currentCellOffset.x += width / 2
        var path = indexPathForItem(at: currentCellOffset)
        if path.isNil {
            currentCellOffset.x += 15
            path = indexPathForItem(at: currentCellOffset)
        }
        if path != nil {
            logInfo("Scrolling to page \(path!)")
            scrollToItem(at: path!, at: .centeredHorizontally, animated: true)
        }
    }

    func registerDefaultCell() -> Self {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: DEFAULT_CELL_ID)
        return self
    }
}
