//
//  AxcGradientLayer.swift
//  AxcKit
//
//  Created by 赵新 on 2022/12/24.
//

import QuartzCore
import AxcBedrock

extension AxcGradientLayer.Style {
    /// 水垂方向
    var topPoint: CGPoint { return .init(x: 0.5, y: 0) }
    var leftPoint: CGPoint { return .init(x: 0, y: 0.5) }
    var bottomPoint: CGPoint { return .init(x: 0.5, y: 1) }
    var rightPoint: CGPoint { return .init(x: 1, y: 0.5) }
    /// 斜方向
    var topLeftPoint: CGPoint { return .init(x: 0, y: 0) }
    var topRightPoint: CGPoint { return .init(x: 1, y: 0) }
    var bottomLeftPoint: CGPoint { return .init(x: 0, y: 1) }
    var bottomRightPoint: CGPoint { return .init(x: 1, y: 1) }
    /// 中心
    var centerPoint: CGPoint { return .init(x: 0.5, y: 0.5) }
    /// 起始点
    var startPoint: CGPoint {
        switch self {
        case let .axis(axisStyle):
            var point: CGPoint = .zero
            switch axisStyle {
            case .topToBottom: point = topPoint
            case .leftToRight: point = leftPoint
            case .bottomToTop: point = bottomPoint
            case .rightToLeft: point = rightPoint
            }
            return point
        case let .axisTilt(axisTiltStyle):
            var point: CGPoint = .zero
            switch axisTiltStyle {
            case .topLeftToBottomRight: point = topLeftPoint
            case .topRightToBottomLeft: point = topRightPoint
            case .bottomLeftToTopRight: point = bottomLeftPoint
            case .bottomRightToTopLeft: point = bottomRightPoint
            }
            return point
        case .conic:
            return centerPoint
        case .radial:
            return centerPoint
        }
    }

    /// 终止点
    var endPoint: CGPoint {
        switch self {
        case let .axis(axisStyle):
            var point: CGPoint = .zero
            switch axisStyle {
            case .topToBottom: point = bottomPoint
            case .leftToRight: point = rightPoint
            case .bottomToTop: point = topPoint
            case .rightToLeft: point = leftPoint
            }
            return point
        case let .axisTilt(axisTiltStyle):
            var point: CGPoint = .zero
            switch axisTiltStyle {
            case .topLeftToBottomRight: point = bottomRightPoint
            case .topRightToBottomLeft: point = bottomLeftPoint
            case .bottomLeftToTopRight: point = topRightPoint
            case .bottomRightToTopLeft: point = topLeftPoint
            }
            return point
        case .conic:
            return topPoint
        case .radial:
            return bottomRightPoint
        }
    }

    var type: CAGradientLayerType {
        switch self {
        case .axis: return .axial
        case .axisTilt: return .axial
        case .conic:
            if #available(iOS 12.0, *) {
                return .conic
            } else {
                AxcUIKitLib.Log("\(self)系统版本低于iOS12，无法使用锥形渐变样式！将自动替换为梯度样式", logLevel: .warning)
                return .axial
            }
        case .radial: return .radial
        }
    }
}

// MARK: - AxcGradientLayer + AxcGradientLayerApi

extension AxcGradientLayer: AxcGradientLayerApi {
    public var gradientStyle: AxcGradientLayer.Style {
        return _gradientStyle
    }

    public var gradientColors: [AxcGradientLayer.GradientColor]? {
        return _gradientColors
    }
}

extension AxcGradientLayer {
    /// 设置渐变样式
    /// - Parameter style: 渐变样式
    func _set(gradientStyle: AxcGradientLayer.Style) {
        _gradientStyle = gradientStyle
        _gradientLayer.type = _gradientStyle.type
        _gradientLayer.startPoint = _gradientStyle.startPoint
        _gradientLayer.endPoint = _gradientStyle.endPoint
    }

    /// 设置梯度颜色组
    /// - Parameter gradientColors: 梯度颜色组
    func _set(gradientColors: [AxcGradientLayer.GradientColor]?) {
        _gradientColors = gradientColors
        _setGradientColorsParams(_gradientColors)
    }
}

// MARK: - [AxcGradientLayer]

open class AxcGradientLayer: AxcLayer {
    open override func layoutSublayers() {
        super.layoutSublayers()
        _gradientLayer.frame = bounds
    }

    /// 创建UI的方法放在这里
    /// 最好按照，从上至下，从左至右依次添加视图
    open override func makeUI() {
        super.makeUI()
        addSublayer(_gradientLayer)
    }

    /// 样式
    var _gradientStyle: Style = .axis(.leftToRight)
    /// 梯度颜色
    var _gradientColors: [GradientColor]?

    lazy var _gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
}

extension AxcGradientLayer {
    /// 设置参数到渐变Layer
    func _setGradientColorsParams(_ gradientColors: [GradientColor]?) {
        if let gradientColors = gradientColors {
            var colors: [CGColor] = []
            var locations: [CGFloat] = []
            for item in gradientColors {
                if let color = AxcBedrockColor.Axc.CreateOptional(item.color)?.cgColor {
                    colors.append(color)
                }
                if let location = item.location {
                    locations.append(location)
                }
            }

            _gradientLayer.colors = colors
            if locations.isEmpty {
                _gradientLayer.locations = nil
            } else {
                if colors.count != locations.count {
                    AxcUIKitLib.Log("\(self)渐变色视图的颜色与点位数量不符！", logLevel: .warning)
                } else {
                    _gradientLayer.locations = locations.map { $0.axc.number }
                }
            }
        } else {
            _gradientLayer.colors = nil
            _gradientLayer.locations = nil
        }
    }
}
