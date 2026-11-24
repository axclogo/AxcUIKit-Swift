#if canImport(UIKit)
import UIKit

/// 当前平台的堆叠轴向类型。
public typealias AxcStackAxis = NSLayoutConstraint.Axis
/// 当前平台可加入堆叠布局的视图类型。
public typealias AxcStackArrangedView = UIView

/// 基于 UIStackView 的标准堆叠布局组件。
open class AxcStackView: UIStackView, AxcStackViewApi {
    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var stackAxis: AxcStackAxis {
        return axis
    }

    public func set(axis: AxcStackAxis) {
        self.axis = axis
    }

    public func removeArrangedSubviewCompletely(_ view: AxcStackArrangedView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
}

#elseif canImport(AppKit)
import AppKit

/// 当前平台的堆叠轴向类型。
public typealias AxcStackAxis = NSUserInterfaceLayoutOrientation
/// 当前平台可加入堆叠布局的视图类型。
public typealias AxcStackArrangedView = NSView

/// 基于 NSStackView 的标准堆叠布局组件。
open class AxcStackView: NSStackView, AxcStackViewApi {
    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var stackAxis: AxcStackAxis {
        return orientation
    }

    public func set(axis: AxcStackAxis) {
        orientation = axis
    }

    public func removeArrangedSubviewCompletely(_ view: AxcStackArrangedView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
}
#endif
