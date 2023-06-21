//
//  AxcKitGradientView.swift
//  YPWatermarkCamera
//
//  Created by 赵新 on 2022/6/22.
//

// MARK: - AxcGradientView + AxcGradientViewApi

extension AxcGradientView: AxcGradientViewApi { }
public extension AxcGradientView {
    var gradientStyle: AxcGradientLayer.Style {
        return _gradientLayer.gradientStyle
    }

    var gradientColors: [AxcGradientLayer.GradientColor]? {
        return _gradientLayer.gradientColors
    }
}

extension AxcGradientView {
    func _set(gradientStyle: AxcGradientLayer.Style) {
        _gradientLayer.set(gradientStyle: gradientStyle)
    }

    func _set(gradientColors: [AxcGradientLayer.GradientColor]?) {
        _gradientLayer.set(gradientColors: gradientColors)
    }
}

// MARK: - [AxcGradientView]

/// 渐变视图`
open class AxcGradientView: AxcView {
    open override class var layerClass: AnyClass {
        return AxcGradientLayer.self
    }

    var _gradientLayer: AxcGradientLayer {
        return layer as! AxcGradientLayer
    }
}
