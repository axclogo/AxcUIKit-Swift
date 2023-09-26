//
//  AxcLayer.swift
//  AxcBedrock
//
//  Created by 赵新 on 2023/6/22.
//

import QuartzCore

// MARK: - AxcLayer + AxcUIBasicFuncTarget

extension AxcLayer: AxcUIBasicFuncTarget { }

// MARK: - [AxcLayer]

open class AxcLayer: CALayer {
    // Lifecycle

    public override init(layer: Any) {
        super.init(layer: layer)
    }

    public override init() {
        super.init()
        performBasic()
        performDataChannel()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // Open

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

    /// 驱动数据流，主要用于外部驱动
    open func bindDrive() { }
}
