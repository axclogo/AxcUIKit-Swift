//
//  AxcTableView.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif

#if canImport(UIKit)
import UIKit

/// iOS 表格视图，保留 UITableView 的数据源、复用和自动行高能力。
open class AxcTableView: UITableView {
    public convenience init() {
        self.init(frame: .zero, style: .plain)
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

#elseif canImport(AppKit)
import AppKit

/// macOS 表格视图，通过桥接层提供接近 UITableView 的分组接口。
open class AxcTableView: _AxcNSTableView { }
#endif
