import XCTest
@testable import AxcUIKitCore
@testable import AxcUIKitGradient

final class AxcUIKitCoreTests: XCTestCase {
    func testDataChannelOnlyBindsOnce() {
        let layer = TestLayer()

        layer.performDataChannel()
        layer.performDataChannel()

        XCTAssertEqual(layer.bindCount, 1)
    }

    func testGradientRejectsIncompleteLocations() {
        let layer = AxcGradientLayer()
        let validColors = [
            AxcGradientLayer.GradientColor(color: "FF0000", location: 0),
            AxcGradientLayer.GradientColor(color: "00FF00", location: 1)
        ]
        layer.set(gradientColors: validColors)

        layer.set(gradientColors: [
            AxcGradientLayer.GradientColor(color: "000000", location: 0),
            AxcGradientLayer.GradientColor(color: "FFFFFF")
        ])

        XCTAssertEqual(layer.gradientColors?.count, validColors.count)
        XCTAssertEqual(layer.gradientColors?.compactMap(\.location), [0, 1])
    }
}

private final class TestLayer: AxcLayer {
    var bindCount = 0

    override func bindDrive() {
        bindCount += 1
    }
}
