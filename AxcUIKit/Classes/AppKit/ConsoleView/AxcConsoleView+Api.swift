//
//  AxcConsoleView+Api.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

import AxcBedrock

// MARK: - [AxcConsoleViewApi]

public protocol AxcConsoleViewApi { }

extension AxcConsoleViewApi where Self: AxcConsoleView { }

// MARK: - AxcTargetDragView + AxcUICallbackTarget

public extension AxcUICallback where Base: AxcConsoleView {
}
