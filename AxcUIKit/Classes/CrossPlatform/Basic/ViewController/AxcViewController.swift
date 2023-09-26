//
//  AxcViewController.swift
//  AxcUIKit-Swift
//
//  Created by 赵新 on 2023/6/21.
//

import AxcBedrock

#if os(macOS)
import AppKit

public typealias AxcSystemBaseViewController = NSViewController

#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit

public typealias AxcSystemBaseViewController = UIViewController

#endif

// MARK: - AxcViewController + AxcUIBasicFuncTarget

extension AxcViewController: AxcUIBasicFuncTarget { }

// MARK: - AxcViewController + AxcViewControllerApi

extension AxcViewController: AxcViewControllerApi { }

// MARK: - [AxcViewController]

open class AxcViewController: AxcSystemBaseViewController {
    // MARK: 父类重写

    open override func loadView() {
        #if os(macOS)
        /*
         在 macOS 10.10 及更高版本中，loadView() 方法会自动查找与视图控制器同名的 nib 文件。
         要利用此行为，请在其相应的视图控制器之后命名一个 nib 文件，并将 nil 传递给 init(nibName:bundle:) 方法的两个参数。
         您可以通过使用空实现覆盖该方法来确认此行为 loadView()——这将退出该默认行为。
         */
        view = AxcView(frame: .zero)
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        super.loadView()
        #endif
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        performBasic()
        performDataChannel()
    }

    // MARK: 子类重写

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
    open func bindDriving() { }
}
