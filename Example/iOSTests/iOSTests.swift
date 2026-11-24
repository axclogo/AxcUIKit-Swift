//
//  iOSTests.swift
//  iOSTests
//
//  Created by 赵新 on 2023/6/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import UIKit
@testable import iOS
import AxcUIKit

final class iOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAxcViewKeepsUIKitBackgroundAndHitTesting() throws {
        let parent = AxcView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let child = UIView(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        parent.addSubview(child)
        parent.set(backgroundColor: UIColor.red)

        XCTAssertEqual(parent.backgroundColor, .red)
        XCTAssertEqual(parent.currentBackgroundColor, .red)
        XCTAssertTrue(parent.hitTest(CGPoint(x: 20, y: 20), with: nil) === child)
    }

    func testStandardComponentsKeepUIKitBehavior() throws {
        let button = AxcButton()
        button.set(title: "确认")

        let image = UIImage()
        let imageView = AxcImageView()
        imageView.set(image: image)

        let stack = AxcStackView()
        let child = UIView()
        stack.addArrangedSubview(child)
        stack.removeArrangedSubviewCompletely(child)

        let scrollView = AxcScrollView(axis: .vertical)

        XCTAssertEqual(button.title(for: .normal), "确认")
        XCTAssertTrue(imageView.image === image)
        XCTAssertNil(child.superview)
        XCTAssertTrue(scrollView.documentContentView.superview === scrollView)
    }

    func testPerformanceExample() throws {
        self.measure {
            for _ in 0 ..< 1_000 {
                _ = AxcView()
            }
        }
    }

}
