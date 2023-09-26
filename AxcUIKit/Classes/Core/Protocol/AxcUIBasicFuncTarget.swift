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
    /**
         Write initialize config code in this function
         配置数据的地方
     */
    @objc
    func config()

    /**
         Write User Interface code in this function
         add view layout direction need form top to bottom and left to right
         创建UI的方法放在这里
         最好按照，从上至下，从左至右依次添加视图
     */
    @objc
    func makeUI()

    /**
         Write data request or load code in this function
         data即将加载
     */
    @objc
    func dataWillLoad()

    /**
         Write view action event input code in this function
         Data flow is forward direction
         正向数据流（页面操作的监听）方法放在这里
     */
    @objc
    func bindViewAction()

    /**
         Write ViewModel output code in this function
         Data flow is reverse direction
         反向数据流（ViewModel的监听）进行数据绑定的放在这里
     */
    @objc
    func bindViewModel()

    /**
         Write Notification input code in this function
         Data flow is from notification
         通知数据流，主要用于接口暴露和复用
     */
    @objc
    func bindNotice()

    /**
         Write Notification input code in this function
         Data flow is from outside invoking
         驱动数据流，主要用于外部驱动
     */
    @objc
    func bindDrive()
}

public extension AxcUIBasicFuncTarget {
    /// Perform basic function(`config` and `makeUI` function)
    /// 执行基础方法
    func performBasic() {
        config()
        makeUI()
    }

    /// Perform data flow function(all prefix is `bind` and `dataWillLoad` function)
    /// 执行数据通道方法
    func performDataChannel() {
        // Filter
        guard !axc_isFirstPerformDataChannel else { return }
        // Just perform onice
        // 标记为只执行一次
        axc_isFirstPerformDataChannel = true
        bindViewModel() // 反向数据流绑定
        bindViewAction() // 正向数据流绑定
        bindNotice() // 协议通知数据流绑定
        bindDrive() // 协议通知数据流绑定
        dataWillLoad() // 绑定完后再执行数据加载
    }
}

private var k_isFirstPerformDataChannel = "k_isFirstPerformDataChannel"

private extension AxcUIBasicFuncTarget {
    /// Records whether the view was added for the first time
    /// 用于记录是否是第一次添加进视图
    var axc_isFirstPerformDataChannel: Bool {
        set { AxcRuntime.Set(object: self, key: &k_isFirstPerformDataChannel, value: newValue, policy: .OBJC_ASSOCIATION_ASSIGN) }
        get {
            guard let value: Bool = AxcRuntime.GetObject(self, key: &k_isFirstPerformDataChannel) else {
                let value: Bool = false
                self.axc_isFirstPerformDataChannel = value
                return value
            }
            return value
        }
    }
}
