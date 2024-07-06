//
//  CSSelectNameController.swift
//  Renetik
//
//  Created by Rene Dohan on 2/20/19.
//

import RenetikObjc

public class CSSelectNameController: CSMainController, UITableViewDelegate, UITableViewDataSource {
    public let table = UITableView.construct()
    public let search = CSSearchBarController()
    public var onCellCreate: ((UITableViewCell) -> Void)? = nil
    public var selectedName: CSName?
    private var names: [CSName] = []
    private var filteredData: [CSName] = []
    private var onSelected: ((CSName) -> Void)!
    private var onDelete: ((CSName) -> CSResponseProtocol)?

    @discardableResult
    public func construct(data: [CSName], onSelected: @escaping (CSName) -> Void) -> Self {
        names = data
        self.onSelected = onSelected
        return self
    }

    @discardableResult
    public func addDelete<T: AnyObject>(_ onDelete: @escaping (CSName) -> CSResponse<T>) -> Self {
        self.onDelete = onDelete
        menu(type: .edit) { $0.systemItem = self.table.toggleEditing().isEditing ? .cancel : .edit }
        return self
    }

    override public func onViewWillAppear() {
        super.onViewWillAppear()
        view.add(view: table).matchParent()
        table.hideEmptyCellsSeparatorByEmptyFooter()
        table.allowsMultipleSelectionDuringEditing = false

        search.construct(by: self) { _ in self.reload() }
        table.tableHeaderView = search.bar

        table.delegates(self)
        reload()
    }

    private func reload() {
        filteredData = names.filter(bySearch: search.text)
        table.reload()
    }

    public func tableView(_ tableView: UITableView,
                          cellForRowAt path: IndexPath) -> UITableViewCell
    {
        tableView.cell(style: .default, onCreate: onCellCreate)
            .also { $0.textLabel!.text = filteredData[path.row].name }
    }

    public func tableView(_: UITableView,
                          numberOfRowsInSection _: Int) -> Int
    {
        filteredData.count
    }

    public func tableView(_: UITableView,
                          didSelectRowAt path: IndexPath)
    {
        selectedName = filteredData[path.row]
        navigation.popViewController()
        onSelected!(selectedName!)
    }

    public func tableView(_: UITableView,
                          canEditRowAt _: IndexPath) -> Bool
    {
        onDelete.notNil
    }

    public func tableView(_: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt path: IndexPath)
    {
        if editingStyle == .delete {
            let value = filteredData[path.row]
            onDelete?(value).onSuccess {
                self.names.remove(value)
                if self.names.isEmpty { navigation.popViewController() } else { self.reload() }
            }
        }
    }
}
