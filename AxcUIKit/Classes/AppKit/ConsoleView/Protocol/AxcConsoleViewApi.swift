//
//  AxcConsoleViewApi.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

#if canImport(AppKit)

import AppKit
#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif
#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif

// MARK: - [AxcConsoleViewApi]

public protocol AxcConsoleViewApi {
    func append(log: String)
    func clear()
}

extension AxcConsoleViewApi where Self: AxcConsoleView { }
extension AxcConsoleView: AxcConsoleViewApi { }

// MARK: - AxcTargetDragView + AxcUICallbackTarget

public extension AxcUICallback where Base: AxcConsoleView {
}

#endif
