//
//  AxcTableView+Api.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

import AxcBedrock

// MARK: - [AxcTableViewApi]

public protocol AxcTableViewApi { }

extension AxcTableViewApi where Self: AxcTableView { }

// MARK: - AxcTargetDragView + AxcUICallbackTarget

public extension AxcUICallback where Base: AxcTableView { }
