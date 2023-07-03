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
        _label.attributedText = _text
        _setTextAttributed()
    }

    func _set(textFont: AxcUnifiedFont) {
        _textFont = textFont
        _makeTextAttributed { $0.set(font: textFont) }
    }

    func _set(textColor: AxcUnifiedColor) {
        _textColor = textColor
        _makeTextAttributed { $0.set(foregroundColor: textColor) }
    }

    func _set(textBackgroundColor: AxcUnifiedColor) {
        _textBackgroundColor = textBackgroundColor
        _label.backgroundColor = AxcBedrockColor.Axc.Create(textBackgroundColor)
    }

    func _set(textAlignment: NSTextAlignment) {
        _textAlignment = textAlignment
        _makeParagraphStyle { $0.set(alignment: textAlignment) }
    }

    func _set(numberOfLineType: NumberOfLineType) {
        _numberOfLineType = numberOfLineType
        switch numberOfLineType {
        case .single: _label.numberOfLines = 1
        case let .mutable(lineCount: lineCount): _label.numberOfLines = lineCount
        case .infinite: _label.numberOfLines = 0
        }
    }

    func _set(textLineBreakMode: NSLineBreakMode) {
        _textLineBreakMode = textLineBreakMode
        _label.lineBreakMode = textLineBreakMode
    }

    func _set(lineSpacing: AxcUnifiedNumber) {
        _lineSpacing = lineSpacing
        _makeParagraphStyle { $0.set(lineSpacing: lineSpacing) }
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
    }

    func _set(textBorderColor: AxcUnifiedColor?) {
        _textBorderColor = textBorderColor
    }

    func _set(textBorderWidth: CGFloat) {
        _textBorderWidth = textBorderWidth
    }

    func _set(textBorderLineJoin: CGLineJoin) {
        _textBorderLineJoin = textBorderLineJoin
    }

    func _set(markLines: [MarkLineConfig]?) {
        _markLines = markLines
    }

    func _set(markLineTextEdgeSpacing: AxcBedrockEdgeInsets) {
        _markLineTextEdgeSpacing = markLineTextEdgeSpacing
        _updateLayout()
    }
}

// MARK: - [AxcLabel]

open class AxcLabel: AxcGradientView {
    open override func makeUI() {
        super.makeUI()
        // 内容视图
        addSubview(contentView)
        // 文本标签视图
        contentView.addSubview(_label)
        _setTextAttributed()
        _updateLayout()
    }

    func _updateLayout() {
        guard _label.superview != nil else { return }
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(_contentEdgeInsets)
        }
        _label.snp.remakeConstraints { make in
            make.left.greaterThanOrEqualToSuperview().offset(_markLineTextEdgeSpacing.left)
            make.right.lessThanOrEqualToSuperview().offset(-_markLineTextEdgeSpacing.right)
            make.top.greaterThanOrEqualToSuperview().offset(_markLineTextEdgeSpacing.top)
            make.bottom.lessThanOrEqualToSuperview().offset(-_markLineTextEdgeSpacing.bottom)
            // 文字水平对齐
            switch _textPositionHorizontal {
            case .left:
                make.left.equalToSuperview().offset(_markLineTextEdgeSpacing.left)
            case .center:
                make.centerX.equalToSuperview()
            case .right:
                make.right.equalToSuperview().offset(-_markLineTextEdgeSpacing.right)
            }
            // 文字垂直对齐
            switch _textPositionVertical {
            case .top:
                make.top.equalToSuperview().offset(_markLineTextEdgeSpacing.top)
            case .center:
                make.centerY.equalToSuperview()
            case .bottom:
                make.bottom.equalToSuperview().offset(-_markLineTextEdgeSpacing.bottom)
            }
        }
    }

    /// 设置默认值/存储值
    func _setTextAttributed() {
        // label属性
        _set(textBackgroundColor: _textBackgroundColor)
        _set(numberOfLineType: _numberOfLineType)
        _set(textLineBreakMode: _textLineBreakMode)
        // 富文本属性
        _paragraphStyle = _paragraphStyle.axc.makeParagraphStyle {
            $0.set(alignment: _textAlignment)
                .set(lineSpacing: _lineSpacing)
        }
        _makeTextAttributed {
            $0.set(font: _textFont)
                .set(foregroundColor: _textColor)
                .set(paragraphStyle: _paragraphStyle)
        }
    }

    /// 设置富文本属性
    func _makeTextAttributed(_ makeBlock: AxcBlock.Maker<AxcMaker.AttributedString>) {
        _text = _label.attributedText?.axc.makeAttributed(makeBlock)
        _label.attributedText = nil // 需要触发重绘
        _label.attributedText = _text
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
    /// 文字换行类型
    var _numberOfLineType: NumberOfLineType = .infinite
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

    /// 文字段落样式
    lazy var _paragraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        return paragraphStyle
    }()

    lazy var contentView: AxcView = {
        let view = AxcView()
        view.set(backgroundColor: AxcBedrockColor.clear)
        return view
    }()

    // ----获取----
    #if os(macOS)
    open lazy var _label: _AxcNSLabel = {
        let label = _AxcNSLabel()
        return label
    }()

    #elseif os(iOS) || os(tvOS) || os(watchOS)

    lazy var _label: _AxcUILabel = {
        let label = _AxcUILabel()
        return label
    }()
    #endif
}
