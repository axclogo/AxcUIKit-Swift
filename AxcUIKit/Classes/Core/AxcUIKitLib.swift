//
//  AxcUIKitLib.swift
//  AxcUIKit-Swift
//
//  Created by 赵新 on 2023/6/21.
//

#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif
import Foundation

// MARK: - [AxcUIKitLib]

open class AxcUIKitLib: NSObject, AxcLibraryTarget {
    public var moduleName: String {
        return "AxcUIKit"
    }

    public var moduleEmoji: String? {
        return "🧱"
    }
}
