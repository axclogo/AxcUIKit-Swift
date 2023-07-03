//
//  AxcLabel+Api.swift
//  AxcKit
//
//  Created by 赵新 on 2022/11/24.
//

import AxcBedrock

// MARK: - 扩展AxcLabel + AxcCallbackTarget

public extension AxcLabel { }

public extension AxcUICallback where Base: AxcLabel { }

// MARK: - [AxcLabel.NumberOfLineType]

public extension AxcLabel {
    /// 行数类型
    enum NumberOfLineType {
        /// 单行
        case single
        /// 多行
        case mutable(lineCount: Int)
        /// 无限行数
        case infinite
    }
}

public extension AxcLabel.MarkLineConfig {
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

// MARK: - [AxcLabel.MarkLineConfig]

public extension AxcLabel {
    /// 标线配置对象
    struct MarkLineConfig {
        /// 线点位
        public var edgePosition: EdgePosition

        /// 线颜色
        public var color: AxcBedrockColor

        /// 线宽
        public var width: CGFloat = 1

        /// 线样式
        public var style: Style = .solid

        /// 线末尾样式
        public var cap: CGLineCap = .butt

        /// 唯一标识符
        public var identifier: String?

        public init(edgePosition: EdgePosition,
                    color: AxcBedrockColor,
                    width: CGFloat = 1,
                    style: Style = .solid,
                    cap: CGLineCap = .round,
                    identifier: String? = nil) {
            self.edgePosition = edgePosition
            self.color = color
            self.width = width
            self.style = style
            self.cap = cap
            self.identifier = identifier
        }
    }
}

// MARK: - [AxcLabelApi]

public protocol AxcLabelApi {
    // MARK: 内容

    /// 内容边距
    var contentEdgeInsets: AxcBedrockEdgeInsets { get }

    // MARK: 对齐

    /// 文字水平对齐
    var textPositionHorizontal: AxcPositionHorizontal { get }

    /// 文字垂直对齐
    var textPositionVertical: AxcPositionVertical { get }

    /// 文字换行对齐模式
    var textPositionHorizontalNewLine: AxcPositionVertical { get }

    // MARK: 文字边框

    /// 文字边框线样式
    var textBorderStyle: AxcLabel.MarkLineConfig.Style { get }

    /// 文字边框颜色
    var textBorderColor: AxcBedrockColor? { get }

    /// 文字边框宽度
    var textBorderWidth: CGFloat { get }

    /// 文字边框线转角类型
    var textBorderLineJoin: CGLineJoin { get }

    // MARK: 标线

    /// 标线组
    var markLines: [AxcLabel.MarkLineConfig]? { get }

    /// 标线距离文本的边距
    var markLineTextEdgeSpacing: AxcBedrockEdgeInsets { get }
}

// MARK: - 属性设置

public extension AxcLabelApi where Self: AxcLabel {
    // MARK: 内容

    /// 设置内容边距
    /// - Parameter contentEdgeInsets: 内容边距
    func set(contentEdgeInsets: AxcBedrockEdgeInsets) {
        _set(contentEdgeInsets: contentEdgeInsets)
    }

    /// 设置文字
    /// - Parameter text: 文字
    func set(text: AxcUnifiedString) {
        _set(text: text)
    }

    /// 设置字号
    /// - Parameter textFont: 字号
    func set(textFont: AxcUnifiedFont) {
        _set(textFont: textFont)
    }

    /// 设置字色
    /// - Parameter textColor: 字色
    func set(textColor: AxcUnifiedColor) {
        _set(textColor: textColor)
    }

    /// 设置文字背景色
    /// - Parameter textBackgroundColor: 文字背景色
    func set(textBackgroundColor: AxcUnifiedColor) {
        _set(textBackgroundColor: textBackgroundColor)
    }

    /// 设置文字对齐模式
    /// - Parameter textAlignment: 文字对齐模式
    func set(textAlignment: NSTextAlignment) {
        _set(textAlignment: textAlignment)
    }

    /// 设置换行类型
    /// - Parameter numberOfLineType: 换行类型
    func set(numberOfLineType: NumberOfLineType) {
        _set(numberOfLineType: numberOfLineType)
    }

    /// 设置文字截断模式
    /// - Parameter textLineBreakMode: 文字截断模式
    func set(textLineBreakMode: NSLineBreakMode) {
        _set(textLineBreakMode: textLineBreakMode)
    }

    /// 设置行间距
    /// - Parameter lineSpacing: 行间距
    func set(lineSpacing: AxcUnifiedNumber) {
        _set(lineSpacing: lineSpacing)
    }

    // MARK: 对齐

    /// 设置文字水平轴向对齐方式
    /// - Parameter textPositionVertical: 文字水平轴向对齐方式
    func set(textPositionHorizontal: AxcPositionHorizontal) {
        _set(textPositionHorizontal: textPositionHorizontal)
    }

    /// 设置文字垂直轴向对齐方式
    /// - Parameter textPositionVertical: 文字垂直轴向对齐方式
    func set(textPositionVertical: AxcPositionVertical) {
        _set(textPositionVertical: textPositionVertical)
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
    func set(markLines: [AxcLabel.MarkLineConfig]?) {
        _set(markLines: markLines)
    }

    /// 设置标线距离文字的间距
    /// - Parameter markLineTextEdgeSpacing: 标线距离文字的间距
    func set(markLineTextEdgeSpacing: AxcBedrockEdgeInsets) {
        _set(markLineTextEdgeSpacing: markLineTextEdgeSpacing)
    }
}
