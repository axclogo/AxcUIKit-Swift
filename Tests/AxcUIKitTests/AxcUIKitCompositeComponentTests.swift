import XCTest
@testable import AxcUIKitLabel
@testable import AxcUIKitBubble

#if canImport(UIKit)
import UIKit
private typealias PlatformColor = UIColor
private typealias PlatformInsets = UIEdgeInsets
#elseif canImport(AppKit)
import AppKit
private typealias PlatformColor = NSColor
private typealias PlatformInsets = NSEdgeInsets
#endif

final class AxcUIKitCompositeComponentTests: XCTestCase {
    func testLabelForwardsTextAndLayoutConfiguration() {
        let label = AxcLabel(frame: CGRect(x: 0, y: 0, width: 240, height: 100))
        let contentInsets = PlatformInsets(top: 2, left: 3, bottom: 4, right: 5)
        let markInsets = PlatformInsets(top: 1, left: 2, bottom: 3, right: 4)

        label.set(text: "AxcUIKit")
        #if canImport(UIKit)
        label.set(textFont: UIFont.systemFont(ofSize: 16))
        #else
        label.set(textFont: NSFont.systemFont(ofSize: 16))
        #endif
        label.set(textColor: PlatformColor.red)
        label.set(textBackgroundColor: PlatformColor.clear)
        label.set(textAlignment: .center)
        label.set(textLineBreakMode: .byWordWrapping)
        label.set(lineSpacing: 6)
        label.set(contentEdgeInsets: contentInsets)
        label.set(markLineTextEdgeSpacing: markInsets)
        label.set(textPositionHorizontal: .left)
        label.set(textPositionVertical: .top)

        XCTAssertEqual(label.textLabel.attributedText?.string, "AxcUIKit")
        XCTAssertEqual(label.contentEdgeInsets.top, 2)
        XCTAssertEqual(label.markLineTextEdgeSpacing.right, 4)
        guard case .left = label.textPositionHorizontal else {
            return XCTFail("文字应靠左")
        }
        guard case .top = label.textPositionVertical else {
            return XCTFail("文字应靠上")
        }
        XCTAssertGreaterThan(label.intrinsicContentSize.width, label.textLabel.intrinsicContentSize.width)
        XCTAssertGreaterThan(label.intrinsicContentSize.height, label.textLabel.intrinsicContentSize.height)

        label.set(numberOfLineType: .single)
        XCTAssertEqual(label.textLabel.numberOfLines, 1)
        label.set(numberOfLineType: .multiple(lineCount: 3))
        XCTAssertEqual(label.textLabel.numberOfLines, 3)
        label.set(numberOfLineType: .multiple(lineCount: -1))
        XCTAssertEqual(label.textLabel.numberOfLines, 0)
        label.set(numberOfLineType: .infinite)
        XCTAssertEqual(label.textLabel.numberOfLines, 0)

        label.set(textPositionHorizontal: .center)
        label.set(textPositionVertical: .center)
        label.set(textPositionHorizontal: .right)
        label.set(textPositionVertical: .bottom)
        #if canImport(UIKit)
        let fitted = label.sizeThatFits(CGSize(width: 120, height: 80))
        XCTAssertGreaterThan(fitted.width, 0)
        XCTAssertGreaterThan(fitted.height, 0)
        #endif
    }

