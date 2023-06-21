//
//  AxcView+Api.swift
//  AxcUIKit
//
//  Created by 赵新 on 2023/6/22.
//

import AxcBedrock

// MARK: - [AxcViewApi]

public protocol AxcViewApi { }

public extension AxcViewApi where Self: AxcView { }

// MARK: - AxcView + AxcUICallbackTarget

extension AxcView: AxcUICallbackTarget { }

#if os(macOS)
public extension AxcView { }

public extension AxcUICallback where Base: AxcView { }

#elseif os(iOS) || os(tvOS) || os(watchOS)
public extension AxcView {
    typealias PointInsetBlock = (_ view: AxcView,
                                 _ superBack: Bool,
                                 _ point: CGPoint,
                                 _ event: UIEvent?) -> Bool
    typealias HitTestBlock = (_ view: AxcView,
                              _ superBack: UIView?,
                              _ point: CGPoint,
                              _ event: UIEvent?) -> UIView?
}

public extension AxcUICallback where Base: AxcView {
    /// 布局子视图
    /// - Parameter block: 回调
    func layoutSubviews(_ block: @escaping AxcBlock.Empty) {
        base._layoutSubviewsBlock = block
    }

    /// 点位是否在视图内
    /// - Parameter block: 回调
    func pointInside(_ block: @escaping AxcView.PointInsetBlock) {
        base._pointInsideBlock = block
    }

    /// 触发了点击判定
    /// - Parameter block: 回调
    func hitTest(_ block: @escaping AxcView.HitTestBlock) {
        base._hitTestBlock = block
    }
}
#endif
