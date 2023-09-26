//
//  AxcView+Api.swift
//  AxcUIKit
//
//  Created by 赵新 on 2023/6/22.
//

import AxcBedrock

// MARK: - [AxcViewApi]

public protocol AxcViewApi {
    /// （💈跨平台标识）获取颜色
    var axc_backgroundColor: AxcBedrockColor? { get }
    
    /// （💈跨平台标识）获取图层
    var axc_layer: CALayer? { get }
}

public extension AxcViewApi where Self: AxcView {
    /// （💈跨平台标识）设置颜色
    func set(backgroundColor: AxcUnifiedColor?) {
        _set(backgroundColor: backgroundColor)
    }

    /// （💈跨平台标识）检查视图的布局或约束是否固定了某个属性
    /// - Parameter firstAttribute: 检查固定的属性
    /// - Returns: 结果
    func isLayoutEqualConstant(firstAttribute: NSLayoutConstraint.Attribute) -> Bool {
        _isLayoutEqualConstant(firstAttribute: firstAttribute)
    }

    /// （💈跨平台标识）检查视图的布局或约束是否固定了大小
    func isLayoutFixedSize() -> Bool {
        _isLayoutFixedSize()
    }

    /// （💈跨平台标识）检查视图的布局或约束是否固定了宽度
    func isLayoutFixedWidth() -> Bool {
        _isLayoutEqualConstant(firstAttribute: .width)
    }

    /// （💈跨平台标识）检查视图的布局或约束是否固定了高度
    func isLayoutFixedHeight() -> Bool {
        _isLayoutEqualConstant(firstAttribute: .height)
    }
}

// MARK: - AxcView + AxcUICallbackTarget

extension AxcView: AxcUICallbackTarget { }

// MARK: - 通用兼容

#if os(macOS)
public extension AxcView {
    typealias HitTestBlock = (_ view: AxcView,
                              _ superBack: NSView?,
                              _ point: NSPoint) -> NSView?
}

public extension AxcUICallback where Base: AxcView { }

#elseif os(iOS) || os(tvOS) || os(watchOS)
public extension AxcView {
    typealias HitTestBlock = (_ view: AxcView,
                              _ superBack: UIView?,
                              _ point: CGPoint,
                              _ event: UIEvent?) -> UIView?
}

#endif
public extension AxcUICallback where Base: AxcView {
    /// 布局子视图
    /// - Parameter block: 回调
    func layoutSubviews(_ block: @escaping AxcBlock.Empty) {
        base._layoutSubviewsBlock = block
    }

    /// 触发了点击判定
    /// - Parameter block: 回调
    func hitTest(_ block: @escaping AxcView.HitTestBlock) {
        base._hitTestBlock = block
    }
}

// MARK: - iOS独有

#if os(iOS) || os(tvOS) || os(watchOS)

public extension AxcView {
    typealias PointInsetBlock = (_ view: AxcView,
                                 _ superBack: Bool,
                                 _ point: CGPoint,
                                 _ event: UIEvent?) -> Bool
}

public extension AxcUICallback where Base: AxcView {
    /// 点位是否在视图内
    /// - Parameter block: 回调
    func pointInside(_ block: @escaping AxcView.PointInsetBlock) {
        base._pointInsideBlock = block
    }
}
#endif

// MARK: - MacOS独有

#if os(macOS)
#endif
