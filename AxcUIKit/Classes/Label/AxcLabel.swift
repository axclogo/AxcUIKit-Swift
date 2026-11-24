//
//  AxcLabel.swift
//  AxcBedrock
//
//  Created by 赵新 on 2023/6/30.
//

#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif
#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif
#if canImport(AxcUIKitGradient)
import AxcUIKitGradient
#endif
import QuartzCore
import SnapKit
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - AxcLabel + AxcLabelApi

extension AxcLabel: AxcLabelApi {
    public var textLabel: AxcSystemLabel {
        return _label
    }

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

    @available(*, deprecated, renamed: "textPositionVertical")
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
        invalidateIntrinsicContentSize()
    }

    func _set(text: AxcUnifiedString) {
        _text = NSAttributedString.Axc.Create(text) // 统一使用富文本
        _label.attributedText = _text
        _setTextAttributed()
        invalidateIntrinsicContentSize()
    }

    func _set(textFont: AxcUnifiedFont) {
        _textFont = textFont
        _makeTextAttributed { $0.set(font: textFont) }
        invalidateIntrinsicContentSize()
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
        case let .multiple(lineCount), let .mutable(lineCount):
            _label.numberOfLines = max(0, lineCount)
        case .infinite: _label.numberOfLines = 0
        }
        invalidateIntrinsicContentSize()
    }

    func _set(textLineBreakMode: NSLineBreakMode) {
        _textLineBreakMode = textLineBreakMode
        _label.lineBreakMode = textLineBreakMode
        invalidateIntrinsicContentSize()
    }

    func _set(lineSpacing: AxcUnifiedNumber) {
        _lineSpacing = lineSpacing
        _makeParagraphStyle { $0.set(lineSpacing: lineSpacing) }
        invalidateIntrinsicContentSize()
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
        _setNeedsDecorationLayout()
    }

    func _set(textBorderColor: AxcUnifiedColor?) {
        _textBorderColor = textBorderColor
        _setNeedsDecorationLayout()
    }

    func _set(textBorderWidth: CGFloat) {
        _textBorderWidth = textBorderWidth
        _setNeedsDecorationLayout()
    }

    func _set(textBorderLineJoin: CGLineJoin) {
        _textBorderLineJoin = textBorderLineJoin
        _setNeedsDecorationLayout()
    }

    func _set(markLines: [MarkLineConfig]?) {
        _markLines = markLines
        _setNeedsDecorationLayout()
    }

    func _set(markLineTextEdgeSpacing: AxcBedrockEdgeInsets) {
        _markLineTextEdgeSpacing = markLineTextEdgeSpacing
        _updateLayout()
        invalidateIntrinsicContentSize()
    }
}

// MARK: - [AxcLabel]

open class AxcLabel: AxcGradientView {
    open override func axc_layoutSubviews() {
        super.axc_layoutSubviews()
        _updateDecorationLayers()
    }

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

    /// 根据文本内容和边距提供动态尺寸，支持 Auto Layout 自适应。
    open override var intrinsicContentSize: CGSize {
        let textSize = _label.intrinsicContentSize
        return CGSize(
            width: textSize.width + _contentEdgeInsets.left + _contentEdgeInsets.right
                + _markLineTextEdgeSpacing.left + _markLineTextEdgeSpacing.right,
            height: textSize.height + _contentEdgeInsets.top + _contentEdgeInsets.bottom
                + _markLineTextEdgeSpacing.top + _markLineTextEdgeSpacing.bottom
        )
    }

