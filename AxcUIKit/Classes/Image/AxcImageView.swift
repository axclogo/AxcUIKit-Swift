#if canImport(UIKit)
import UIKit

/// 当前平台的系统图片类型。
public typealias AxcSystemImage = UIImage

/// 基于 UIImageView 的标准图片组件。
open class AxcImageView: UIImageView, AxcImageViewApi {
    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var currentImage: AxcSystemImage? {
        return image
    }

    public func set(image: AxcSystemImage?) {
        self.image = image
    }
}

#elseif canImport(AppKit)
import AppKit

/// 当前平台的系统图片类型。
public typealias AxcSystemImage = NSImage

/// 基于 NSImageView 的标准图片组件。
open class AxcImageView: NSImageView, AxcImageViewApi {
    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        translatesAutoresizingMaskIntoConstraints = false
        imageScaling = .scaleProportionallyUpOrDown
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public var currentImage: AxcSystemImage? {
        return image
    }

    public func set(image: AxcSystemImage?) {
        self.image = image
    }
}
#endif
