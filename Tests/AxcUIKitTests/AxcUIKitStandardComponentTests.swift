import XCTest
@testable import AxcUIKitButton
@testable import AxcUIKitImage
@testable import AxcUIKitScroll
@testable import AxcUIKitStack

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class AxcUIKitStandardComponentTests: XCTestCase {
    func testButtonUsesSystemTitle() {
        let button = AxcButton()

        button.set(title: "确认")

        XCTAssertEqual(button.buttonTitle, "确认")
        XCTAssertFalse(button.translatesAutoresizingMaskIntoConstraints)

        button.set(title: nil)
        #if canImport(AppKit)
        XCTAssertEqual(button.buttonTitle, "")
        #else
        XCTAssertNil(button.buttonTitle)
        #endif
    }

    func testImageViewUsesSystemImage() {
        #if canImport(UIKit)
        let image = UIImage()
        #else
        let image = NSImage(size: NSSize(width: 1, height: 1))
        #endif
        let imageView = AxcImageView()

        imageView.set(image: image)

        XCTAssertTrue(imageView.currentImage === image)
        XCTAssertFalse(imageView.translatesAutoresizingMaskIntoConstraints)

        imageView.set(image: nil)
        XCTAssertNil(imageView.currentImage)
    }

    func testStackRemovesArrangedSubviewAndHierarchy() {
        let stack = AxcStackView()
        #if canImport(UIKit)
        let child = UIView()
        stack.set(axis: .vertical)
        #else
        let child = NSView()
        stack.set(axis: .vertical)
        #endif
        stack.addArrangedSubview(child)

        stack.removeArrangedSubviewCompletely(child)

        XCTAssertEqual(stack.stackAxis, .vertical)
        XCTAssertFalse(stack.arrangedSubviews.contains(child))
        XCTAssertNil(child.superview)

        stack.set(axis: .horizontal)
        XCTAssertEqual(stack.stackAxis, .horizontal)
    }

    func testScrollViewSwitchesDynamicAxis() {
        let scrollView = AxcScrollView(axis: .vertical)

        XCTAssertEqual(scrollView.scrollAxis, .vertical)
        #if canImport(AppKit)
        XCTAssertTrue(scrollView.documentView === scrollView.documentContentView)
        XCTAssertTrue(scrollView.hasVerticalScroller)
        XCTAssertFalse(scrollView.hasHorizontalScroller)
        #else
        XCTAssertTrue(scrollView.documentContentView.superview === scrollView)
        #endif

        scrollView.set(axis: .horizontal)

        XCTAssertEqual(scrollView.scrollAxis, .horizontal)
        #if canImport(AppKit)
        XCTAssertFalse(scrollView.hasVerticalScroller)
        XCTAssertTrue(scrollView.hasHorizontalScroller)
        #endif

        scrollView.set(axis: .both)
        XCTAssertEqual(scrollView.scrollAxis, .both)
        #if canImport(AppKit)
        XCTAssertTrue(scrollView.hasVerticalScroller)
        XCTAssertTrue(scrollView.hasHorizontalScroller)
        #endif
    }
}