    #if os(iOS) || os(tvOS)
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let horizontalInsets = _contentEdgeInsets.left + _contentEdgeInsets.right
            + _markLineTextEdgeSpacing.left + _markLineTextEdgeSpacing.right
        let verticalInsets = _contentEdgeInsets.top + _contentEdgeInsets.bottom
            + _markLineTextEdgeSpacing.top + _markLineTextEdgeSpacing.bottom
        let textSize = _label.sizeThatFits(CGSize(
            width: max(0, size.width - horizontalInsets),
            height: max(0, size.height - verticalInsets)
        ))
        return CGSize(width: textSize.width + horizontalInsets, height: textSize.height + verticalInsets)
    }
    #endif

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

    /// 更新文字边框和标线。装饰层不参与布局，因此不会改变文本测量结果。
    func _updateDecorationLayers() {
        _textBorderLayer.removeFromSuperlayer()
        _markLineLayers.forEach { $0.removeFromSuperlayer() }
        _markLineLayers.removeAll(keepingCapacity: true)

        let textRect = convert(_label.bounds, from: _label)
        guard !textRect.isEmpty else { return }

        if _textBorderStyle != .none,
           _textBorderWidth > 0,
           let color = AxcBedrockColor.Axc.CreateOptional(_textBorderColor) {
            _configure(
                layer: _textBorderLayer,
                style: _textBorderStyle,
                color: color.cgColor,
                width: _textBorderWidth,
                cap: .butt
            )
            _textBorderLayer.path = CGPath(rect: textRect, transform: nil)
            _textBorderLayer.lineJoin = _textBorderLineJoin.axc_shapeLayerLineJoin
            currentLayer?.addSublayer(_textBorderLayer)
        }

        for config in _markLines ?? [] where config.style != .none && config.width > 0 {
            let layer = CAShapeLayer()
            _configure(
                layer: layer,
                style: config.style,
                color: config.color.cgColor,
                width: config.width,
                cap: config.cap
            )
            let path = CGMutablePath()
            switch config.edgePosition {
            case .top:
                path.move(to: CGPoint(x: textRect.minX, y: textRect.minY))
                path.addLine(to: CGPoint(x: textRect.maxX, y: textRect.minY))
            case .left:
                path.move(to: CGPoint(x: textRect.minX, y: textRect.minY))
                path.addLine(to: CGPoint(x: textRect.minX, y: textRect.maxY))
            case .bottom:
                path.move(to: CGPoint(x: textRect.minX, y: textRect.maxY))
                path.addLine(to: CGPoint(x: textRect.maxX, y: textRect.maxY))
            case .right:
                path.move(to: CGPoint(x: textRect.maxX, y: textRect.minY))
                path.addLine(to: CGPoint(x: textRect.maxX, y: textRect.maxY))
            }
            layer.path = path
            currentLayer?.addSublayer(layer)
            _markLineLayers.append(layer)
        }
    }

    func _configure(
        layer: CAShapeLayer,
        style: MarkLineConfig.Style,
        color: CGColor,
        width: CGFloat,
        cap: CGLineCap
    ) {
        layer.frame = bounds
        layer.fillColor = nil
        layer.strokeColor = color
        layer.lineWidth = width
        layer.lineCap = cap.axc_shapeLayerLineCap
        switch style {
        case .none, .solid:
            layer.lineDashPattern = nil
        case let .dotted(phase, lengths):
            layer.lineDashPhase = phase
            layer.lineDashPattern = lengths.map { NSNumber(value: Double($0)) }
        }
    }

    func _setNeedsDecorationLayout() {
        #if os(macOS)
        needsLayout = true
        #elseif os(iOS) || os(tvOS)
        setNeedsLayout()
        #endif
    }

    /// ----内容----
    /// 内容边距
    var _contentEdgeInsets: AxcBedrockEdgeInsets = .Axc.Create(all: 0)
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
    var _markLineTextEdgeSpacing: AxcBedrockEdgeInsets = .Axc.Create(all: 0)

    /// 文字段落样式
    lazy var _paragraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        return paragraphStyle
    }()

    private let _textBorderLayer = CAShapeLayer()
    private var _markLineLayers: [CAShapeLayer] = []

    public lazy var contentView: AxcView = {
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

    #elseif os(iOS) || os(tvOS)

    lazy var _label: _AxcUILabel = {
        let label = _AxcUILabel()
        return label
    }()
    #endif
}

private extension CGLineJoin {
    var axc_shapeLayerLineJoin: CAShapeLayerLineJoin {
        switch self {
        case .bevel: return .bevel
        case .miter: return .miter
        case .round: return .round
        @unknown default: return .round
        }
    }
}

private extension CGLineCap {
    var axc_shapeLayerLineCap: CAShapeLayerLineCap {
        switch self {
        case .butt: return .butt
        case .round: return .round
        case .square: return .square
        @unknown default: return .butt
        }
    }
}
