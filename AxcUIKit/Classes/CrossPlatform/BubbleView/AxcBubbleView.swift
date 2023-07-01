//
//  AxcBubbleView.swift
//  Kingfisher
//
//  Created by 赵新 on 2023/5/31.
//

import SnapKit
import AxcBedrock

// MARK: - AxcBubbleView + AxcBubbleViewApi

extension AxcBubbleView: AxcBubbleViewApi {
    public var contentEdgeInsets: AxcBedrockEdgeInsets {
        return _contentEdgeInsets
    }

    public var contentView: AxcGradientView {
        return _contentView
    }

    public var arrowDirection: ArrowDirection {
        return _arrowDirection
    }

    public var arrowSize: CGSize {
        return _arrowSize
    }

    public var arrowRadius: CGFloat {
        return _arrowRadius
    }

    public var bubbleContentEdgeInsets: AxcBedrockEdgeInsets {
        return _bubbleContentEdgeInsets
    }

    public var bubbleCorners: AxcCorner {
        return _bubbleCorners
    }

    public var bubbleCornerRadius: CGFloat {
        return _bubbleCornerRadius
    }
}

extension AxcBubbleView {
    func _set(contentEdgeInsets: AxcBedrockEdgeInsets) {
        _contentEdgeInsets = contentEdgeInsets
        _updateMaskLayer()
        _updateContentView()
    }

    func _set(arrowDirection: AxcBubbleView.ArrowDirection) {
        _arrowDirection = arrowDirection
        _updateMaskLayer()
        _updateContentView()
    }

    func _set(arrowSize: CGSize) {
        _arrowSize = arrowSize
        _updateMaskLayer()
        _updateContentView()
    }

    func _set(arrowRadius: CGFloat) {
        _arrowRadius = arrowRadius
        _updateMaskLayer()
    }

    func _set(bubbleContentEdgeInsets: AxcBedrockEdgeInsets) {
        _bubbleContentEdgeInsets = bubbleContentEdgeInsets
        _updateMaskLayer()
        _updateContentView()
    }

    func _set(bubbleCorners: AxcCorner) {
        _bubbleCorners = bubbleCorners
        _updateMaskLayer()
    }

    func _set(bubbleCornerRadius: CGFloat) {
        _bubbleCornerRadius = bubbleCornerRadius
        _updateMaskLayer()
        _updateContentView()
    }
}

// MARK: - [AxcBubbleView]

open class AxcBubbleView: AxcGradientView {
    open override func axc_layoutSubviews() {
        super.axc_layoutSubviews()
        _updateMaskLayer()
    }

    open override func makeUI() {
        super.makeUI()
        set(backgroundColor: "000000")

        addSubview(contentView)
        _updateContentView()
    }

    func _updateContentView() {
        let distanceContent = _contentEdgeInsets.axc.add(edge: _bubbleContentEdgeInsets)
        var topDistance: CGFloat = distanceContent.top
        var leftDistance: CGFloat = distanceContent.left
        var bottomDistance: CGFloat = -distanceContent.bottom
        var rightDistance: CGFloat = -distanceContent.right
        switch _arrowDirection {
        case .top, .topCenter:
            topDistance += _arrowSize.height
        case .left, .leftCenter:
            leftDistance += _arrowSize.width
        case .bottom, .bottomCenter:
            bottomDistance += -_arrowSize.height
        case .right, .rightCenter:
            rightDistance += -_arrowSize.width
        }
        contentView.snp.remakeConstraints { make in
            make.top.equalTo(topDistance)
            make.left.equalTo(leftDistance)
            make.bottom.equalTo(bottomDistance)
            make.right.equalTo(rightDistance)
        }
    }

