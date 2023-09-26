//
//  AxcViewController+Api.swift
//  AxcUIKit
//
//  Created by 赵新 on 26/9/2023.
//

import AxcBedrock

// MARK: - [AxcViewControllerApi]

public protocol AxcViewControllerApi {
    /// （💈跨平台标识）获取颜色
    var viewBackgroundColor: AxcBedrockColor? { get }

    /// （💈跨平台标识）获取图层
    var axcView: AxcView? { get }
}

public extension AxcViewControllerApi where Self: AxcViewController {
    /// （💈跨平台标识）设置View颜色
    func setView(backgroundColor: AxcUnifiedColor?) {
        _setView(backgroundColor: backgroundColor)
    }
}

// MARK: - AxcViewController + AxcUICallbackTarget

extension AxcViewController: AxcUICallbackTarget { }

public extension AxcUICallback where Base: AxcViewController { }
