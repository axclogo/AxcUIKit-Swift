import XCTest
@testable import AxcUIKitTable
@testable import AxcUIKitCollection
@testable import AxcUIKitCore

#if canImport(UIKit)
import UIKit

final class AxcUIKitPlatformComponentTests: XCTestCase {
    func testUIKitTableAndCellKeepStandardConfiguration() {
        let table = AxcTableView(frame: .zero, style: .grouped)
        let cell = AxcTableViewCell(style: .subtitle, reuseIdentifier: "cell")

        XCTAssertEqual(table.style, .grouped)
        XCTAssertFalse(table.translatesAutoresizingMaskIntoConstraints)
        XCTAssertEqual(cell.reuseIdentifier, "cell")
        XCTAssertEqual(cell.style, .subtitle)
    }

    func testCollectionSupportsDefaultAndCustomLayouts() {
        let defaultCollection = AxcCollectionView()
        let customLayout = UICollectionViewFlowLayout()
        customLayout.scrollDirection = .horizontal
        let customCollection = AxcCollectionView(frame: .zero, collectionViewLayout: customLayout)

        XCTAssertTrue(defaultCollection.collectionViewLayout is UICollectionViewFlowLayout)
        XCTAssertTrue(customCollection.collectionViewLayout === customLayout)
        XCTAssertFalse(customCollection.translatesAutoresizingMaskIntoConstraints)
    }
}

#elseif canImport(AppKit)
import AppKit
@testable import AxcUIKitAppKit

final class AxcUIKitPlatformComponentTests: XCTestCase {
    func testMacTableBuildsAndRoutesEveryRowType() {
        let table = AxcTableView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let provider = TableProvider()
        table.delegate = provider
        table.dataSource = provider
        table.tableHeaderView = fixedView(height: 10)
        table.tableFooterView = fixedView(height: 12)

        let nativeTable = NSTableView()
        XCTAssertEqual(table.numberOfRows(in: nativeTable), 6)

        for row in 0 ..< 6 {
            XCTAssertNotNil(table.tableView(nativeTable, objectValueFor: nil, row: row))
            XCTAssertNotNil(table.tableView(nativeTable, viewFor: nil, row: row))
            _ = table.tableView(nativeTable, shouldSelectRow: row)
            XCTAssertGreaterThan(table.tableView(nativeTable, heightOfRow: row), 0)
        }

        XCTAssertFalse(table.tableView(nativeTable, shouldSelectRow: 0))
        XCTAssertTrue(table.tableView(nativeTable, shouldSelectRow: 1))
        XCTAssertTrue(table.tableView(nativeTable, shouldSelectRow: 2))
        XCTAssertFalse(table.tableView(nativeTable, shouldSelectRow: 4))
        XCTAssertFalse(table.tableView(nativeTable, shouldSelectRow: 5))
        XCTAssertNil(table.tableView(nativeTable, objectValueFor: nil, row: 100))
        XCTAssertNil(table.tableView(nativeTable, viewFor: nil, row: 100))
        table.reloadData()
    }

    func testMacTableDefaultsAndMissingProviders() {
        let table = AxcTableView()
        let nativeTable = NSTableView()
        let defaults = DefaultTableDelegate()
        let provider = TableProvider()

        XCTAssertEqual(provider.numberOfSectionsInTableView(tableView: table), 1)
        XCTAssertEqual(defaults.tableView(tableView: table, heightForRowAt: IndexPath(item: 0, section: 0)), 44)
        XCTAssertTrue(defaults.tableView(tableView: table, shouldSelectCellAtIndexPath: IndexPath(item: 0, section: 0)))
        XCTAssertFalse(defaults.tableView(tableView: table, shouldSelectHeaderInSection: 0))
        XCTAssertFalse(defaults.tableView(tableView: table, shouldSelectFooterInSection: 0))
        XCTAssertNil(defaults.tableView(tableView: table, viewForHeaderInSection: 0))
        XCTAssertNil(defaults.tableView(tableView: table, viewForFooterInSection: 0))
        XCTAssertLessThan(defaults.tableView(tableView: table, heightForHeaderInSection: 0), 0.001)
        XCTAssertLessThan(defaults.tableView(tableView: table, heightForFooterInSection: 0), 0.001)

        XCTAssertEqual(table.numberOfRows(in: nativeTable), 0)
        XCTAssertFalse(table.tableView(nativeTable, shouldSelectRow: 0))
        XCTAssertLessThan(table.tableView(nativeTable, heightOfRow: 0), 0.001)
        XCTAssertTrue(AxcTableViewCell() is AxcView)
    }

