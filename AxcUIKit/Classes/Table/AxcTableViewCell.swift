//
//  AxcTableViewCell.swift
//  Alamofire
//
//  Created by 赵新 on 26/9/2023.
//

#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif

#if canImport(UIKit)
import UIKit

/// iOS 表格单元格，直接复用 UIKit 的复用、选中和动态高度能力。
open class AxcTableViewCell: UITableViewCell {
    public convenience init() {
        self.init(style: .default, reuseIdentifier: nil)
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

#elseif canImport(AppKit)
import AppKit

/// macOS 表格单元格。
open class AxcTableViewCell: AxcView { }
#endif
