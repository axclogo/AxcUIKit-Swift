//
//  AxcUILabel.swift
//  FBSnapshotTestCase
//
//  Created by 赵新 on 2022/11/24.
//

#if canImport(UIKit)

import UIKit
import AxcBedrock

// MARK: - AxcUILabel + AxcUILabelApi

extension AxcUILabel: AxcUILabelApi {
    public var contentEdgeInsets: AxcBedrockEdgeInsets {
        return _contentEdgeInsets
    }

    public var textBorderWidth: CGFloat {
        return _textBorderWidth
    }

    public var alignmentHorizontal: AxcPositionHorizontal {
        return _alignmentHorizontal
    }

    public var alignmentVertical: AxcPositionVertical {
        return _alignmentVertical
    }

    public var alignmentHorizontalNewLine: AxcPositionVertical {
        return _alignmentVertical
    }

    public var textBorderColor: UIColor? {
        return UIColor.Axc.CreateOptional(_textBorderColor)
    }

    public var textBorderStyle: MarkLineConfig.Style {
        return _textBorderStyle
    }

    public var textBorderLineJoin: CGLineJoin {
        return _textBorderLineJoin
    }

    public var markLines: [MarkLineConfig]? {
        return _markLines
    }

    public var markLineTextEdgeSpacing: AxcBedrockEdgeInsets {
        return _markLineTextEdgeSpacing
    }
}

// MARK: - 功能Api

extension AxcUILabel {
    func _set(contentEdgeInsets: AxcBedrockEdgeInsets) {
        _contentEdgeInsets = contentEdgeInsets
        setNeedsDisplay()
        if let text = text {
            let suffixStr = "  "
            self.text = "\(text)\(suffixStr)"
            self.text = self.text?.axc.removeSuffix(string: suffixStr)
        }
    }

    func _set(alignmentHorizontal: AxcPositionHorizontal) {
        _alignmentHorizontal = alignmentHorizontal
        setNeedsDisplay()
    }

    func _set(alignmentVertical: AxcPositionVertical) {
        _alignmentVertical = alignmentVertical
        setNeedsDisplay()
    }

    func _set(alignmentHorizontalNewLine: AxcPositionHorizontal) {
        _alignmentHorizontalNewLine = alignmentHorizontalNewLine
        switch _alignmentHorizontalNewLine {
        case .left: super.textAlignment = .left
        case .center: super.textAlignment = .center
        case .right: super.textAlignment = .right
        }
    }

    func _set(textBorderStyle: MarkLineConfig.Style) {
        _textBorderStyle = textBorderStyle
        setNeedsDisplay()
    }

    func _set(textBorderColor: AxcUnifiedColor?) {
        _textBorderColor = textBorderColor
        setNeedsDisplay()
    }

    func _set(textBorderWidth: CGFloat) {
        _textBorderWidth = textBorderWidth
        setNeedsDisplay()
    }

    func _set(textBorderLineJoin: CGLineJoin) {
        _textBorderLineJoin = textBorderLineJoin
        setNeedsDisplay()
    }

    func _set(markLines: [MarkLineConfig]?) {
        _markLines = markLines
        setNeedsDisplay()
    }

    func _set(markLineTextEdgeSpacing: AxcBedrockEdgeInsets) {
        _markLineTextEdgeSpacing = markLineTextEdgeSpacing
        setNeedsDisplay()
    }
}

// MARK: - 功能Api

extension AxcUILabel { }

// MARK: - AxcUILabel + AxcUIBasicFuncTarget

extension AxcUILabel: AxcUIBasicFuncTarget { }

// MARK: - [AxcUILabel]

