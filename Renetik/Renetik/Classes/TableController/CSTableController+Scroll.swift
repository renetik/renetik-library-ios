//
// Created by Rene Dohan on 1/2/20.
//

import RenetikObjc

public extension CSTableController {
    @discardableResult
    func scroll(to index: Int, position _: UITableView.ScrollPosition = .middle) -> Self {
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        return self
    }

    @discardableResult
    func scrollToBottom() -> Self {
        if isLoading || isFirstLoadingDone.isFalse {
            onLoading.invokeOnce { response in response.onDone { _ in self.scrollToBottom() } }
        } else {
            later { self.scrollToBottom() }
        }
        return self
    }

    private func scrollToBottom() {
        if dataCount > 0 {
            let path = IndexPath(row: dataCount - 1, section: 0)
            tableView.scrollToRow(at: path, at: .bottom, animated: true)
        }
    }

    func isAtBottom() -> Bool {
        let lastPath = tableView.indexPathsForVisibleRows?.last
        if lastPath == nil { return true }
        if lastPath!.row == dataCount - 1 { return true }
        return false
    }
}

public extension CSTableController where Row: Equatable {
    @discardableResult
    func scroll(to row: Row, position: UITableView.ScrollPosition = .middle) -> Self {
        scroll(to: data.index(of: row)!, position: position)
    }
}