    func testConsoleAppendsTrimsAndClears() {
        let console = AxcConsoleView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        console.maximumCharacterCount = 8
        console.append(log: "first")
        console.append(log: "second")

        let appended = expectation(description: "日志刷新")
        DispatchQueue.main.async {
            let textView = console.subviews
                .compactMap { ($0 as? NSScrollView)?.documentView as? NSTextView }
                .first
            XCTAssertNotNil(textView)
            XCTAssertLessThanOrEqual(textView?.string.count ?? .max, 8)
            appended.fulfill()
        }
        wait(for: [appended], timeout: 1)

        console.clear()
        let cleared = expectation(description: "日志清空")
        DispatchQueue.main.async {
            let textView = console.subviews
                .compactMap { ($0 as? NSScrollView)?.documentView as? NSTextView }
                .first
            XCTAssertEqual(textView?.string, "")
            cleared.fulfill()
        }
        wait(for: [cleared], timeout: 1)

        console.maximumCharacterCount = 0
        console.append(log: "unlimited")
        let unlimited = expectation(description: "无限日志")
        DispatchQueue.main.async {
            let textView = console.subviews
                .compactMap { ($0 as? NSScrollView)?.documentView as? NSTextView }
                .first
            XCTAssertEqual(textView?.string, "unlimited\n")
            unlimited.fulfill()
        }
        wait(for: [unlimited], timeout: 1)
    }

    func testTargetDragFocusAndPassThroughBehavior() {
        let dragView = AxcTargetDragView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let focusView = NSView()
        var callbackURLs: [URL] = []
        dragView.callback.targetDraggingEnd { callbackURLs = $0 }

        dragView.set(focusView: focusView)
        XCTAssertTrue(dragView.focusView === focusView)
        XCTAssertTrue(focusView.isHidden)
        XCTAssertTrue(focusView.superview === dragView)
        XCTAssertNil(dragView.hitTest(.zero))

        dragView._setFocusView(isHidden: false)
        XCTAssertFalse(focusView.isHidden)
        dragView.draggingExited(nil)
        XCTAssertTrue(focusView.isHidden)
        dragView.concludeDragOperation(nil)
        XCTAssertTrue(focusView.isHidden)
        XCTAssertTrue(callbackURLs.isEmpty)

        dragView.set(focusView: nil)
        XCTAssertNil(dragView.focusView)
        XCTAssertNil(focusView.superview)
    }

    private func fixedView(height: CGFloat) -> NSView {
        return NSView(frame: CGRect(x: 0, y: 0, width: 100, height: height))
    }
}

private final class TableProvider: NSObject, AxcNSTableViewDataSource, AxcNSTableViewDelegate {
    func tableView(tableView: _AxcNSTableView, numberOfRowsInSection section: Int) -> Int { 2 }

    func tableView(tableView: _AxcNSTableView, cellForRowAt indexPath: IndexPath) -> AxcTableViewCell {
        return AxcTableViewCell()
    }

    func tableView(tableView: _AxcNSTableView, heightForHeaderInSection section: Int) -> CGFloat { 20 }
    func tableView(tableView: _AxcNSTableView, viewForHeaderInSection section: Int) -> NSView? { fixedView(height: 20) }
    func tableView(tableView: _AxcNSTableView, shouldSelectHeaderInSection section: Int) -> Bool { true }
    func tableView(tableView: _AxcNSTableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 30 }
    func tableView(tableView: _AxcNSTableView, shouldSelectCellAtIndexPath indexPath: IndexPath) -> Bool { true }
    func tableView(tableView: _AxcNSTableView, heightForFooterInSection section: Int) -> CGFloat { 22 }
    func tableView(tableView: _AxcNSTableView, viewForFooterInSection section: Int) -> NSView? { fixedView(height: 22) }
    func tableView(tableView: _AxcNSTableView, shouldSelectFooterInSection section: Int) -> Bool { false }

    private func fixedView(height: CGFloat) -> NSView {
        return NSView(frame: CGRect(x: 0, y: 0, width: 100, height: height))
    }
}

private final class DefaultTableDelegate: AxcNSTableViewDelegate { }
#endif
