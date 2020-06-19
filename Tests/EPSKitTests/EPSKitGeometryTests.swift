import XCTest
@testable import EPSKit

final class EPSKitGeometryTests: XCTestCase {

    func testBreakingLineIntoSegments() {
        let line = EPS.Line(points: .a, .b, .c)

        XCTAssertEqual(line.segments, [
            EPS.Line(points: .a, .b),
            EPS.Line(points: .b, .c),
        ])
    }

    func testSegmentsByRemovingDuplicateSegments() {
        let sut = EPS.Line.segmentsByRemovingDuplicateSegments

        // Test nothing happens when there are no duplicates
        // (segments are produced)
        let line1 = EPS.Line(points: .a, .b, .c, .d)
        let line2 = EPS.Line(points: .e, .f, .g)
        XCTAssertEqual(sut([line1, line2]), [
            EPS.Line(points: .a, .b),
            EPS.Line(points: .b, .c),
            EPS.Line(points: .c, .d),
            EPS.Line(points: .e, .f),
            EPS.Line(points: .f, .g),
        ])

        // Test duplicates are removed across mulitple lines
        let line3 = EPS.Line(points: .a, .b, .c, .d)
        let line4 = EPS.Line(points: .e, .a, .b, .c, .d)
        XCTAssertEqual(sut([line3, line4]), [
            EPS.Line(points: .a, .b),
            EPS.Line(points: .b, .c),
            EPS.Line(points: .c, .d),
            EPS.Line(points: .e, .a),
        ])

        // Test duplicates are removed in same line
        let line5 = EPS.Line(points: .a, .b, .c, .d, .a, .b, .c, .d)
        XCTAssertEqual(sut([line5]), [
            EPS.Line(points: .a, .b),
            EPS.Line(points: .b, .c),
            EPS.Line(points: .c, .d),
            EPS.Line(points: .d, .a),
        ])
    }

    func testLinesByJoiningSegments() {
        let sut = EPS.Line.linesByJoiningSegments

        // Test joining occurs when all segments align
        XCTAssertEqual(
            sut([
                EPS.Line(points: .a, .b),
                EPS.Line(points: .b, .c),
                EPS.Line(points: .c, .d),
            ]), [
                EPS.Line(points: .a, .b, .c, .d)
            ]
        )

        // Test joining skips segments that do not align
        XCTAssertEqual(
            sut([
                EPS.Line(points: .a, .b),
                EPS.Line(points: .b, .c),
                EPS.Line(points: .c, .d),
                EPS.Line(points: .e, .f),
                EPS.Line(points: .f, .g),
            ]), [
                EPS.Line(points: .a, .b, .c, .d),
                EPS.Line(points: .e, .f, .g)
            ]
        )

        // Test nothing happens when no segments align
        XCTAssertEqual(
            sut([
                EPS.Line(points: .a, .b),
                EPS.Line(points: .c, .d),
                EPS.Line(points: .e, .f),
            ]), [
                EPS.Line(points: .a, .b),
                EPS.Line(points: .c, .d),
                EPS.Line(points: .e, .f),
            ]
        )
    }

    func testTranslating() {
        let line = EPS.Line(points: CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3))
        XCTAssertEqual(
            line.translated(by: CGPoint(x: 10, y: 100)),
            EPS.Line(points: CGPoint(x: 10, y: 101), CGPoint(x: 12, y: 103))
        )
    }

    func testMoving() {
        let line = EPS.Line(points: CGPoint(x: 10, y: 10), CGPoint(x: 100, y: 100))
        XCTAssertEqual(
            line.moved(to: CGPoint(x: 0, y: 10)),
            EPS.Line(points: CGPoint(x: 0, y: 10), CGPoint(x: 90, y: 100))
        )

        let line2 = EPS.Line(points: CGPoint(x: 0, y: 10), CGPoint(x: 100, y: 100))
        XCTAssertEqual(
            line2.moved(to: CGPoint(x: 100, y: 100)),
            EPS.Line(points: CGPoint(x: 100, y: 100), CGPoint(x: 200, y: 190))
        )
    }

    func testRotating() {
        let line = EPS.Line(points: CGPoint(x: 10, y: 10), CGPoint(x: 10, y: 20))

        let rotated90AroundLineCenter = line.rotated(around: CGPoint(x: 10, y: 15), by: 90)
        XCTAssertEqual(rotated90AroundLineCenter.points[0].x, 5)
        XCTAssertEqual(rotated90AroundLineCenter.points[0].y, 15)
        XCTAssertEqual(rotated90AroundLineCenter.points[1].x, 15)
        XCTAssertEqual(rotated90AroundLineCenter.points[1].y, 15)

        let rotated180AroundLineCenter = line.rotated(around: CGPoint(x: 10, y: 15), by: 180)
        XCTAssertEqual(rotated180AroundLineCenter.points[0].x, 10)
        XCTAssertEqual(rotated180AroundLineCenter.points[0].y, 20)
        XCTAssertEqual(rotated180AroundLineCenter.points[1].x, 10)
        XCTAssertEqual(rotated180AroundLineCenter.points[1].y, 10)
    }

    func testBoundary() {
        let line = EPS.Line(points: CGPoint(x: -1, y: -1), CGPoint(x: 1, y: 2), .zero)
        XCTAssertEqual(line.boundary, CGRect(x: -1, y: -1, width: 2, height: 3))
    }

    static var allTests = [
        ("testBreakingLineIntoSegments", testBreakingLineIntoSegments),
        ("testSegmentsByRemovingDuplicateSegments", testSegmentsByRemovingDuplicateSegments),
        ("testLinesByJoiningSegments", testLinesByJoiningSegments),
        ("testTranslating", testTranslating),
    ]

}
