//
//  AxcTargetDragViewApi.swift
//  AxcUIKit
//
//  Created by 赵新 on 26/9/2023.
//

#if canImport(AppKit)

import AppKit
#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif
#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif

// MARK: - [AxcTargetDragViewApi]

public protocol AxcTargetDragViewApi {
    var focusView: NSView? { get }
    func set(focusView: NSView?)
}
extension AxcTargetDragView: AxcTargetDragViewApi { }

public extension AxcTargetDragViewApi where Self: AxcTargetDragView {
    /// 设置拖入时显示的焦点视图，传入 nil 表示移除。
    func set(focusView: NSView?) {
        _set(focusView: focusView)
    }
}

// MARK: - AxcTargetDragView + AxcUICallbackTarget

public extension AxcUICallback where Base: AxcTargetDragView {
    /// 设置拖拽结束的回调
    func targetDraggingEnd(_ block: @escaping AxcBlock.OneParam<[URL]>) {
        base._targetDraggingEndBlock = block
    }
}

#endif
