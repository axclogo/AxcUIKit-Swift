//
//  AxcView.swift
//  AxcUIKit
//
//  Created by 赵新 on 2023/6/22.
//

#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif

#if os(macOS)
import AppKit

public typealias AxcSystemBaseView = NSView

#elseif os(iOS) || os(tvOS)
import UIKit

public typealias AxcSystemBaseView = UIView

#endif

extension AxcSystemBaseView {
    /// 跨平台系统基类设置背景颜色
    var _axc_backgroundColor: AxcBedrockColor? {
        set {
            let color = AxcBedrockColor.Axc.CreateOptional(newValue)
            #if os(macOS)
            layer?.backgroundColor = color?.cgColor
            #elseif os(iOS) || os(tvOS)
            backgroundColor = color
            #endif
        }
        get {
            #if os(macOS)
            return layer?.backgroundColor?.axc.nsColor
            #elseif os(iOS) || os(tvOS)
            return backgroundColor
            #endif
        }
    }
}

// MARK: - AxcView + AxcUIBasicFuncTarget

extension AxcView: AxcUIBasicFuncTarget { }

// MARK: - AxcView + AxcViewApi

extension AxcView: AxcViewApi {
    /// （💈跨平台标识）获取颜色
    public var currentBackgroundColor: AxcBedrockColor? {
        #if os(macOS)
        return layer?.backgroundColor?.axc.nsColor
        #elseif os(iOS) || os(tvOS)
        return backgroundColor
        #endif
    }

    /// （💈跨平台标识）获取图层
    public var currentLayer: CALayer? {
        return layer
    }
}

extension AxcView {
    func _set(backgroundColor: AxcUnifiedColor?) {
        let color = AxcBedrockColor.Axc.CreateOptional(backgroundColor)
        #if os(macOS)
        layer?.backgroundColor = color?.cgColor
        #elseif os(iOS) || os(tvOS)
        self.backgroundColor = color
        #endif
    }

    func _isLayoutEqualConstant(firstAttribute: NSLayoutConstraint.Attribute) -> Bool {
        let relatedConstraints = constraints + (superview?.constraints ?? [])
        for constraint in relatedConstraints where
            constraint.priority == .required &&
            constraint.relation == .equal {
            let firstIsSelf = constraint.firstItem as AnyObject? === self
            let secondIsSelf = constraint.secondItem as AnyObject? === self
            if firstIsSelf,
               constraint.firstAttribute == firstAttribute,
               constraint.secondItem == nil {
                return true
            }
            if secondIsSelf,
               constraint.secondAttribute == firstAttribute,
               constraint.firstItem == nil {
                return true
            }
        }
        return false
    }

    func _isLayoutFixedSize() -> Bool {
        let isFixedWidth = _isLayoutEqualConstant(firstAttribute: .width)
        let isFixedHeight = _isLayoutEqualConstant(firstAttribute: .height)
        return isFixedWidth && isFixedHeight
    }
}

// MARK: - [AxcView]

open class AxcView: AxcSystemBaseView {
    public required convenience init() {
        self.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        performBasic()
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
        if let _hitTestBlock {
            return _hitTestBlock(self, superView, point)
        } else {
            return superView
        }
    }

    #elseif os(iOS) || os(tvOS)
    /// 点击判断事件
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let superView = super.hitTest(point, with: event)
        guard let _hitTestBlock else { return superView }
        return _hitTestBlock(self, superView, point, event)
    }

    #endif

    /// 布局子视图回调
    var _layoutSubviewsBlock: AxcBlock.Empty?

    // MARK: 跨平台兼容-需要支持跨平台重写的

    /// 设置图层类型
    open class var Axc_layerClass: CALayer.Type {
        return AxcLayer.self
    }

    /// 已经移动到父视图
    open func axc_didMoveToSuperview() {
        #if os(macOS)
        super.viewDidMoveToSuperview()
        #elseif os(iOS) || os(tvOS)
        super.didMoveToSuperview()
        #endif
        performDataChannel()
    }

    /// 布局子视图回调
    open func axc_layoutSubviews() {
        #if os(macOS)
        super.layout()
        #elseif os(iOS) || os(tvOS)
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

    #elseif os(iOS) || os(tvOS)

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

    #if os(iOS) || os(tvOS)
    /// 点位是否在视图内
    var _pointInsideBlock: PointInsetBlock?
    /// 点位判断事件
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let superPoint = super.point(inside: point, with: event)
        return _pointInsideBlock?(self, superPoint, point, event) ?? superPoint
    }

    #endif

    // MARK: MacOS独有

    #if os(macOS)
    #endif

    // MARK: 基础方法

    /// 配置数据的地方
    open func config() {
        #if os(macOS)
        /*
         在Cocoa框架中，wantsLayer是NSView类中的一个布尔属性。
         如果将NSView的wantsLayer属性设置为YES，那么这个NSView就会有一个CALayer实例作为其backing layer。

         简单来说，wantsLayer是用来开启Core Animation的支持的
         Core Animation是一种动画渲染方式，通过OpenGL渲染引擎来让应用程序中的层进行动画渲染。
         如果在Mac应用程序中需要使用动画效果，就需要开启wantsLayer属性，然后在layer中设置动画效果，这样就能够实现高效的动态界面渲染了。

         在使用wantsLayer属性时，一定要确保在视图层级中的所有视图wantsLayer属性都被设置为YES，这样才能在整个视图层级中启用Core Animation渲染引擎。
         */
        wantsLayer = true
        layer = Self.Axc_layerClass.init()
        #elseif os(iOS) || os(tvOS)
        backgroundColor = UIColor.white
        #endif
        translatesAutoresizingMaskIntoConstraints = false
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

    /// 驱动数据流，主要用于外部驱动
    open func bindDrive() { }
}
