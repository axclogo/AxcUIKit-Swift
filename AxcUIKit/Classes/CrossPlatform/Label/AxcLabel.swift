//
//  AxcUILabel.swift
//  AxcBedrock
//
//  Created by 赵新 on 2023/6/30.
//

import AxcBedrock

#if os(macOS)
import AppKit

public extension AxcUIKitLib {
    typealias SystemBaseLabel = AxcNSLabel
}

#elseif os(iOS) || os(tvOS) || os(watchOS)

import UIKit

public extension AxcUIKitLib {
    typealias SystemBaseLabel = AxcUILabel
}

#endif
