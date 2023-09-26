//
//  AxcTargetDragView+Api.swift
//  AxcUIKit
//
//  Created by 赵新 on 26/9/2023.
//

import AxcBedrock

// MARK: - [AxcTargetDragViewApi]

public protocol AxcTargetDragViewApi { }

extension AxcTargetDragViewApi where Self: AxcTargetDragView { }

// MARK: - AxcTargetDragView + AxcUICallbackTarget

public extension AxcUICallback where Base: AxcTargetDragView {
    /// 设置拖拽结束的回调
    func targetDraggingEnd(_ block: @escaping AxcBlock.OneParam<[URL]>) {
        base._targetDraggingEndBlock = block
    }
}
