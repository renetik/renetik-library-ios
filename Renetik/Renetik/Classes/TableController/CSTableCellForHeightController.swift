//
//  CSTableCellForHeightController.swift
//  Motorkari
//
//  Created by Rene Dohan on 12/31/17.
//  Copyright © 2017 Renetik Software. All rights reserved.
//

import Renetik
import RenetikObjc

public class CSTableCellForHeightController: CSMainController {
    private var cells: [UIView]!
    public var cell: UIView { cells.first! }

    @discardableResult
    public func construct(_ parent: CSMainController, _ cells: UIView...) -> Self {
        super.constructAsViewLess(in: parent)
        self.cells = cells
        return self
    }

    override public func onViewDidLayoutFirstTime() {
        super.onViewDidLayoutFirstTime()
        for cell in cells {
            view.add(cell).from(top: -500)
        }
    }

    override public func onViewDidLayout() {
        super.onViewDidLayout()
        for cell in cells {
            cell.width(parentMainController!.view.width)
        }
    }

    override public func onViewWillTransition(
        to size: CGSize, _ coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.onViewWillTransition(to: size, coordinator)
        for cell in cells {
            cell.width(size.width)
        }
    }
}
