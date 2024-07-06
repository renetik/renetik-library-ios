//
// Created by Rene Dohan on 12/17/19.
//

import RenetikObjc
import UIKit

public class CSSearchBarController: CSMainController, UISearchBarDelegate {
    public let bar = UISearchBar.construct().resizeToFit()
    public var text: String { bar.text ?? "" }

    private var searchBarShouldBeginEditing = false
    private var onTextChanged: ((String) -> Void)!

    @discardableResult
    public func construct(by parent: CSMainController,
                          placeHolder: String = CSStrings.searchPlaceholder,
                          onTextChanged: @escaping (String) -> Void) -> Self
    {
        super.constructAsViewLess(in: parent)
        self.onTextChanged = onTextChanged
        bar.delegate = self
        bar.showsCancelButton = false
        bar.placeholder = placeHolder
        return self
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.isFirstResponder {
            searchBarShouldBeginEditing = false
            searchBar.resignFirstResponder()
        }
        onTextChanged(searchText)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    public func searchBarShouldBeginEditing(_: UISearchBar) -> Bool {
        let boolToReturn = searchBarShouldBeginEditing
        searchBarShouldBeginEditing = true
        return boolToReturn
    }

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animate { searchBar.showsCancelButton = true }
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        animate { searchBar.showsCancelButton = false }
    }
}

// CSSearchBarController+CSTableController
public extension CSSearchBarController {
    @discardableResult
    func construct<Row: CSTableControllerRow, Data>(
        _ parent: CSMainController,
        placeHolder: String = CSStrings.searchPlaceholder,
        table: CSTableController<Row, Data>
    ) -> Self
        where Row: CustomStringConvertible
    {
        let tableFilter = TableFilter<Row, Data>()
        table.filter = tableFilter
        construct(by: parent, placeHolder: placeHolder) { string in
            tableFilter.searchText = string
            table.filterDataAndReload()
        }
        return self
    }
}

private class TableFilter<Row: CSTableControllerRow, Data>: CSTableControllerFilter<Row, Data>
    where Row: CustomStringConvertible
{
    public var searchText = ""

    override public func filter(data: [Row]) -> [Row] { data.filter(bySearch: searchText) }
}
