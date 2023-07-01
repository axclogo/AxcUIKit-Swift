//
//  AxcLabel.swift
//  AxcBedrock
//
//  Created by 赵新 on 2023/6/30.
//

import AxcBedrock

// MARK: - AxcLabel + AxcLabelApi

extension AxcLabel: AxcLabelApi {
    public var contentEdgeInsets: AxcBedrockEdgeInsets {
        return _contentEdgeInsets
    }

    public var textBorderWidth: CGFloat {
        return _textBorderWidth
    }

    public var textPositionHorizontal: AxcPositionHorizontal {
        return _textPositionHorizontal
    }

    public var textPositionVertical: AxcPositionVertical {
        return _textPositionVertical
    }

    public var textPositionHorizontalNewLine: AxcPositionVertical {
        return _textPositionVertical
    }

    public var textBorderColor: AxcBedrockColor? {
        return AxcBedrockColor.Axc.CreateOptional(_textBorderColor)
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

extension AxcLabel {
    func _set(contentEdgeInsets: AxcBedrockEdgeInsets) {
        _contentEdgeInsets = contentEdgeInsets
        _updateLayout()
    }

    func _set(text: AxcUnifiedString) {
        _text = NSAttributedString.Axc.Create(text) // 统一使用富文本
        _setTextAttributed()
        _updateLayout()
    }

    func _set(textFont: AxcUnifiedFont) {
        _textFont = textFont
        _makeTextAttributed { $0.set(font: textFont) }
        _updateLayout()
    }

    func _set(textColor: AxcUnifiedColor) {
        _textColor = textColor
        _makeTextAttributed { $0.set(foregroundColor: textColor) }
    }

    func _set(textBackgroundColor: AxcUnifiedColor) {
        _textBackgroundColor = textBackgroundColor
        _textLayer.backgroundColor = CGColor.Axc.Create(textBackgroundColor)
    }

    func _set(textAlignment: NSTextAlignment) {
        _textAlignment = textAlignment
        _makeParagraphStyle { $0.set(alignment: textAlignment) }
        _updateLayout()
    }

    func _set(textLineBreakMode: NSLineBreakMode) {
        _textLineBreakMode = textLineBreakMode
        _textLayer.truncationMode = _textLineBreakMode.axc.caTextLayerTruncationMode ?? .none
//        _makeParagraphStyle{ $0.set(alignment: textAlignment) } // 这里不能设置，否则计算大小会出问题
        _updateLayout()
    }

    func _set(lineSpacing: AxcUnifiedNumber) {
        _lineSpacing = lineSpacing
        _makeParagraphStyle { $0.set(lineSpacing: lineSpacing) }
        _updateLayout()
    }

    func _set(textPositionHorizontal: AxcPositionHorizontal) {
        _textPositionHorizontal = textPositionHorizontal
        _updateLayout()
    }

    func _set(textPositionVertical: AxcPositionVertical) {
        _textPositionVertical = textPositionVertical
        _updateLayout()
    }

    func _set(textBorderStyle: MarkLineConfig.Style) {
        _textBorderStyle = textBorderStyle
        _updateLayout()
    }

    func _set(textBorderColor: AxcUnifiedColor?) {
        _textBorderColor = textBorderColor
        _updateLayout()
    }

    func _set(textBorderWidth: CGFloat) {
        _textBorderWidth = textBorderWidth
        _updateLayout()
    }

    func _set(textBorderLineJoin: CGLineJoin) {
        _textBorderLineJoin = textBorderLineJoin
        _updateLayout()
    }

    func _set(markLines: [MarkLineConfig]?) {
        _markLines = markLines
        _updateLayout()
    }

    func _set(markLineTextEdgeSpacing: AxcBedrockEdgeInsets) {
        _markLineTextEdgeSpacing = markLineTextEdgeSpacing
    }
}

// MARK: - [AxcLabel]

open class AxcLabel: AxcGradientView {
    open override func axc_layoutSubviews() {
        super.axc_layoutSubviews()
        _updateLayout()
    }

    /// 自适应大小
    open override var intrinsicContentSize: CGSize {
        _updateLayout()
        var contentSize: CGSize = _textSize() // 默认文字大小
        // 加上标线边距
        contentSize = contentSize.axc.add(edge: _markLineTextEdgeSpacing)
        // 加上内容边距
        contentSize = contentSize.axc.add(edge: _contentEdgeInsets)
        return contentSize
    }

    open override func config() {
        super.config()
        axc_layer?.addSublayer(_contentLayer)
        _contentLayer.addSublayer(_textLayer)
        _setTextAttributed()
    }


    func _updateLayout() {
        // 内容视图边距
        _contentLayer.frame = bounds.axc.inside(edge: _contentEdgeInsets)
        var textFrame: CGRect = .zero
        let textSize = _textSize()
        let textRect = _textRect()
        textFrame.size = textSize
        // 文字水平对齐
        switch _textPositionHorizontal {
        case .left:
            textFrame.origin.x = textRect.origin.x
        case .center:
            textFrame.origin.x = (textRect.width - textSize.width) / 2
        case .right:
            textFrame.origin.x = textRect.width - textSize.width
        }
        // 文字垂直对齐
        switch _textPositionVertical {
        case .center:
            textFrame.origin.y = (textRect.height - textSize.height) / 2
        #if os(macOS) // MacOS的Y轴和iOS是相反的
        case .top:
            textFrame.origin.y = textRect.height - textSize.height
        case .bottom:
            textFrame.origin.y = textRect.origin.y
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        case .top:
            textFrame.origin.y = textRect.origin.y
        case .bottom:
            textFrame.origin.y = textRect.height - textSize.height
        #endif
        }
        // 设置极限值
        textFrame.origin.x = textFrame.origin.x.axc.limitMinZero(max: textRect.maxX)
        textFrame.origin.y = textFrame.origin.y.axc.limitMinZero(max: textRect.maxY)
        textFrame.size.width = textFrame.size.width.axc.limitMinZero(max: textRect.width)
        textFrame.size.height = textFrame.size.height.axc.limitMinZero(max: textRect.height)
        _textLayer.frame = textFrame
        
        // 告诉系统view应该根据内容调整大小
        invalidateIntrinsicContentSize()
    }

    func _textRect() -> CGRect {
        return _contentLayer.frame.axc.inside(edge: _markLineTextEdgeSpacing)
    }

    /// 文字大小
    func _textSize() -> CGSize {
        var maxSize: CGSize = _textRect().size // ⚠️这里需要处理标线问题
        if isLayoutFixedSize() { // 是否有固定大小
            print("固定大小r")
            // 无需处理
        } else if isLayoutFixedWidth() { // 固定了宽度
            maxSize.height = .Axc.Max
        } else if isLayoutFixedHeight() { // 固定了高度
            maxSize.width = .Axc.Max
        } else { // 没有固定大小
            maxSize.width = .Axc.Max // 宽度无限大
        }
        maxSize.height = 0
        var textSize: CGSize = .zero
        if let attStr = _text {
            textSize = attStr.axc.textSize(maxSize: maxSize)
        }
//        else if let string = String.Axc.CreateOptional(_text) { // 普通字符串
//            // 同步计算格式
//            let paragraphStyle = NSMutableParagraphStyle.Axc.CreateParagraphStyle { make in
//                if let nsTextAlignment = _textLayer.alignmentMode.axc.nsTextAlignment { // 对齐模式
//                    make.set(alignment: nsTextAlignment)
//                }
        ////                if let lineBreakMode = _textLayer.truncationMode.axc.nsLineBreakMode { // 截断模式
        ////                    make.set(lineBreakMode: lineBreakMode)
        ////                }
//            }
//            textSize = string.axc.textSize(maxSize: maxSize, font: _textFont, paragraphStyle: paragraphStyle)
//        }
        return textSize
    }

    /// 设置默认值/存储值
    func _setTextAttributed() {
        _set(textFont: _textFont)
        _set(textColor: _textColor)
        _set(textBackgroundColor: _textBackgroundColor)
        _set(textAlignment: _textAlignment)
        _set(textLineBreakMode: _textLineBreakMode)
        _set(lineSpacing: _lineSpacing)
    }
    
    /// 设置富文本属性
    func _makeTextAttributed(_ makeBlock: AxcBlock.Maker<AxcMaker.AttributedString>) {
        _text = _text?.axc.makeAttributed(makeBlock)
        _textLayer.string = _text
    }

    /// 设置段落
    func _makeParagraphStyle(_ makeBlock: AxcBlock.Maker<AxcMaker.ParagraphStyle>) {
        _paragraphStyle = _paragraphStyle.axc.makeParagraphStyle(makeBlock)
        _makeTextAttributed { make in
            make.set(paragraphStyle: _paragraphStyle)
        }
    }

    /// ----内容----
    /// 内容边距
    var _contentEdgeInsets: AxcBedrockEdgeInsets = .Axc.Create(0)
    /// 文字
    var _text: NSAttributedString?
    /// 文字大小
    var _textFont: AxcUnifiedFont = 18
    /// 文字颜色
    var _textColor: AxcUnifiedColor = "000000"
    /// 文字背景色
    var _textBackgroundColor: AxcUnifiedColor = AxcBedrockColor.clear
    /// 文字对齐模式
    var _textAlignment: NSTextAlignment = .left
    /// 文字截断模式
    var _textLineBreakMode: NSLineBreakMode = .byTruncatingTail
    /// 文字行间距
    var _lineSpacing: AxcUnifiedNumber = 2

    /// ----文字----
    /// 文字水平对齐模式
    var _textPositionHorizontal: AxcPositionHorizontal = .center
    /// 文字垂直对齐模式
    var _textPositionVertical: AxcPositionVertical = .center

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
    var _markLineTextEdgeSpacing: AxcBedrockEdgeInsets = .Axc.Create(0)

    /// ----获取----
    /// 文本绘制图层
    lazy var _textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        #if os(macOS)
        if let screen = NSScreen.main { // 设置为主显示器的缩放比例
            textLayer.contentsScale = screen.backingScaleFactor
        }
        #elseif os(iOS) || os(tvOS) || os(watchOS)
        // 根据屏幕缩放比率调整
        textLayer.contentsScale = UIScreen.main.scale
        #endif
        textLayer.isWrapped = true
        textLayer.delegate = self
        return textLayer
    }()

    /// 文字段落样式
    lazy var _paragraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        return paragraphStyle
    }()

    /// 内容图层
    lazy var _contentLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
}

extension AxcLabel: CALayerDelegate {
    /// 关闭隐式动画
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}
