//
//  AxcUIBasicFuncTarget.swift
//  AxcBedrock
//
//  Created by 赵新 on 2023/6/22.
//

import AxcBedrock

// MARK: - [AxcUIBasicFuncTarget]

@objc
public protocol AxcUIBasicFuncTarget: NSObjectProtocol {
    /// 配置数据的地方
    @objc
    func config()

    /// 创建UI的方法放在这里
    /// 最好按照，从上至下，从左至右依次添加视图
    @objc
    func makeUI()

    /// data即将刷新
    @objc
    func dataWillLoad()

    /// 正向数据流（页面操作的监听）方法放在这里
    @objc
    func bindViewAction()

    /// 反向数据流（ViewModel的监听）进行数据绑定的放在这里
    @objc
    func bindViewModel()

    /// 通知数据流，主要用于接口暴露和复用
    @objc
    func bindNotice()
}

public extension AxcUIBasicFuncTarget {
    /// 执行基础方法
    func performBasic() {
        config()
        makeUI() // 布局
    }

    /// 执行数据通道方法
    func performDataChannel() {
        guard !axc_isFirstMoveTouperview else { return }
        axc_isFirstMoveTouperview = true // 标记为只执行一次
        bindViewModel() // 反向数据流绑定
        bindViewAction() // 正向数据流绑定
        bindNotice() // 协议通知数据流绑定
        dataWillLoad() // 绑定完后再执行数据加载
    }
}

private var k_isFirstMoveTouperview = "k_isFirstMoveTouperview"

public extension AxcUIBasicFuncTarget {
    /// 用于记录是否是第一次添加进视图
    var axc_isFirstMoveTouperview: Bool {
        set { AxcRuntime.Set(object: self, key: &k_isFirstMoveTouperview, value: newValue, policy: .OBJC_ASSOCIATION_ASSIGN) }
        get {
            guard let value: Bool = AxcRuntime.GetObject(self, key: &k_isFirstMoveTouperview) else {
                let value: Bool = false
                self.axc_isFirstMoveTouperview = value
                return value
            }
            return value
        }
    }
}
