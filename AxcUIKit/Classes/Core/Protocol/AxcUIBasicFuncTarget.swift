//
//  AxcUIBasicFuncTarget.swift
//  AxcBedrock
//
//  Created by 赵新 on 2023/6/22.
//

#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif
import Foundation

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

}

public extension AxcUIBasicFuncTarget where Self: NSObject {
    /// 执行所有数据通道。每个对象实例只执行一次。
    func performDataChannel() {
        axc_dataChannelOnce.run {
            bindViewModel() // 反向数据流绑定
            bindViewAction() // 正向数据流绑定
            bindNotice() // 协议通知数据流绑定
            bindDrive() // 外部驱动数据流绑定
            dataWillLoad() // 绑定完成后执行数据加载
        }
    }
}

private enum AxcUIBasicAssociationKeys {
    static let dataChannelOnce = AxcAssociationKey<AxcOnce>()
}

private extension AxcUIBasicFuncTarget where Self: NSObject {
    /// UI 生命周期在主线程访问；令牌由宿主对象关联持有。
    var axc_dataChannelOnce: AxcOnce {
        if let once = AxcRuntime.GetObject(self, key: AxcUIBasicAssociationKeys.dataChannelOnce) {
            return once
        }
        let once = AxcOnce()
        AxcRuntime.Set(object: self, key: AxcUIBasicAssociationKeys.dataChannelOnce, value: once)
        return once
    }
}