    func _updateMaskLayer() {
        guard frame != .zero else { return }
        // 一半大小，用于减轻运算次数
        let halfArrowSize: CGSize = .init(width: _arrowSize.width / 2, height: _arrowSize.height / 2)
        // 箭头偏移限位边距
        let arrowOffsetEdgeLimit: AxcBedrockEdgeInsets = _contentEdgeInsets.axc.add(size: _bubbleCornerRadius.axc.cgSize)
        // 根据方向留出空位
        var contentRectInsetEdge: AxcBedrockEdgeInsets = .Axc.Create(0) // 箭头的空位
        var arrowRoundCenter: CGPoint = .zero // 箭头顶部圆的中心点
        var startAngleRadian: CGFloat = 0 // 箭头顶部圆的起始角度
        var endAngleRadian: CGFloat = 0 // 箭头顶部圆的终止角度
        var clockwise: Bool = true // 顺逆时针

        var startPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero
        switch _arrowDirection {
        case let .top(offsetX: offsetX): createVertical(offsetX: offsetX, vertical: .top)
        case .topCenter: createVertical(offsetX: (frame.width - _arrowSize.width) / 2, vertical: .top)

        case let .left(offsetY: offsetY): createHorizontal(offsetY: offsetY, horizontal: .left)
        case .leftCenter: createHorizontal(offsetY: (frame.height - _arrowSize.height) / 2, horizontal: .left)

        case let .bottom(offsetX: offsetX): createVertical(offsetX: offsetX, vertical: .bottom)
        case .bottomCenter: createVertical(offsetX: (frame.width - _arrowSize.width) / 2, vertical: .bottom)

        case let .right(offsetY: offsetY): createHorizontal(offsetY: offsetY, horizontal: .right)
        case .rightCenter: createHorizontal(offsetY: (frame.height - _arrowSize.height) / 2, horizontal: .right)
        }

        // 构建垂直参数
        func createVertical(offsetX: CGFloat, vertical: AxcDirectionVertical) {
            let arrowHalfRadian: CGFloat = atan2(halfArrowSize.width, _arrowSize.height) // 等腰三角内角角度
            let arrowInteriorAngle = 90 - arrowHalfRadian.axc.radianToAngle // 同角三角形的内角相等
            var arrowRoundCenterX = offsetX + halfArrowSize.width
            // 设限阈值
            let less = _contentEdgeInsets.left + _bubbleCornerRadius + halfArrowSize.width
            let greater = frame.width - _contentEdgeInsets.right - _bubbleCornerRadius - halfArrowSize.width
            arrowRoundCenterX = arrowRoundCenterX.axc.limitThan(min: less,
                                                                max: greater)
            switch vertical {
            case .top:
                contentRectInsetEdge = _arrowSize.height.axc.edgeTop
                arrowRoundCenter = .init(x: arrowRoundCenterX, y: _arrowRadius + _contentEdgeInsets.top)
                startAngleRadian = (-90 - arrowInteriorAngle).axc.angleToRadian
                endAngleRadian = (-90 + arrowInteriorAngle).axc.angleToRadian
                clockwise = true
                startPoint = CGPoint(x: offsetX + _arrowSize.width,
                                     y: _arrowSize.height + _contentEdgeInsets.top)

            case .bottom:
                contentRectInsetEdge = _arrowSize.height.axc.edgeBottom
                arrowRoundCenter = .init(x: arrowRoundCenterX, y: frame.height - _arrowRadius - _contentEdgeInsets.bottom)
                startAngleRadian = (-270 + arrowInteriorAngle).axc.angleToRadian
                endAngleRadian = (-270 - arrowInteriorAngle).axc.angleToRadian
                clockwise = false
                startPoint = CGPoint(x: offsetX + _arrowSize.width,
                                     y: frame.height - _arrowSize.height - _contentEdgeInsets.bottom)
            }
            endPoint = CGPoint(x: offsetX, y: startPoint.y)
            // 设置水平限位
            startPoint.x = startPoint.x.axc.limitThan(min: arrowOffsetEdgeLimit.left + _arrowSize.width,
                                                      max: frame.width - arrowOffsetEdgeLimit.right)
            endPoint.x = endPoint.x.axc.limitThan(min: arrowOffsetEdgeLimit.left,
                                                  max: frame.width - arrowOffsetEdgeLimit.right - _arrowSize.width)
        }

        // 构建水平参数
        func createHorizontal(offsetY: CGFloat, horizontal: AxcDirectionHorizontal) {
            let arrowHalfRadian: CGFloat = atan2(halfArrowSize.height, _arrowSize.width) // 等腰三角内角角度
            let arrowInteriorAngle = 90 - arrowHalfRadian.axc.radianToAngle // 同角三角形的内角相等
            var arrowRoundCenterY = offsetY + halfArrowSize.height
            // 设限阈值
            let less = _contentEdgeInsets.top + _bubbleCornerRadius + halfArrowSize.height
            let greater = frame.width - _contentEdgeInsets.bottom - _bubbleCornerRadius - halfArrowSize.height
            arrowRoundCenterY = arrowRoundCenterY.axc.limitThan(min: less,
                                                                max: greater)
            switch horizontal {
            case .left:
                contentRectInsetEdge = _arrowSize.width.axc.edgeLeft
                arrowRoundCenter = .init(x: _arrowRadius + _contentEdgeInsets.left, y: arrowRoundCenterY)
                startAngleRadian = (180 - arrowInteriorAngle).axc.angleToRadian
                endAngleRadian = (180 + arrowInteriorAngle).axc.angleToRadian
                clockwise = true
                startPoint = CGPoint(x: _arrowSize.width + _contentEdgeInsets.left, y: offsetY)

            case .right:
                contentRectInsetEdge = _arrowSize.width.axc.edgeRight
                arrowRoundCenter = .init(x: frame.width - _arrowRadius - _contentEdgeInsets.right, y: arrowRoundCenterY)
                let arrowRoundRadian = arrowInteriorAngle.axc.angleToRadian
                startAngleRadian = arrowRoundRadian
                endAngleRadian = -arrowRoundRadian
                clockwise = false
                startPoint = CGPoint(x: frame.width - _arrowSize.width - _contentEdgeInsets.right, y: offsetY)
            }
            endPoint = CGPoint(x: startPoint.x, y: offsetY + _arrowSize.height)
            // 设置垂直限位
            endPoint.y = endPoint.y.axc.limitThan(min: arrowOffsetEdgeLimit.top + _arrowSize.height,
                                                  max: frame.height - arrowOffsetEdgeLimit.bottom)
            startPoint.y = startPoint.y.axc.limitThan(min: arrowOffsetEdgeLimit.top,
                                                      max: frame.width - arrowOffsetEdgeLimit.bottom - _arrowSize.height)
        }

        // 内容框
        let contentRect: CGRect = bounds.axc.inside(edge: _contentEdgeInsets)
        let roundedRect: CGRect = contentRect.axc.inside(edge: contentRectInsetEdge)
        let maskBezier: AxcBedrockBezierPath = .Axc.Create(roundedRect: roundedRect,
                                                           byRoundingCorners: _bubbleCorners,
                                                           cornerRadii: _bubbleCornerRadius.axc.cgSize)
        // 从圆开始，顺时针
        let arrowRoundBezier: AxcBedrockBezierPath = .Axc.Create(arcCenter: arrowRoundCenter,
                                                                 radius: _arrowRadius,
                                                                 startAngle: startAngleRadian,
                                                                 endAngle: endAngleRadian,
                                                                 clockwise: clockwise) // 逆时针
        // 上方起始点
        arrowRoundBezier.axc.addLine(to: startPoint)
        // 底部结束点
        arrowRoundBezier.axc.addLine(to: endPoint)
        arrowRoundBezier.close() // 闭合图案
        // 两个贝塞尔合并
        maskBezier.append(arrowRoundBezier)
        _shapeLayer.path = maskBezier.axc.cgPath // 赋值图案
        axc_layer?.mask = _shapeLayer
    }

    /// 内容间距
    var _contentEdgeInsets: AxcBedrockEdgeInsets = .Axc.Create(0)

    /// 箭头位置
    var _arrowDirection: ArrowDirection = .rightCenter
    /// 箭头大小
    var _arrowSize: CGSize = .init(width: 6, height: 12)
    /// 箭头圆角半径
    var _arrowRadius: CGFloat = 2

    /// 气泡内容间距
    var _bubbleContentEdgeInsets: AxcBedrockEdgeInsets = 4.axc.edge
    /// 气泡圆角组
    var _bubbleCorners: AxcCorner = .all
    /// 气泡圆角半径
    var _bubbleCornerRadius: CGFloat = 4

    lazy var _shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }()

    lazy var _contentView: AxcGradientView = {
        let view = AxcGradientView()
        return view
    }()
}
