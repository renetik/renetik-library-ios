//
// Created by Rene Dohan on 12/15/19.
//

import RenetikObjc

public typealias CSTableControllerRow = CSAny
//                                        & Equatable & CustomStringConvertible
public typealias CSTableControllerParent = CSHasDialog & CSHasProgress & CSMainController &
    CSOperationController & UITableViewDataSource & UITableViewDelegate

public protocol CSTableControllerProtocol {
    var tableView: UITableView { get }
}

public typealias CSTableControllerType = CSTableControllerProtocol & UIViewController

public class CSTableController<Row: CSTableControllerRow, Data>: CSViewController, CSTableControllerProtocol {
    public var filter: CSTableControllerFilter<Row, Data>?

    public var data: [Row] { filteredData }
    public var loadData: (() -> CSOperation<Data>)!
    public let onLoading: CSEvent<CSProcess<Data>> = event()
    public var isLoading = false
    public private(set) var isFirstLoadingDone = false
    public private(set) var isFailed = false
    public private(set) var failedMessage: String?

    public let tableView = UITableView.construct().also { $0.estimatedRowHeight = 0 }

    var parentController: CSTableControllerParent!
    var _data: [Row]!

    private var filteredData = [Row]()
    private var loadProcess: CSProcess<Data>? = nil

    public func construct(by parent: CSTableControllerParent,
                          parentView: UIView? = nil, data: [Row] = [Row]()) -> Self
    {
        super.construct(parent)
        parentController = parent
        tableView.delegates(parent)
        filter = parentController as? CSTableControllerFilter
        _data = data
        parentController.showChild(controller: self, parentView: parentView ?? parent.view)
        view.matchParent()
        return self
    }

    override public func loadView() { view = tableView }

    override public func onViewWillAppearLater() {
        super.onViewWillAppearLater()
        tableView.reload()
    }

    override public func onViewDidAppearFirstTime() {
        super.onViewDidAppearFirstTime()
        if _data.hasItems { filterDataAndReload() }
    }

    override public func onViewDidTransition(
        to _: CGSize, _: UIViewControllerTransitionCoordinatorContext
    ) {
        tableView.reload()
    }

    public var dataCount: Int { filteredData.count }

    @discardableResult
    public func reload(withProgress: Bool = true, refresh: Bool = false) -> CSProcess<Data> {
        if isLoading { loadProcess!.cancel() }
        isLoading = true
        tableView.reload()
        return parentController.send(operation: loadData().refresh(refresh),
                                     progress: withProgress, failedDialog: false)
            .onFailed { process in
                self.isFailed = true
                self.failedMessage = process.message
                self.clear()
//                    self.tableView.reload()
            }.onCancel { process in
                self.isFailed = true
                self.failedMessage = process.message
            }.onDone { _ in
                self.isLoading = false
                self.isFirstLoadingDone = true
                self.tableView.reload()
            }.also { process in
                self.loadProcess = process
                onLoading.fire(process)
            }
    }

    @discardableResult
    public func load(_ array: [Row]) -> Self {
        _data.reload(array)
        filterDataAndReload()
        isFailed = false
        tableView.fadeIn()
        return self
    }

    public func load(add dataToAdd: [Row]) {
        _data.add(array: dataToAdd)
        let filteredDataToAdd = filter(data: dataToAdd)
        var paths = [IndexPath]()
        for index in 0 ..< filteredDataToAdd.count {
            paths.add(IndexPath(row: index + dataCount, section: 0))
        }
        filteredData.add(array: filteredDataToAdd)
        tableView.beginUpdates()
        tableView.insertRows(at: paths, with: .automatic)
        tableView.endUpdates()
        isFailed = false
    }

    func filterDataAndReload() {
        filteredData.reload(filter(data: _data))
        tableView.reload()
        filter?.onReloadDone(in: self)
    }

    private func filter(data: [Row]) -> [Row] { filter?.filter(data: data) ?? data }
}

public extension CSTableController {
    func dequeue<CellType: UITableViewCell>(
        cell type: CellType.Type, onCreate function: ((CellType) -> Void)? = nil
    ) -> CellType {
        tableView.dequeue(cell: type, onCreate: function)
    }
}
