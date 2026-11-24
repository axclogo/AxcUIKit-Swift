//
//  macOSTests.swift
//  macOSTests
//
//  Created by 赵新 on 2023/6/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import AppKit
@testable import macOS
import AxcUIKit

final class macOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGradientKeepsLastValidConfiguration() throws {
        let layer = AxcGradientLayer()
        let validColors = [
            AxcGradientLayer.GradientColor(color: NSColor.red, location: 0),
            AxcGradientLayer.GradientColor(color: NSColor.green, location: 1),
        ]
        layer.set(gradientColors: validColors)
        layer.set(gradientColors: [
            AxcGradientLayer.GradientColor(color: NSColor.black, location: 0),
            AxcGradientLayer.GradientColor(color: NSColor.white),
        ])

        XCTAssertEqual(layer.gradientColors?.compactMap(\.location), [0, 1])
    }

    func testStandardComponentsKeepAppKitBehavior() throws {
        let button = AxcButton()
        button.set(title: "确认")

        let stack = AxcStackView()
        let child = NSView()
        stack.addArrangedSubview(child)
        stack.removeArrangedSubviewCompletely(child)

        let scrollView = AxcScrollView(axis: .vertical)

        XCTAssertEqual(button.title, "确认")
        XCTAssertNil(child.superview)
        XCTAssertTrue(scrollView.documentView === scrollView.documentContentView)
        XCTAssertTrue(scrollView.hasVerticalScroller)
    }

    func testPerformanceExample() throws {
        self.measure {
            for _ in 0 ..< 1_000 {
                _ = AxcGradientLayer()
            }
        }
    }

}
