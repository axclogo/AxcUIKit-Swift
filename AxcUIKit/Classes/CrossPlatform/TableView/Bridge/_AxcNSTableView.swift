//
//  _AxcNSTableView.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

#if canImport(AppKit)
import AxcBedrock

protocol AxcNSTableViewDelegate {
    func tableView(tableView: _AxcNSTableView, heightForHeaderInSection section: Int) -> CGFloat
    func tableView(tableView: _AxcNSTableView, viewForHeaderInSection section: Int) -> NSView?

    func tableView(tableView: _AxcNSTableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(tableView: _AxcNSTableView, viewForFooterInSection section: Int) -> NSView?
}

protocol AxcNSTableViewDataSource {
    /// 组数量
    func numberOfSectionsInTableView(tableView: _AxcNSTableView) -> Int
    /// 每组行数量
    func tableView(tableView: _AxcNSTableView, numberOfRowsInSection section: Int) -> Int
    /// 获取Cell
    func tableView(tableView: _AxcNSTableView, cellForRowAt indexPath: IndexPath) -> AxcTableViewCell
}

extension _AxcNSTableView {
    func reloadData() {
        _tableView.reloadData()
    }
}

extension _AxcNSTableView {
    /// 每行元素的类型
    enum RowItemType {
        case tableHeaderView(view: NSView)
        case sectionHeaderView(section: Int)
        case cell(indexPath: IndexPath)
        case sectionFooterView(section: Int)
        case tableFooterView(view: NSView)
    }
}

class _AxcNSTableView: AxcView {
    override func axc_layoutSubviews() {
        super.axc_layoutSubviews()
        _tableView.frame = bounds
    }

    override func makeUI() {
        super.makeUI()
    }

    var delegate: AxcNSTableViewDelegate?
    var dataSource: AxcNSTableViewDataSource?

    var tableHeaderView: NSView?
    var tableFooterView: NSView?

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
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CellView"),
                                                owner: self) as? NSTableCellView
        else { return nil }
        guard let dataSource = dataSource,
              let rowItemType = _rowItemTypeList.axc.object(at: row)
        else { return nil }
        // 获取索引
        switch rowItemType {
        case let .tableHeaderView(view: view):
            return view
        case let .sectionHeaderView(section: section):
            if let headerView = delegate?.tableView(tableView: self, viewForHeaderInSection: section) {
                return headerView
            }
        case let .cell(indexPath: indexPath):
            let cell = dataSource.tableView(tableView: self, cellForRowAt: indexPath)
            return cell
        case let .sectionFooterView(section: section):
            if let footerView = delegate?.tableView(tableView: self, viewForFooterInSection: section) {
                return footerView
            }
        case let .tableFooterView(view: view):
            return view
        }
        return nil
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let dataSource = tableView.dataSource as? NSTableViewSectionDataSource {
            let (_, sectionRow) = dataSource.tableView(tableView: tableView, sectionForRow: row)

            if sectionRow == 0 {
                return false
            }

            return true
        }
        return false
    }
}

extension _AxcNSTableView: NSTableViewDataSource {
    /// All counts of rows
    /// 所有行数
    func numberOfRows(in tableView: NSTableView) -> Int {
        _rowItemTypeList = _constructSectionModelList() // 统计
        return _rowItemTypeList.count
    }
}

#endif
