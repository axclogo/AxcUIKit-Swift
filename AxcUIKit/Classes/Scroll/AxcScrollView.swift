#if canImport(AxcUIKitCore)
import AxcUIKitCore
#endif

/// 滚动方向。单向滚动会自动约束内容视图的交叉轴尺寸。
public enum AxcScrollAxis: Equatable {
    case vertical
    case horizontal
    case both
}

#if canImport(UIKit)
import UIKit

/// 带动态内容容器的 UIScrollView。
open class AxcScrollView: UIScrollView, AxcScrollViewApi {
    /// 供业务内容使用的 Auto Layout 容器。
    public let documentContentView = AxcView()
    /// 当前允许滚动的轴向。
    public private(set) var scrollAxis: AxcScrollAxis = .vertical

    private var axisConstraints: [NSLayoutConstraint] = []

    public convenience init(axis: AxcScrollAxis = .vertical) {
        self.init(frame: .zero)
        set(axis: axis)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
    }

    public func set(axis: AxcScrollAxis) {
        scrollAxis = axis
        NSLayoutConstraint.deactivate(axisConstraints)
        switch axis {
        case .vertical:
            axisConstraints = [documentContentView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor)]
        case .horizontal:
            axisConstraints = [documentContentView.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor)]
        case .both:
            axisConstraints = []
        }
        NSLayoutConstraint.activate(axisConstraints)
    }

    private func configureContentView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(documentContentView)
        NSLayoutConstraint.activate([
            documentContentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            documentContentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            documentContentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            documentContentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
        ])
        set(axis: scrollAxis)
    }
}

#elseif canImport(AppKit)
import AppKit

/// 带动态内容容器的 NSScrollView。
open class AxcScrollView: NSScrollView, AxcScrollViewApi {
    /// 供业务内容使用的 Auto Layout 容器。
    public let documentContentView = AxcView()
    /// 当前允许滚动的轴向。
    public private(set) var scrollAxis: AxcScrollAxis = .vertical

    private var axisConstraints: [NSLayoutConstraint] = []

    public convenience init(axis: AxcScrollAxis = .vertical) {
        self.init(frame: .zero)
        set(axis: axis)
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configureContentView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
    }

    public func set(axis: AxcScrollAxis) {
        scrollAxis = axis
        NSLayoutConstraint.deactivate(axisConstraints)
        switch axis {
        case .vertical:
            hasVerticalScroller = true
            hasHorizontalScroller = false
            axisConstraints = [documentContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor)]
        case .horizontal:
            hasVerticalScroller = false
            hasHorizontalScroller = true
            axisConstraints = [documentContentView.heightAnchor.constraint(equalTo: contentView.heightAnchor)]
        case .both:
            hasVerticalScroller = true
            hasHorizontalScroller = true
            axisConstraints = []
        }
        NSLayoutConstraint.activate(axisConstraints)
    }

    private func configureContentView() {
        translatesAutoresizingMaskIntoConstraints = false
        documentView = documentContentView
        NSLayoutConstraint.activate([
            documentContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            documentContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
        set(axis: scrollAxis)
    }
}
#endif