/// 文字展示
open class AxcUILabel: UILabel {
    // Lifecycle

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        performBasic()
    }

    fileprivate var isFirstMoveTouperview = false

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard !isFirstMoveTouperview else { return }
        performDataChannel()
    }

    @available(*, unavailable, message: "请使用set(alignmentHorizontal:)")
    open override var textAlignment: NSTextAlignment {
        set { }
        get { super.textAlignment }
    }

    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let allEdgeInsets = _contentEdgeInsets
        let contentSize = CGSize(width: size.width + allEdgeInsets.axc.horizontal,
                                 height: size.height + allEdgeInsets.axc.vertical)
        return contentSize
    }

    open override func drawText(in rect: CGRect) {
        // 文字边距
        let allEdgeInsets = _contentEdgeInsets
        // 文字排布类型
        let textRect = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        // 文字实际绘制范围
        var textDrawRect: CGRect = .zero
        textDrawRect.size = textRect.size
        // 水平对齐
        switch _alignmentHorizontal {
        case .left: // 居左
            textDrawRect.origin.x = allEdgeInsets.left
        case .center: // 居中
            textDrawRect.origin.x = (rect.width - textRect.width) / 2
        case .right: // 居右
            textDrawRect.origin.x = rect.width - textRect.width - allEdgeInsets.right
        }
        // 垂直对齐
        switch _alignmentVertical {
        case .top: // 居上
            textDrawRect.origin.y = allEdgeInsets.top
        case .center: // 居中
            textDrawRect.origin.y = (rect.height - textRect.height) / 2
        case .bottom: // 居下
            textDrawRect.origin.y = rect.height - textRect.height - allEdgeInsets.bottom
        }

        // 绘制文字边框
        _drawTextBorder(textDrawRect)
        // 绘制标线
        _drawMarkLine(textDrawRect)
    }

    /// 重新计算text的rect，用于自适应大小
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let allEdgeInsets = _contentEdgeInsets
        let insetRect = bounds.inset(by: allEdgeInsets)
        let superTextRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        return superTextRect
    }

    /// 配置数据的地方
    open func config() { }

    /// 创建UI的方法放在这里
    /// 最好按照，从上至下，从左至右依次添加视图
    open func makeUI() { }

    /// 数据即将刷新
    open func dataWillLoad() { }

    /// 正向数据流（页面操作的监听）方法放在这里
    open func bindViewAction() { }

    /// 反向数据流（ViewModel的监听）进行数据绑定的放在这里
    open func bindViewModel() { }

    /// 驱动数据流（外部业务要求执行内部方法），如果有需要绑定的，则实现该方法
    open func bindDriving() { }

    /// 通知数据流，主要用于接口暴露和复用
    open func bindNotice() { }

    // Internal

    lazy var _debugTextLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.axc.alpha(0.2).cgColor
        return layer
    }()

    /// ----内容----
    /// 内容边距
    var _contentEdgeInsets: AxcBedrockEdgeInsets = .zero

    /// ----文字----
    /// 文字水平对齐模式
    var _alignmentHorizontal: AxcPositionHorizontal = .left
    /// 文字垂直对齐模式
    var _alignmentVertical: AxcPositionVertical = .center
    /// 文字换行对齐模式
    var _alignmentHorizontalNewLine: AxcPositionHorizontal = .left

    /// ----边框----
    /// 文字边框线样式
    var _textBorderStyle: MarkLineConfig.Style = .none
    /// 文字边框宽度
    var _textBorderWidth: CGFloat = 1
    /// 文字边框宽度
    var _textBorderColor: AxcUnifiedColor?
    /// 文字边框线转角类型
    var _textBorderLineJoin: CGLineJoin = .round

    /// ----标线----
    /// 标线配置组
    var _markLines: [MarkLineConfig]?
    /// 标线距离文本的边距
    var _markLineTextEdgeSpacing: AxcBedrockEdgeInsets = .zero

    /// 绘制文字边框
    func _drawTextBorder(_ rect: CGRect) {
        guard _textBorderStyle != .none, // 设置了边框属性
              let textBorderColor = UIColor.Axc.CreateOptional(_textBorderColor),
              let context = UIGraphicsGetCurrentContext() else {
            super.drawText(in: rect)
            return
        }
        let shadowOffset = shadowOffset
        let textColor = textColor

        context.saveGState() // 压入上下文栈
        context.setLineWidth(_textBorderWidth) // 笔触宽度
        context.setLineStyle(_textBorderStyle) // 线样式
        context.setLineJoin(_textBorderLineJoin) // 线转角样式
        // 边框绘制
        context.setTextDrawingMode(.stroke)
        self.textColor = textBorderColor
        super.drawText(in: rect)
        // 还原参数
        self.textColor = textColor
        self.shadowOffset = shadowOffset
        context.setTextDrawingMode(.fill)
        context.restoreGState() // 推出保存的上下文
        super.drawText(in: rect)
    }

    /// 绘制标线
    func _drawMarkLine(_ textRect: CGRect) {
        guard let markLines = _markLines,
              let context = UIGraphicsGetCurrentContext() else { return }
        let allEdgeInsets = _contentEdgeInsets.axc.add(edge: _markLineTextEdgeSpacing)
        for markLine in markLines {
            if markLine.style == .none { continue }
            context.saveGState() // 压入上下文栈
            context.setStrokeColor(markLine.color.cgColor) // 线色
            context.setLineWidth(markLine.width) // 设置笔触宽度
            context.setLineStyle(markLine.style) // 线样式
            context.setLineCap(markLine.cap) // 线端点样式
            // 计算线的位置
            let path = _calculateLineBezierPath(textRect: textRect,
                                                edgePosition: markLine.edgePosition,
                                                lineWidth: markLine.width,
                                                allEdgeInsets: allEdgeInsets)
            // 添加路径到图形上下文
            context.addPath(path.cgPath)
            // 绘制路径
            context.strokePath()
            context.restoreGState() // 推出保存的上下文
        }
    }

    /// 计算线的框
    func _calculateLineBezierPath(textRect: CGRect,
                                  edgePosition: AxcUILabel.MarkLineConfig.EdgePosition,
                                  lineWidth: CGFloat,
                                  allEdgeInsets: AxcBedrockEdgeInsets) -> UIBezierPath {
        var startPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero

        switch edgePosition {
        // 线在文本顶部
        case let .top(axis: axis):
            let topLineSize: CGSize = sizeMinToZero(.init(width: textRect.width,
                                                          height: textRect.origin.y - allEdgeInsets.top))
            startPoint.x = textRect.origin.x
            startPoint.y = textRect.origin.y - _markLineTextEdgeSpacing.top - topLineSize.height
            switch axis {
            case let .horizontal(position: position): // 线为水平延展
                switch position {
                case .top: startPoint.y += lineWidth / 2 // 顶部
                case .center: startPoint.y += (topLineSize.height - lineWidth) / 2 // 中部
                case .bottom: startPoint.y += topLineSize.height - lineWidth // 底部
                }
                endPoint.x = startPoint.x + topLineSize.width
                endPoint.y = startPoint.y

            case let .vertical(position: position): // 线为垂直延展
                switch position {
                case .left: startPoint.x += lineWidth / 2
                case .center: startPoint.x += (topLineSize.width - lineWidth) / 2
                case .right: startPoint.x += topLineSize.width - lineWidth
                }
                endPoint.x = startPoint.x // 终点x值相同
                endPoint.y = startPoint.y + topLineSize.height
            }

        // 线在文本左侧
        case let .left(axis: axis):
            let leftLineSize: CGSize = sizeMinToZero(.init(width: textRect.origin.x - allEdgeInsets.left,
                                                           height: textRect.height))
            startPoint.x = textRect.origin.x - _markLineTextEdgeSpacing.left - leftLineSize.width
            startPoint.y = textRect.origin.y
            switch axis {
            case let .horizontal(position: position): // 线为水平延展
                switch position {
                case .top: startPoint.y += lineWidth / 2
                case .center: startPoint.y += (leftLineSize.height - lineWidth) / 2 // 中部
                case .bottom: startPoint.y += leftLineSize.height - lineWidth // 底部
                }
                endPoint.x = startPoint.x + leftLineSize.width
                endPoint.y = startPoint.y
            case let .vertical(position: position): // 线为垂直延展
                switch position {
                case .left: startPoint.x += lineWidth / 2
                case .center: startPoint.x += (leftLineSize.width - lineWidth) / 2 // 中部
                case .right: startPoint.x += leftLineSize.width - lineWidth // 右侧
                }
                endPoint.x = startPoint.x
                endPoint.y = startPoint.y + leftLineSize.height
            }

        // 线在文本底部
        case let .bottom(axis: axis):
            let textRectBottom = (textRect.origin.y + textRect.height)
            let bottomLineSize: CGSize = sizeMinToZero(.init(width: textRect.width,
                                                             height: frame.height - textRectBottom - allEdgeInsets.bottom))
            startPoint.x = textRect.origin.x
            startPoint.y = textRectBottom + _markLineTextEdgeSpacing.bottom
            switch axis {
            case let .horizontal(position: position): // 线为水平延展
                switch position {
                case .top: startPoint.y += lineWidth / 2
                case .center: startPoint.y += (bottomLineSize.height - lineWidth) / 2 // 中部
                case .bottom: startPoint.y += bottomLineSize.height - lineWidth // 底部
                }
                endPoint.x = startPoint.x + bottomLineSize.width
                endPoint.y = startPoint.y // 终点y值相同
            case let .vertical(position: position): // 线为垂直延展
                switch position {
                case .left: startPoint.x += lineWidth / 2
                case .center: startPoint.x += (bottomLineSize.width - lineWidth) / 2
                case .right: startPoint.x += bottomLineSize.width - lineWidth
                }
                endPoint.x = startPoint.x // 终点x值相同
                endPoint.y = startPoint.y + bottomLineSize.height
            }
        // 线在文本右侧
        case let .right(axis: axis):
            let textRectRight = (textRect.origin.x + textRect.width)
            let rightLineSize: CGSize = sizeMinToZero(.init(width: frame.width - textRectRight - allEdgeInsets.right,
                                                            height: textRect.height))
            startPoint.x = textRectRight + _markLineTextEdgeSpacing.right
            startPoint.y = textRect.origin.y
            switch axis {
            case let .horizontal(position: position):
                switch position {
                case .top: startPoint.y += lineWidth / 2
                case .center: startPoint.y += (rightLineSize.height - lineWidth) / 2
                case .bottom: startPoint.y += rightLineSize.height - lineWidth
                }
                endPoint.x = startPoint.x + rightLineSize.width
                endPoint.y = startPoint.y
            case let .vertical(position: position):
                switch position {
                case .left: startPoint.x += lineWidth / 2
                case .center: startPoint.x += (rightLineSize.width - lineWidth) / 2
                case .right: startPoint.x += rightLineSize.width - lineWidth
                }
                endPoint.x = startPoint.x
                endPoint.y = startPoint.y + rightLineSize.height
            }
        }
        let bezierPath = UIBezierPath()
        bezierPath.move(to: startPoint)
        bezierPath.addLine(to: endPoint)
        return bezierPath
    }

    // Fileprivate

    /// 设置大小最小不超过0
    fileprivate func sizeMinToZero(_ size: CGSize) -> CGSize {
        var newSize = size
        if newSize.width < 0 { newSize.width = 0 }
        if newSize.height < 0 { newSize.height = 0 }
        return newSize
    }
}

#endif
