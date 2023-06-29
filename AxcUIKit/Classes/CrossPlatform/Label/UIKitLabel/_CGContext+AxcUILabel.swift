//
//  _CGContext+LabelLineStyle.swift
//  AxcKit
//
//  Created by 赵新 on 2022/11/26.
//

#if canImport(UIKit)

import UIKit

extension CGContext {
    /// 设置线样式
    func setLineStyle(_ style: AxcUILabel.MarkLineConfig.Style) {
        switch style {
        case let .dotted(phase: phase, lengths: lengths):
            setLineDash(phase: phase, lengths: lengths)
        default: break
        }
    }
}

#endif
