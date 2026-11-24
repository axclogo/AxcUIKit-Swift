//
//  AxcTableViewApi.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif

// MARK: - [AxcTableViewApi]

/// 表格组件统一接口。标准 UITableView/NSTableView 能力直接由组件本身提供。
public protocol AxcTableViewApi { }

extension AxcTableViewApi where Self: AxcTableView { }

extension AxcTableView: AxcTableViewApi { }

// MARK: - AxcTargetDragView + AxcUICallbackTarget

public extension AxcUICallback where Base: AxcTableView { }
