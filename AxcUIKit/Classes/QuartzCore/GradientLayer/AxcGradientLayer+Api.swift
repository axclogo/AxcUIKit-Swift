//
//  AxcGradientLayer+Api.swift
//  AxcKit
//
//  Created by 赵新 on 2022/12/24.
//

import QuartzCore
import AxcBedrock

/// 渐变色的样式枚举
public typealias AxcGradientLayerStyle = AxcGradientLayer.Style

// MARK: - [AxcGradientLayer.Style]

public extension AxcGradientLayer {
    /// 样式
    enum Style {
        /// 轴向
        public enum AxisStyle: Int {
            /// 从上到下
            case topToBottom = 0
            /// 从左到右
            case leftToRight
            /// 从下到上
            case bottomToTop
            /// 从右到左
            case rightToLeft
        }

        /// 斜轴
        public enum AxisTiltStyle: Int {
            /// 从左上到右下
            case topLeftToBottomRight = 0
            /// 从右上到左下
            case topRightToBottomLeft
            /// 从左下到右上
            case bottomLeftToTopRight
            /// 从右下到左上
            case bottomRightToTopLeft
        }

        /// 轴向
        case axis(_ axisStyle: AxisStyle)
        /// 斜轴
        case axisTilt(_ axisTiltStyle: AxisTiltStyle)
        /// 锥形（需要处理收尾相连）
        case conic
        /// 径向/环形
        case radial
    }
}

// MARK: - [AxcGradientLayer.GradientColor]

public extension AxcGradientLayer {
    /// 梯度颜色对象
    struct GradientColor {
        // Lifecycle

        public init(color: AxcUnifiedColor,
                    location: CGFloat? = nil) {
            self.color = color
            self.location = location
        }

        // Public

        /// 颜色
        public var color: AxcUnifiedColor

        /// 每个颜色的渐变结束的点位，元素数量需要
        /// 取值 0 - 1
        /// 例如：
        ///
        ///       梯度颜色设置: [.red, .green]
        ///       3-7分点位应取：[0.3, 0.7]
        ///
        public var location: CGFloat?
    }
}

// MARK: - [AxcGradientLayerApi]

public protocol AxcGradientLayerApi {
    /// 样式
    var gradientStyle: AxcGradientLayer.Style { get }

    /// 梯度颜色组
    var gradientColors: [AxcGradientLayer.GradientColor]? { get }
}

public extension AxcGradientLayerApi where Self: AxcGradientLayer {
    /// 设置渐变样式
    /// - Parameter style: 渐变样式
    func set(gradientStyle: AxcGradientLayer.Style) {
        _set(gradientStyle: gradientStyle)
    }

    /// 设置梯度颜色组
    /// - Parameter gradientColors: 梯度颜色组
    func set(gradientColors: [AxcGradientLayer.GradientColor]?) {
        _set(gradientColors: gradientColors)
    }
}
