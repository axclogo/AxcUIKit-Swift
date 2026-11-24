//
//  AxcGradientLayer.swift
//  AxcKit
//
//  Created by 赵新 on 2022/12/24.
//

import QuartzCore
#if canImport(AxcBedrock)
import AxcBedrock
#else
import AxcBedrockCore
#endif
#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif

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
        guard _setGradientColorsParams(gradientColors) else { return }
        _gradientColors = gradientColors
    }
}

// MARK: - [AxcGradientLayer]

open class AxcGradientLayer: AxcLayer {
    public override init() {
        super.init()
    }

    public override init(layer: Any) {
        super.init(layer: layer)
        guard let source = layer as? AxcGradientLayer else { return }
        _gradientStyle = source._gradientStyle
        _gradientColors = source._gradientColors
        if let copiedLayer = sublayers?.compactMap({ $0 as? CAGradientLayer }).first {
            _gradientLayer = copiedLayer
        }
        _set(gradientStyle: _gradientStyle)
        _ = _setGradientColorsParams(_gradientColors)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func layoutSublayers() {
        super.layoutSublayers()
        _gradientLayer.frame = bounds
    }

    /// 创建UI的方法放在这里
    /// 最好按照，从上至下，从左至右依次添加视图
    open override func makeUI() {
        super.makeUI()
        addSublayer(_gradientLayer)
        _set(gradientStyle: _gradientStyle)
        _ = _setGradientColorsParams(_gradientColors)
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
    @discardableResult
    func _setGradientColorsParams(_ gradientColors: [GradientColor]?) -> Bool {
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

            guard colors.count == gradientColors.count else {
                AxcUIKitLib.Log("\(self)渐变色中包含无法转换的颜色！", logLevel: .warning)
                return false
            }

            if locations.isEmpty {
                _gradientLayer.colors = colors
                _gradientLayer.locations = nil
            } else {
                let locationsAreOrdered = zip(locations, locations.dropFirst()).allSatisfy { $0.0 <= $0.1 }
                let locationsAreValid = locations.allSatisfy { (0 ... 1).contains($0) }
                if colors.count != locations.count || !locationsAreOrdered || !locationsAreValid {
                    AxcUIKitLib.Log("\(self)渐变点位需与颜色一一对应，并按 0 到 1 递增排列！", logLevel: .warning)
                    return false
                } else {
                    _gradientLayer.colors = colors
                    _gradientLayer.locations = locations.map { $0.axc.number }
                }
            }
        } else {
            _gradientLayer.colors = nil
            _gradientLayer.locations = nil
        }
        return true
    }
}
