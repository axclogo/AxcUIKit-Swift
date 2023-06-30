//
//  AxcView.swift
//  AxcUIKit
//
//  Created by 赵新 on 2023/6/22.
//

import AxcBedrock

#if os(macOS)
import AppKit

public typealias AxcSystemBaseView = NSView

#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit

public typealias AxcSystemBaseView = UIView

#endif

// MARK: - AxcView + AxcUIBasicFuncTarget

extension AxcView: AxcUIBasicFuncTarget { }

// MARK: - AxcView + AxcViewApi

extension AxcView: AxcViewApi {
    /// （💈跨平台标识）获取颜色
    public var axc_backgroundColor: AxcBedrockColor? {
        #if os(macOS)
        return layer?.backgroundColor?.axc.nsColor
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        return super.backgroundColor
        #endif
    }

    /// （💈跨平台标识）获取图层
    public var axc_layer: CALayer? {
        return layer
    }
}

extension AxcView {
    func _set(backgroundColor: AxcUnifiedColor?) {
        let color = AxcBedrockColor.Axc.CreateOptional(backgroundColor) ?? .white
        #if os(macOS)
        layer?.backgroundColor = color.cgColor
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        super.backgroundColor = color
        #endif
    }
    
    func _isLayoutEqualConstant(firstAttribute: NSLayoutConstraint.Attribute) -> Bool {
        guard !translatesAutoresizingMaskIntoConstraints else { return true } // frame 固定的情况
        // Auto Layout 约束固定的情况
        let constraints = self.constraints
        for constraint in constraints {
            if constraint.firstAttribute == firstAttribute,
               constraint.relation == .equal,
               constraint.constant > 0 {
                return true
            }
        }
        return false // 没有固定的约束
    }
    
    func _isLayoutFixedSize() -> Bool {
        print(translatesAutoresizingMaskIntoConstraints)
        guard !translatesAutoresizingMaskIntoConstraints else { return true } // frame 固定的情况
        // Auto Layout 约束固定的情况
        let constraints = self.constraints
        for constraint in constraints {
            if (constraint.firstAttribute == .width || constraint.firstAttribute == .height),
               constraint.relation == .equal,
               constraint.constant > 0 {
                return true
            }
        }
        return false // 没有固定的约束
    }
}

// MARK: - [AxcView]

open class AxcView: AxcSystemBaseView {
    public required convenience init() {
        self.init(frame: .zero)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        performBasic()
    }

    // MARK: 通用方法-有对应/替代的Api

    /// 点击触发回调
    var _hitTestBlock: HitTestBlock?

    #if os(macOS)

    open override func hitTest(_ point: NSPoint) -> NSView? {
        let superView = super.hitTest(point)
        return _hitTestBlock?(self, superView, point)
    }

    #elseif os(iOS) || os(tvOS) || os(watchOS)
    /// 点击判断事件
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let superView = super.hitTest(point, with: event)
        return _hitTestBlock?(self, superView, point, event)
    }

    #endif

    /// 布局子视图回调
    var _layoutSubviewsBlock: AxcBlock.Empty?

    // MARK: 跨平台兼容-需要支持跨平台重写的

    /// 设置图层类型
    open class var Axc_layerClass: CALayer.Type {
        return CALayer.self
    }

    /// 已经移动到父视图
    open func axc_didMoveToSuperview() {
        #if os(macOS)
        super.viewDidMoveToSuperview()
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        super.didMoveToSuperview()
        #endif
        performDataChannel()
    }

    /// 布局子视图回调
    open func axc_layoutSubviews() {
        #if os(macOS)
        super.layout()
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        super.layoutSubviews()
        #endif
        _layoutSubviewsBlock?()
    }

    /* 原方法需要禁用重写 */
    #if os(macOS)

    public final override func viewDidMoveToSuperview() {
        axc_didMoveToSuperview()
    }

    public final override func layout() {
        axc_layoutSubviews()
    }

    #elseif os(iOS) || os(tvOS) || os(watchOS)

    public final override class var layerClass: AnyClass {
        return Axc_layerClass
    }

    public final override func didMoveToSuperview() {
        axc_didMoveToSuperview()
    }

    public final override func layoutSubviews() {
        axc_layoutSubviews()
    }
    #endif

    // MARK: iOS独有

    #if os(iOS) || os(tvOS) || os(watchOS)
    /// 点位是否在视图内
    var _pointInsideBlock: PointInsetBlock?
    /// 点位判断事件
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let superPoint = super.point(inside: point, with: event)
        return _pointInsideBlock?(self, superPoint, point, event) ?? superPoint
    }

    /// 禁用重写
    @available(*, unavailable)
    public final override var backgroundColor: UIColor? {
        set { }
        get { return axc_backgroundColor }
    }

    #endif

    // MARK: MacOS独有

    #if os(macOS)
    #endif

    // MARK: 基础方法

    /// 配置数据的地方
    open func config() {
        #if os(macOS)
        // MacOS需要设置图层
        wantsLayer = true
        layer = Self.Axc_layerClass.init()
        layer?.backgroundColor = NSColor.white.cgColor
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        super.backgroundColor = UIColor.white
        #endif
    }

    /// 创建UI的方法放在这里。按照，从上至下，从左至右依次添加视图
    open func makeUI() { }

    /// 数据即将刷新
    open func dataWillLoad() { }

    /// 正向数据流（页面操作的监听）方法放在这里
    open func bindViewAction() { }

    /// 反向数据流（ViewModel的监听）进行数据绑定的放在这里
    open func bindViewModel() { }

    /// 通知数据流，主要用于接口暴露和复用
    open func bindNotice() { }
}
