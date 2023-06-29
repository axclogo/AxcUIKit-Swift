//
//  AxcUILabel+Api.swift
//  AxcKit
//
//  Created by 赵新 on 2022/11/24.
//

#if canImport(UIKit)

import UIKit
import AxcBedrock

// MARK: - 扩展AxcUILabel + AxcCallbackTarget

public extension AxcUILabel {}

public extension AxcUICallback where Base: AxcUILabel {}

// MARK: - 内部对象以及选项

public extension AxcUILabel.MarkLineConfig {
    /// 边缘位置
    enum EdgePosition {
        /// 上
        case top(axis: Axis2D)
        /// 左
        case left(axis: Axis2D)
        /// 下
        case bottom(axis: Axis2D)
        /// 右
        case right(axis: Axis2D)
    }

    /// 轴向2D
    enum Axis2D {
        /// 水平
        case horizontal(position: AxcPositionVertical)
        /// 垂直
        case vertical(position: AxcPositionHorizontal)
    }

    /// 线样式
    enum Style: Equatable {
        /// 无
        case none
        /// 实心
        case solid
        /// 虚线
        case dotted(phase: CGFloat, lengths: [CGFloat])
    }
}

public extension AxcUILabel {
    /// 标线配置对象
    struct MarkLineConfig {
        // Lifecycle

        public init(edgePosition: EdgePosition,
                    color: UIColor,
                    width: CGFloat = 1,
                    style: Style = .solid,
                    cap: CGLineCap = .round,
                    identifier: String? = nil)
        {
            self.edgePosition = edgePosition
            self.color = color
            self.width = width
            self.style = style
            self.cap = cap
            self.identifier = identifier
        }

        // Public

        /// 线点位
        public var edgePosition: EdgePosition

        /// 线颜色
        public var color: UIColor

        /// 线宽
        public var width: CGFloat = 1

        /// 线样式
        public var style: Style = .solid

        /// 线末尾样式
        public var cap: CGLineCap = .butt

        /// 唯一标识符
        public var identifier: String?
    }
}

// MARK: - [AxcUILabelApi]

public protocol AxcUILabelApi {
    // MARK: 内容

    /// 内容边距
    var contentEdgeInsets: AxcBedrockEdgeInsets { get }

    // MARK: 对齐

    /// 文字水平对齐
    var alignmentHorizontal: AxcPositionHorizontal { get }

    /// 文字垂直对齐
    var alignmentVertical: AxcPositionVertical { get }

    /// 文字换行对齐模式
    var alignmentHorizontalNewLine: AxcPositionVertical { get }

    // MARK: 文字边框

    /// 文字边框线样式
    var textBorderStyle: AxcUILabel.MarkLineConfig.Style { get }

    /// 文字边框颜色
    var textBorderColor: UIColor? { get }

    /// 文字边框宽度
    var textBorderWidth: CGFloat { get }

    /// 文字边框线转角类型
    var textBorderLineJoin: CGLineJoin { get }

    // MARK: 标线

    /// 标线组
    var markLines: [AxcUILabel.MarkLineConfig]? { get }

    /// 标线距离文本的边距
    var markLineTextEdgeSpacing: AxcBedrockEdgeInsets { get }
}

// MARK: - 属性设置

public extension AxcUILabelApi where Self: AxcUILabel {
    // MARK: 内容

    /// 设置内容边距
    /// - Parameter contentEdgeInsets: 内容边距
    func set(contentEdgeInsets: AxcBedrockEdgeInsets) {
        _set(contentEdgeInsets: contentEdgeInsets)
    }

    // MARK: 对齐

    /// 设置文字水平轴向对齐方式
    /// - Parameter alignmentVertical: 文字水平轴向对齐方式
    func set(alignmentHorizontal: AxcPositionHorizontal) {
        _set(alignmentHorizontal: alignmentHorizontal)
    }

    /// 设置文字垂直轴向对齐方式
    /// - Parameter alignmentVertical: 文字垂直轴向对齐方式
    func set(alignmentVertical: AxcPositionVertical) {
        _set(alignmentVertical: alignmentVertical)
    }

    /// 设置文字是否换行对齐
    /// - Parameter alignmentVertical: 文字文字是否换行对齐
    func set(alignmentHorizontalNewLine: AxcPositionHorizontal) {
        _set(alignmentHorizontalNewLine: alignmentHorizontalNewLine)
    }

    // MARK: 文字边框

    /// 设置文字边框的样式
    /// - Parameter textBorderStyle: 文字边框的样式
    func set(textBorderStyle: MarkLineConfig.Style) {
        _set(textBorderStyle: textBorderStyle)
    }

    /// 设置文字边框的颜色
    /// - Parameter textBorderColor: 文字边框的颜色
    func set(textBorderColor: AxcUnifiedColor?) {
        _set(textBorderColor: textBorderColor)
    }

    /// 设置文字边框的宽度
    /// - Parameter textBorderWidth: 文字边框的宽度
    func set(textBorderWidth: CGFloat) {
        _set(textBorderWidth: textBorderWidth)
    }

    /// 设置文字边框的转角类型
    /// - Parameter textBorderLineJoin: 文字边框的转角类型
    func set(textBorderLineJoin: CGLineJoin) {
        _set(textBorderLineJoin: textBorderLineJoin)
    }

    // MARK: 标线

    /// 设置标线
    /// - Parameter markLines: 标线集合，nil即无标线
    func set(markLines: [AxcUILabel.MarkLineConfig]?) {
        _set(markLines: markLines)
    }

    /// 设置标线距离文字的间距
    /// - Parameter markLineTextEdgeSpacing: 标线距离文字的间距
    func set(markLineTextEdgeSpacing: AxcBedrockEdgeInsets) {
        _set(markLineTextEdgeSpacing: markLineTextEdgeSpacing)
    }
}

#endif
