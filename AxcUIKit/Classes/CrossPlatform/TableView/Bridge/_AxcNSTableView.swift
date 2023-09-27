//
//  _AxcNSTableView.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

#if canImport(AppKit)
import AxcBedrock

public protocol AxcNSTableViewDelegate {
    func tableView(tableView: _AxcNSTableView, heightForHeaderInSection section: Int) -> CGFloat
    func tableView(tableView: _AxcNSTableView, viewForHeaderInSection section: Int) -> NSView?
    func tableView(tableView: _AxcNSTableView, shouldSelectHeaderInSection section: Int) -> Bool

    func tableView(tableView: _AxcNSTableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(tableView: _AxcNSTableView, shouldSelectCellAtIndexPath indexPath: IndexPath) -> Bool

    func tableView(tableView: _AxcNSTableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(tableView: _AxcNSTableView, viewForFooterInSection section: Int) -> NSView?
    func tableView(tableView: _AxcNSTableView, shouldSelectFooterInSection section: Int) -> Bool
}

public extension AxcNSTableViewDelegate {
    func tableView(tableView: _AxcNSTableView, heightForHeaderInSection section: Int) -> CGFloat { return .Axc.Min }
    func tableView(tableView: _AxcNSTableView, viewForHeaderInSection section: Int) -> NSView? { return nil }
    func tableView(tableView: _AxcNSTableView, shouldSelectHeaderInSection section: Int) -> Bool { return false }

    func tableView(tableView: _AxcNSTableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 44 }
    func tableView(tableView: _AxcNSTableView, shouldSelectCellAtIndexPath indexPath: IndexPath) -> Bool { return true }

    func tableView(tableView: _AxcNSTableView, heightForFooterInSection section: Int) -> CGFloat { return .Axc.Min }
    func tableView(tableView: _AxcNSTableView, viewForFooterInSection section: Int) -> NSView? { return nil }
    func tableView(tableView: _AxcNSTableView, shouldSelectFooterInSection section: Int) -> Bool { return false }
}

public protocol AxcNSTableViewDataSource {
    /// 组数量
    func numberOfSectionsInTableView(tableView: _AxcNSTableView) -> Int
    /// 每组行数量
    func tableView(tableView: _AxcNSTableView, numberOfRowsInSection section: Int) -> Int
    /// 获取Cell
    func tableView(tableView: _AxcNSTableView, cellForRowAt indexPath: IndexPath) -> AxcTableViewCell
}

public extension AxcNSTableViewDataSource {
    func numberOfSectionsInTableView(tableView: _AxcNSTableView) -> Int { return 1 }
}

public extension _AxcNSTableView {
    func reloadData() {
        _tableView.reloadData()
    }
}

public extension _AxcNSTableView {
    /// 每行元素的类型
    enum RowItemType {
        case tableHeaderView(view: NSView)
        case sectionHeaderView(section: Int)
        case cell(indexPath: IndexPath)
        case sectionFooterView(section: Int)
        case tableFooterView(view: NSView)
    }
}

open class _AxcNSTableView: AxcView {
    open override func axc_layoutSubviews() {
        super.axc_layoutSubviews()
        _tableView.frame = bounds
    }

    open override func makeUI() {
        super.makeUI()

        addSubview(_tableView)
    }

    open var delegate: AxcNSTableViewDelegate?
    open var dataSource: AxcNSTableViewDataSource?

    open var tableHeaderView: NSView?
    open var tableFooterView: NSView?

    /// 组表
    private var _rowItemTypeList: [RowItemType] = []

    private lazy var _tableView: NSTableView = {
        let tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension _AxcNSTableView {
    /// 构建二维组数组
    func _constructSectionModelList() -> [RowItemType] {
        var rowItemTypeList: [RowItemType] = []
        // All cells
        guard let dataSource,
              let delegate
        else { return [] }
        if let tableHeaderView { // 头视图
            rowItemTypeList.append(.tableHeaderView(view: tableHeaderView))
        }
        for section in 0 ..< dataSource.numberOfSectionsInTableView(tableView: self) {
            // The headers count in section
            // 这组的组头视图数量
            if let _ = delegate.tableView(tableView: self, viewForHeaderInSection: section) {
                rowItemTypeList.append(.sectionHeaderView(section: section))
            }
            // The cell count in section
            // 这组的cell数量
            let cellCount = dataSource.tableView(tableView: self, numberOfRowsInSection: section)
            for row in 0 ..< cellCount {
                let indexPath = IndexPath(item: row, section: section)
                rowItemTypeList.append(.cell(indexPath: indexPath))
            }
            // The footers count in section
            // 这组的组尾视图数量
            if let _ = delegate.tableView(tableView: self, viewForFooterInSection: section) {
                rowItemTypeList.append(.sectionFooterView(section: section))
            }
        }
        if let tableFooterView { // 头视图
            rowItemTypeList.append(.tableFooterView(view: tableFooterView))
        }
        /*
         Because this table is a single group
         it is necessary to make multiple group effects in a single group
         因为这个table是单组的，所以要在单组中做出多组的效果
         */
        return rowItemTypeList
    }
}

extension _AxcNSTableView: NSTableViewDelegate {
    public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) { }

    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let rowItemType = _rowItemTypeList.axc.object(at: row) else { return nil }
        return rowItemType
    }

//    public func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
//        if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CellView"),
//                                             owner: self) {
//            return cellView
//        } else {
//            guard let dataSource = dataSource,
//                  let rowItemType = _rowItemTypeList.axc.object(at: row)
//            else { return nil }
//            var cellView: NSView?
//            switch rowItemType {
//            case let .tableHeaderView(view: view):
//                cellView = view
//            case let .sectionHeaderView(section: section):
//                if let headerView = delegate?.tableView(tableView: self, viewForHeaderInSection: section) {
//                    cellView = headerView
//                }
//            case let .cell(indexPath: indexPath):
//                let cell = dataSource.tableView(tableView: self, cellForRowAt: indexPath)
//                cellView = cell
//            case let .sectionFooterView(section: section):
//                if let footerView = delegate?.tableView(tableView: self, viewForFooterInSection: section) {
//                    cellView = footerView
//                }
//            case let .tableFooterView(view: view):
//                cellView = view
//            }
//            return cellView
//        }
//    }

    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        guard let delegate = delegate,
              let rowItemType = _rowItemTypeList.axc.object(at: row)
        else { return false }
        // 获取索引
        switch rowItemType {
        case .tableHeaderView:
            return false
        case let .sectionHeaderView(section: section):
            return delegate.tableView(tableView: self, shouldSelectHeaderInSection: section)
        case let .cell(indexPath: indexPath):
            return delegate.tableView(tableView: self, shouldSelectCellAtIndexPath: indexPath)
        case let .sectionFooterView(section: section):
            return delegate.tableView(tableView: self, shouldSelectFooterInSection: section)
        case .tableFooterView:
            return false
        }
    }

    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        guard let delegate = delegate,
              let rowItemType = _rowItemTypeList.axc.object(at: row)
        else { return .Axc.Min }
        // 获取索引
        switch rowItemType {
        case let .tableHeaderView(view: view):
            return view.frame.height
        case let .sectionHeaderView(section: section):
            return delegate.tableView(tableView: self, heightForHeaderInSection: section)
        case let .cell(indexPath: indexPath):
            return delegate.tableView(tableView: self, heightForRowAt: indexPath)
        case let .sectionFooterView(section: section):
            return delegate.tableView(tableView: self, heightForFooterInSection: section)
        case let .tableFooterView(view: view):
            return view.frame.height
        }
    }
}

extension _AxcNSTableView: NSTableViewDataSource {
    /// All counts of rows
    /// 所有行数
    public func numberOfRows(in tableView: NSTableView) -> Int {
        _rowItemTypeList = _constructSectionModelList() // 统计
        return _rowItemTypeList.count
    }
}

#endif
