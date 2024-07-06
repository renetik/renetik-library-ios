//
// Created by Rene Dohan on 6/11/20.
//

// import Foundation
//
// public class CSTableStringSearchFilter<Row: CSTableControllerRow, Data>: CSTableControllerFilter<Row, Data>
//        where Row: CustomStringConvertible & Equatable {
//
//    public var searchText = "" { didSet { table.filterDataAndReload() } }
//
//    private var table: CSTableController<Row, Data>!
//
//    @discardableResult
//    public func construct(_ table: CSTableController<Row, Data>,
//                          _ searchText: String? = nil) -> Self {
//        self.table = table
//        searchText.notNil { self.searchText = $0 }
//        table.filter = self
//        return self
//    }
//
//    public override func filter(data: [Row]) -> [Row] { data.filter(bySearch: searchText) }
// }
