//
//  AxcBubbleView+Api.swift
//  Kingfisher
//
//  Created by 赵新 on 2023/5/31.
//

import AxcBedrock

// MARK: - [AxcBubbleView.ArrowDirection]

public extension AxcBubbleView {
    /// 箭头方向以及偏移量
    enum ArrowDirection {
        /// 上，和水平偏移量
        case top(offsetX: CGFloat)
        /// 上居中
        case topCenter

        /// 左，和垂直偏移量
        case left(offsetY: CGFloat)
        /// 左居中
        case leftCenter

        /// 下，和水平偏移量
        case bottom(offsetX: CGFloat)
        /// 下居中
        case bottomCenter

        /// 右，和垂直偏移量
        case right(offsetY: CGFloat)
        /// 右居中
        case rightCenter
    }
}

// MARK: - [AxcBubbleViewApi]

public protocol AxcBubbleViewApi {
    /// 内容间距
    var contentEdgeInsets: UIEdgeInsets { get }

    /// 内容视图，需要添加的内容可以加在这个视图上
    var contentView: AxcGradientView { get }

    /// 箭头位置
    var arrowDirection: AxcBubbleView.ArrowDirection { get }
    /// 箭头大小
    var arrowSize: CGSize { get }
    /// 箭头圆角半径
    var arrowRadius: CGFloat { get }

    /// 气泡内容间距
    var bubbleContentEdgeInsets: UIEdgeInsets { get }
    /// 气泡圆角组
    var bubbleCorners: AxcCorner { get }
    /// 气泡圆角半径
    var bubbleCornerRadius: CGFloat { get }
}

public extension AxcBubbleViewApi where Self: AxcBubbleView {
    /// 设置内容间距
    /// - Parameter contentEdgeInsets: 内容间距
    func set(contentEdgeInsets: UIEdgeInsets) {
        _set(contentEdgeInsets: contentEdgeInsets)
    }

    /// 设置箭头位置
    /// - Parameter arrowDirection: 箭头位置
    func set(arrowDirection: AxcBubbleView.ArrowDirection) {
        _set(arrowDirection: arrowDirection)
    }

    /// 设置箭头大小
    /// - Parameter arrowSize: 箭头大小
    func set(arrowSize: CGSize) {
        _set(arrowSize: arrowSize)
    }

    /// 设置箭头圆角半径
    /// - Parameter arrowRadius: 箭头圆角半径
    func set(arrowRadius: CGFloat) {
        _set(arrowRadius: arrowRadius)
    }

    /// 设置气泡内容间距
    /// - Parameter bubbleContentEdgeInsets: 气泡内容间距
    func set(bubbleContentEdgeInsets: UIEdgeInsets) {
        _set(bubbleContentEdgeInsets: bubbleContentEdgeInsets)
    }

    /// 设置气泡圆角组
    /// - Parameter bubbleCorners: 气泡圆角组
    func set(bubbleCorners: AxcCorner) {
        _set(bubbleCorners: bubbleCorners)
    }

    /// 设置气泡圆角半径
    /// - Parameter bubbleCornerRadius: 气泡圆角半径
    func set(bubbleCornerRadius: CGFloat) {
        _set(bubbleCornerRadius: bubbleCornerRadius)
    }
}
