import XCTest
@testable import PracticalDynamicTypePart2

class PracticalDynamicTypePart2Tests: XCTestCase {

    var subject: Hal9000!

    override func setUp() {
        super.setUp()
        subject = Hal9000()
    }

    func testDynamicType() {
        /// pointSize = 31
        FontMetrics.default.sizeCategory = .extraSmall
        let smallSize = subject.dialog.font.pointSize

        /// pointSize = 36
        FontMetrics.default.sizeCategory = .large
        let defaultSize = subject.dialog.font.pointSize

        /// pointSize = 101
        FontMetrics.default.sizeCategory = .accessibilityExtraExtraExtraLarge
        let xxxlSize = subject.dialog.font.pointSize

        XCTAssertGreaterThan(defaultSize, smallSize)
        XCTAssertGreaterThan(xxxlSize, defaultSize)

    }
}
