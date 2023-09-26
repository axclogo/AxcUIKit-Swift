//
//  AxcFileDragView.swift
//  AxcUIKit
//
//  Created by 赵新 on 26/9/2023.
//

import Cocoa
import AxcBedrock

extension AxcTargetDragView {
    /// set focus view, and set hidden is true, add view, make constraints edge is fill
    /// 设置焦点视图
    func _set(focusView: NSView) {
        _focusView?.removeFromSuperview() // remove
        _focusView = focusView // set
        _focusView?.isHidden = true // hidden
        if let _focusView { // unpack is no optional
            addSubview(focusView) // add
            _focusView.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }

    /// 设置焦点视图是否隐藏
    func _setFocusView(isHidden: Bool) {
        _focusView?.isHidden = isHidden
    }
}

// MARK: - [AxcTargetDragView]

open class AxcTargetDragView: AxcView {
    /// 全事件穿透
    open override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }

    /// 该方法会在拖动进入当前视图或窗口的时候调用，并给予（即当前视图或窗口）一个机会来决定是否接受该拖动操作。
    /// 该方法的参数包含了一个NSDraggingInfo实例，提供了关于拖动内容的一些信息，包括拖动数据的类型、数据大小、拖动源、拖动起始位置等。
    /// 可以通过该方法的返回值来控制是否接受这个拖动操作。
    open override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        _setFocusView(isHidden: false)
        return .copy
    }

    /// 该方法会在拖动操作离开当前视图或窗口的时候调用，可以根据需要执行一些清理操作。
    open override func draggingExited(_ sender: NSDraggingInfo?) {
        _setFocusView(isHidden: true)
    }

    /// 该方法会在目标视图或窗口接收到拖动操作并且鼠标移动时不断调用，可以根据需要更新视图或做出其他响应。
    open override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }

    /// 该方法会在用户释放鼠标按钮并且拖动操作将被执行时调用，可以执行一些准备工作，如更新视图的状态、替换拖动数据等。
    open override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }

    /// 该方法会在用户释放鼠标按钮并且拖动操作将被执行时调用，并且应该执行最终的操作，如将数据插入目标视图、保存数据等。
    open override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let urls = _draggingInfoFileUrl(sender)
        _targetDraggingEndBlock?(urls)
        return true
    }

    /// 该方法会在拖动操作完成并在执行performDragOperation:方法后立即调用，可以根据需要执行一些收尾操作。
    open override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        _setFocusView(isHidden: true)
    }

    open override func config() {
        super.config()
    }

    open override func makeUI() {
        super.makeUI()
        set(backgroundColor: NSColor.clear)
        registerForDraggedTypes([
            .fileURL,
        ])
    }

    /// 获取拖动文件的URL地址
    private func _draggingInfoFileUrl(_ sender: NSDraggingInfo) -> [URL] {
        let pasteboard = sender.draggingPasteboard
        // 在此方法中读取剪贴板中的数据，并处理传输过来的文件
        guard let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] else { return [] }
        return urls
    }

    /// 执行拖拽后的回调
    var _targetDraggingEndBlock: AxcBlock.OneParam<[URL]>?

    /// If this view show is when mouse touch down and drag file into `AxcFileDragView`
    /// 焦点
    private var _focusView: NSView?
}
