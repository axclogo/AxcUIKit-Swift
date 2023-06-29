//
//  AxcGradientView+Api.swift
//  AxcKit
//
//  Created by 赵新 on 2022/12/26.
//

// MARK: - [AxcGradientViewApi]

public protocol AxcGradientViewApi: AxcGradientLayerApi { }

public extension AxcGradientLayerApi where Self: AxcGradientView {
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

/*
 虽然继承自LayerApi接口协议，但是并没有将方法直接声明到Layer协议中
 主要原因有下：
 1、统一所有类的规范写法
 2、协议中直接声明方法不能带有参数默认值
 3、通过针对性扩展来实现参数默认值
 4、方法参数读写分离，读接口完全复用，写接口框架开发者可以自行定制
 */