    func testLabelDrawsSolidAndDottedDecorations() {
        let label = AxcLabel(frame: CGRect(x: 0, y: 0, width: 240, height: 100))
        label.set(text: "Decoration")
        label.set(textBorderColor: PlatformColor.blue)
        label.set(textBorderWidth: 2)
        label.set(textBorderLineJoin: .bevel)
        label.set(textBorderStyle: .dotted(phase: 1, lengths: [2, 3]))
        label.set(markLines: [
            .init(edgePosition: .top(axis: .horizontal(position: .top)), color: .red, cap: .butt),
            .init(edgePosition: .left(axis: .vertical(position: .left)), color: .green, style: .dotted(phase: 0, lengths: [1, 1])),
            .init(edgePosition: .bottom(axis: .horizontal(position: .bottom)), color: .blue, cap: .square),
            .init(edgePosition: .right(axis: .vertical(position: .right)), color: .black),
            .init(edgePosition: .top(axis: .horizontal(position: .center)), color: .clear, width: 0, style: .none),
        ])

        #if canImport(UIKit)
        label.layoutIfNeeded()
        #else
        label.layoutSubtreeIfNeeded()
        #endif
        label.axc_layoutSubviews()

        XCTAssertEqual(label.textBorderStyle, .dotted(phase: 1, lengths: [2, 3]))
        XCTAssertEqual(label.textBorderWidth, 2)
        XCTAssertEqual(label.textBorderLineJoin, .bevel)
        XCTAssertEqual(label.markLines?.count, 5)
        XCTAssertGreaterThanOrEqual(label.currentLayer?.sublayers?.count ?? 0, 5)

        label.set(textBorderStyle: .solid)
        label.set(textBorderLineJoin: .miter)
        label.axc_layoutSubviews()
        XCTAssertEqual(label.textBorderStyle, .solid)
        XCTAssertEqual(label.textBorderLineJoin, .miter)

        label.set(textBorderStyle: .none)
        label.set(textBorderLineJoin: .round)
        label.set(markLines: nil)
        label.axc_layoutSubviews()
        XCTAssertNil(label.markLines)
    }

    func testBubbleUpdatesEveryArrowDirectionAndMask() {
        let bubble = AxcBubbleView(frame: CGRect(x: 0, y: 0, width: 200, height: 120))
        bubble.set(contentEdgeInsets: PlatformInsets(top: 2, left: 3, bottom: 4, right: 5))
        bubble.set(bubbleContentEdgeInsets: PlatformInsets(top: 6, left: 7, bottom: 8, right: 9))
        bubble.set(arrowSize: CGSize(width: 12, height: 18))
        bubble.set(arrowRadius: 3)
        bubble.set(bubbleCornerRadius: 8)
        bubble.set(bubbleCorners: .all)

        let directions: [AxcBubbleView.ArrowDirection] = [
            .top(offsetX: -100), .topCenter,
            .left(offsetY: -100), .leftCenter,
            .bottom(offsetX: 500), .bottomCenter,
            .right(offsetY: 500), .rightCenter,
        ]

        for direction in directions {
            bubble.set(arrowDirection: direction)
            bubble.axc_layoutSubviews()
            XCTAssertNotNil(bubble.currentLayer?.mask)
            XCTAssertNotNil(bubble._shapeLayer.path)
            XCTAssertEqual(bubble._shapeLayer.frame, bubble.bounds)
        }

        XCTAssertTrue(bubble.contentView.superview === bubble)
        XCTAssertEqual(bubble.arrowSize, CGSize(width: 12, height: 18))
        XCTAssertEqual(bubble.arrowRadius, 3)
        XCTAssertEqual(bubble.bubbleCornerRadius, 8)
        XCTAssertEqual(bubble.bubbleContentEdgeInsets.left, 7)
    }

    func testBubbleHandlesEmptyAndVerySmallBounds() {
        let bubble = AxcBubbleView(frame: .zero)
        bubble._updateMaskLayer()
        XCTAssertNil(bubble._shapeLayer.path)

        bubble.bounds = CGRect(x: 0, y: 0, width: 2, height: 2)
        bubble.set(contentEdgeInsets: PlatformInsets(top: 10, left: 10, bottom: 10, right: 10))
        bubble.set(arrowSize: CGSize(width: 20, height: 20))
        bubble.set(arrowDirection: .right(offsetY: 100))
        bubble._updateMaskLayer()
        XCTAssertNotNil(bubble._shapeLayer.path)
    }
}
