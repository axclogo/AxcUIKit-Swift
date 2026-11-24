#if canImport(UIKit)
import UIKit

/// 基于 UIButton 的标准按钮组件。
open class AxcButton: UIButton, AxcButtonApi {
    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var buttonTitle: String? {
        return title(for: .normal)
    }

    public func set(title: String?) {
        setTitle(title, for: .normal)
    }
}

#elseif canImport(AppKit)
import AppKit

/// 基于 NSButton 的标准按钮组件。
open class AxcButton: NSButton, AxcButtonApi {
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

    public var buttonTitle: String? {
        return title
    }

    public func set(title: String?) {
        self.title = title ?? ""
    }
}
#endif
