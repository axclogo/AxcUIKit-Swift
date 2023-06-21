//
//  AxcUICallbackTarget.swift
//  AxcUIKit
//
//  Created by 赵新 on 2023/6/22.
//

// MARK: - [AxcUICallbackTarget]

public protocol AxcUICallbackTarget { }
public extension AxcUICallbackTarget {
    /// 命名空间， 实例类型
    var callback: AxcUICallback<Self> {
        set { }
        get { return AxcUICallback(self) }
    }
}

// MARK: - [AxcUICallback]

open class AxcUICallback<Base> {
    public init(_ base: Base) {
        self.base = base
    }

    public var base: Base
}
