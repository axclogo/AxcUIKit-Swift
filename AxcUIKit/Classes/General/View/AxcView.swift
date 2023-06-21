//
//  AxcView.swift
//  AxcUIKit
//
//  Created by 赵新 on 2023/6/22.
//

import AxcBedrock

#if os(macOS)
import AppKit

public extension AxcUIKitLib {
    typealias SystemBaseView = NSView
}

#elseif os(iOS) || os(tvOS) || os(watchOS)

import UIKit

public extension AxcUIKitLib {
    typealias SystemBaseView = UIView
}

#endif

// MARK: - AxcView + AxcUIBasicFuncTarget

extension AxcView: AxcUIBasicFuncTarget { }

// MARK: - [AxcView]

open class AxcView: AxcUIKitLib.SystemBaseView {
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

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        performDataChannel()
    }

    /// 配置数据的地方
    open func config() { }

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

    #if os(macOS)

    #elseif os(iOS) || os(tvOS) || os(watchOS)
    /// 布局子视图回调
    var _layoutSubviewsBlock: AxcBlock.Empty?
    open override func layoutSubviews() {
        super.layoutSubviews()
        _layoutSubviewsBlock?()
    }

    /// 点位是否在视图内
    var _pointInsideBlock: PointInsetBlock?
    /// 点位判断事件
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let superPoint = super.point(inside: point, with: event)
        return _pointInsideBlock?(self, superPoint, point, event) ?? superPoint
    }

    /// 点击触发回调
    var _hitTestBlock: HitTestBlock?
    /// 点击判断事件
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let superView = super.hitTest(point, with: event)
        return _hitTestBlock?(self, superView, point, event)
    }
    #endif
}
