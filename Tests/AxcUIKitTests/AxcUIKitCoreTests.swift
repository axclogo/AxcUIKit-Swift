import XCTest
import QuartzCore
@testable import AxcUIKitCore
@testable import AxcUIKitGradient

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class AxcUIKitCoreTests: XCTestCase {
    func testLayerLifecycleAndDataChannelOnlyRunOnce() {
        let target = BasicTarget()

        target.performBasic()
        target.performDataChannel()
        target.performDataChannel()

        XCTAssertEqual(target.configCount, 1)
        XCTAssertEqual(target.makeUICount, 1)
        XCTAssertEqual(target.dataWillLoadCount, 1)
        XCTAssertEqual(target.bindViewActionCount, 1)
        XCTAssertEqual(target.bindViewModelCount, 1)
        XCTAssertEqual(target.bindNoticeCount, 1)
        XCTAssertEqual(target.bindDriveCount, 1)

        let layer = AxcLayer()
        XCTAssertNotNil(layer.backgroundColor)
    }

    func testViewBackgroundConstraintsAndCallbacks() {
        let view = AxcView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        view.set(backgroundColor: "FF0000")

        XCTAssertNotNil(view.currentBackgroundColor)
        XCTAssertNotNil(view.currentLayer)
        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(view.isLayoutFixedSize())

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 100),
            view.heightAnchor.constraint(equalToConstant: 80),
        ])
        XCTAssertTrue(view.isLayoutFixedWidth())
        XCTAssertTrue(view.isLayoutFixedHeight())
        XCTAssertTrue(view.isLayoutFixedSize())

        var layoutCount = 0
        var hitTestCount = 0
        #if canImport(UIKit)
        _ = view.hitTest(CGPoint(x: 1, y: 1), with: nil)
        _ = view.point(inside: CGPoint(x: 1, y: 1), with: nil)
        #else
        _ = view.hitTest(NSPoint(x: 1, y: 1))
        #endif
        view.callback.layoutSubviews { layoutCount += 1 }
        #if canImport(UIKit)
        view.callback.hitTest { testedView, _, _, _ in
            hitTestCount += 1
            return testedView
        }
        view.callback.pointInside { _, _, _, _ in false }
        XCTAssertTrue(view.hitTest(CGPoint(x: 1, y: 1), with: nil) === view)
        XCTAssertFalse(view.point(inside: CGPoint(x: 1, y: 1), with: nil))
        #else
        view.callback.hitTest { testedView, _, _ in
            hitTestCount += 1
            return testedView
        }
        XCTAssertTrue(view.hitTest(NSPoint(x: 1, y: 1)) === view)
        #endif
        view.axc_layoutSubviews()

        XCTAssertEqual(layoutCount, 1)
        XCTAssertEqual(hitTestCount, 1)
    }

    func testViewControllerLifecycleAndRootViewAPI() {
        let controller = LifecycleViewController()
        _ = controller.view

        XCTAssertEqual(controller.configCount, 1)
        XCTAssertEqual(controller.makeUICount, 1)
        XCTAssertEqual(controller.bindCount, 1)
        #if canImport(AppKit)
        XCTAssertNotNil(controller.axcView)
        #endif

        controller.setView(backgroundColor: "00FF00")
        XCTAssertNotNil(controller.viewBackgroundColor)

        let child = AxcView()
        controller.addSubview(child)
        XCTAssertTrue(child.superview === controller.view)

        controller.performDataChannel()
        XCTAssertEqual(controller.bindCount, 1)
    }

    func testLibraryMetadata() {
        let library = AxcUIKitLib()
        XCTAssertEqual(library.moduleName, "AxcUIKit")
        XCTAssertEqual(library.moduleEmoji, "🧱")
    }

    func testGradientSupportsEveryStyleAndLayout() {
        let layer = AxcGradientLayer()
        let cases: [(AxcGradientLayer.Style, CGPoint, CGPoint, CAGradientLayerType)] = [
            (.axis(.topToBottom), CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1), .axial),
            (.axis(.leftToRight), CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), .axial),
            (.axis(.bottomToTop), CGPoint(x: 0.5, y: 1), CGPoint(x: 0.5, y: 0), .axial),
            (.axis(.rightToLeft), CGPoint(x: 1, y: 0.5), CGPoint(x: 0, y: 0.5), .axial),
            (.axisTilt(.topLeftToBottomRight), .zero, CGPoint(x: 1, y: 1), .axial),
            (.axisTilt(.topRightToBottomLeft), CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1), .axial),
            (.axisTilt(.bottomLeftToTopRight), CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0), .axial),
            (.axisTilt(.bottomRightToTopLeft), CGPoint(x: 1, y: 1), .zero, .axial),
            (.conic, CGPoint(x: 0.5, y: 0.5), CGPoint(x: 0.5, y: 0), .conic),
            (.radial, CGPoint(x: 0.5, y: 0.5), CGPoint(x: 1, y: 1), .radial),
        ]

        for item in cases {
            layer.set(gradientStyle: item.0)
            XCTAssertEqual(layer._gradientLayer.startPoint, item.1)
            XCTAssertEqual(layer._gradientLayer.endPoint, item.2)
            XCTAssertEqual(layer._gradientLayer.type, item.3)
        }

        layer.bounds = CGRect(x: 0, y: 0, width: 120, height: 60)
        layer.layoutSublayers()
        XCTAssertEqual(layer._gradientLayer.frame, layer.bounds)
    }

    func testGradientAcceptsValidColorsAndKeepsLastValidConfiguration() {
        let layer = AxcGradientLayer()
        let validColors = [
            AxcGradientLayer.GradientColor(color: "FF0000", location: 0),
            AxcGradientLayer.GradientColor(color: "00FF00", location: 1),
        ]
        layer.set(gradientColors: validColors)

        XCTAssertEqual(layer.gradientColors?.count, 2)
        XCTAssertEqual(layer._gradientLayer.locations?.map(\.doubleValue), [0, 1])

        layer.set(gradientColors: [
            AxcGradientLayer.GradientColor(color: "000000", location: 1),
            AxcGradientLayer.GradientColor(color: "FFFFFF", location: 0),
        ])
        layer.set(gradientColors: [
            AxcGradientLayer.GradientColor(color: "000000", location: -0.1),
            AxcGradientLayer.GradientColor(color: "FFFFFF", location: 1.1),
        ])
        layer.set(gradientColors: [
            AxcGradientLayer.GradientColor(color: "000000", location: 0),
            AxcGradientLayer.GradientColor(color: "FFFFFF"),
        ])
        layer.set(gradientColors: [
            AxcGradientLayer.GradientColor(color: "这不是颜色", location: 0),
            AxcGradientLayer.GradientColor(color: "FFFFFF", location: 1),
        ])

        XCTAssertEqual(layer.gradientColors?.compactMap(\.location), [0, 1])

        layer.set(gradientColors: [
            AxcGradientLayer.GradientColor(color: "000000"),
            AxcGradientLayer.GradientColor(color: "FFFFFF"),
        ])
        XCTAssertNil(layer._gradientLayer.locations)

        layer.set(gradientColors: nil)
        XCTAssertNil(layer.gradientColors)
        XCTAssertNil(layer._gradientLayer.colors)
    }

    func testGradientLayerCopyAndGradientViewForwarding() {
        let source = AxcGradientLayer()
        source.set(gradientStyle: .axis(.rightToLeft))
        source.set(gradientColors: [
            .init(color: "112233", location: 0),
            .init(color: "445566", location: 1),
        ])
        let copy = AxcGradientLayer(layer: source)
        _ = AxcLayer(layer: source)

        XCTAssertEqual(copy.gradientColors?.count, 2)
        XCTAssertEqual(copy._gradientLayer.startPoint, CGPoint(x: 1, y: 0.5))

        let view = AxcGradientView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        view.set(gradientStyle: .radial)
        view.set(gradientColors: source.gradientColors)
        XCTAssertTrue(view.currentLayer is AxcGradientLayer)
        XCTAssertEqual(view.gradientColors?.count, 2)
        XCTAssertEqual(view._gradientLayer.type, .radial)
        view.set(gradientColors: nil)
        XCTAssertNil(view.gradientColors)
    }
}

private final class BasicTarget: NSObject, AxcUIBasicFuncTarget {
    var configCount = 0
    var makeUICount = 0
    var dataWillLoadCount = 0
    var bindViewActionCount = 0
    var bindViewModelCount = 0
    var bindNoticeCount = 0
    var bindDriveCount = 0

    func config() { configCount += 1 }
    func makeUI() { makeUICount += 1 }
    func dataWillLoad() { dataWillLoadCount += 1 }
    func bindViewAction() { bindViewActionCount += 1 }
    func bindViewModel() { bindViewModelCount += 1 }
    func bindNotice() { bindNoticeCount += 1 }
    func bindDrive() { bindDriveCount += 1 }
}

private final class LifecycleViewController: AxcViewController {
    var configCount = 0
    var makeUICount = 0
    var bindCount = 0

    override func config() { configCount += 1 }
    override func makeUI() { makeUICount += 1 }
    override func bindDrive() { bindCount += 1 }
}
