//
//  AxcViewApi.swift
//  AxcUIKit
//
//  Created by 赵新 on 2023/6/22.
//

#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif
import QuartzCore
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - [AxcViewApi]

public protocol AxcViewApi {
    /// （💈跨平台标识）获取颜色
    var currentBackgroundColor: AxcBedrockColor? { get }

    /// （💈跨平台标识）当前图层
    var currentLayer: CALayer? { get }

    /// 设置背景颜色。
    func set(backgroundColor: AxcUnifiedColor?)

    /// 检查是否存在固定指定属性的必需约束。
    func isLayoutEqualConstant(firstAttribute: NSLayoutConstraint.Attribute) -> Bool

    /// 检查宽高是否均已固定。
    func isLayoutFixedSize() -> Bool

    /// 检查宽度是否已固定。
    func isLayoutFixedWidth() -> Bool

    /// 检查高度是否已固定。
    func isLayoutFixedHeight() -> Bool
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

#elseif os(iOS) || os(tvOS)
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

#if os(iOS) || os(tvOS)

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
