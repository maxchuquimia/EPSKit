import XCTest
@testable import EPSKit

final class EPSKitTests: XCTestCase {

    var sut: EPS.Board!

    override func setUp() {
        super.setUp()
        sut = EPS.Board(configuration: EPS.Configuration(precision: .integer, header: ""))
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testHeader() {
        let sut = EPS.Board(configuration: EPS.Configuration(precision: .integer, header: "HEADER"))
        XCTAssertEqual(sut.contents, "HEADER\r\n")
    }

    func testIntegerPrecision() {
        let sut = EPS.Board(configuration: EPS.Configuration(precision: .integer, header: ""))
        sut.move(to: .zero)
        XCTAssertEqual(sut.contents, "0 0 moveto\r\n")
    }

    func testDecimalPrecision() {
        let sut1 = EPS.Board(configuration: EPS.Configuration(precision: .decimalPlaces(1), header: ""))
        sut1.move(to: .zero)
        XCTAssertEqual(sut1.contents, "0.0 0.0 moveto\r\n")

        let sut2 = EPS.Board(configuration: EPS.Configuration(precision: .decimalPlaces(2), header: ""))
        sut2.move(to: .zero)
        XCTAssertEqual(sut2.contents, "0.00 0.00 moveto\r\n")

        let sut3 = EPS.Board(configuration: EPS.Configuration(precision: .decimalPlaces(3), header: ""))
        sut3.move(to: .zero)
        XCTAssertEqual(sut3.contents, "0.000 0.000 moveto\r\n")
    }

    func testCustomPrecision() {
        let sut = EPS.Board(configuration: EPS.Configuration(precision: .custom({ _ in "TEST" }), header: ""))
        sut.move(to: .zero)
        XCTAssertEqual(sut.contents, "TEST TEST moveto\r\n")
    }

    func testCustomPrecisionClosureIsCalledForEachValue() {
        let xExpectation = expectation(description: "Value for x is processed")
        let yExpectation = expectation(description: "Value for y is processed")

        xExpectation.assertForOverFulfill = true
        yExpectation.assertForOverFulfill = true

        let closure: (CGFloat) -> String = { value -> String in
            if value == 1.0 {
                xExpectation.fulfill()
            } else if value == 2.0 {
                yExpectation.fulfill()
            } else {
                XCTFail("Unexpected value \(value)")
            }

            return "-"
        }

        let sut = EPS.Board(configuration: EPS.Configuration(precision: .custom(closure), header: ""))
        sut.move(to: CGPoint(x: 1, y: 2))

        wait(for: [xExpectation, yExpectation], timeout: 0.1, enforceOrder: true)
    }

    func testScale() {
        sut.scale(by: .zero)
        XCTAssertEqual(sut.contents, "0 0 scale\r\n")
    }

    func testTranslate() {
        sut.translate(by: .zero)
        XCTAssertEqual(sut.contents, "0 0 translate\r\n")
    }

    func testSetLineWidth() {
        sut.set(lineWidth: 0)
        XCTAssertEqual(sut.contents, "0 setlinewidth\r\n")
    }

    func testMove() {
        sut.move(to: .zero)
        XCTAssertEqual(sut.contents, "0 0 moveto\r\n")
    }

    func testLine() {
        sut.line(to: .zero)
        XCTAssertEqual(sut.contents, "0 0 lineto\r\n")
    }

    func testArc() {
        sut.arc(around: .zero, radius: 3, start: 10, end: 20)
        XCTAssertEqual(sut.contents, "0 0 3 10 20 arc\r\n")
    }

    func testSetColor() {
        sut.set(color: 1, 2, 3)
        XCTAssertEqual(sut.contents, "1 2 3 setrgbcolor\r\n")
    }

    func testFill() {
        sut.fill()
        XCTAssertEqual(sut.contents, "fill\r\n")
    }

    func testStroke() {
        sut.stroke()
        XCTAssertEqual(sut.contents, "stroke\r\n")
    }

    func testDrawLine() {
        sut.draw(line: EPS.Line(points: .zero, CGPoint(x: 1, y: 1), CGPoint(x: 2, y: 2)))
        XCTAssertEqual(sut.contents, "0 0 moveto 1 1 lineto 2 2 lineto\r\n")
    }

    func testDrawCircle() {
        sut.draw(circle: EPS.Circle(center: .zero, radius: 10))
        XCTAssertEqual(sut.contents, "10 0 moveto 0 0 10 0 360 arc\r\n")
    }

    static var allTests = [
        ("testHeader", testHeader),
        ("testIntegerPrecision", testIntegerPrecision),
        ("testDecimalPrecision", testDecimalPrecision),
        ("testCustomPrecision", testCustomPrecision),
        ("testCustomPrecisionClosureIsCalledForEachValue", testCustomPrecisionClosureIsCalledForEachValue),
        ("testScale", testScale),
        ("testTranslate", testTranslate),
        ("testSetLineWidth", testSetLineWidth),
        ("testMove", testMove),
        ("testLine", testLine),
        ("testArc", testArc),
        ("testSetColor", testSetColor),
        ("testFill", testFill),
        ("testStroke", testStroke),
        ("testDrawLine", testDrawLine),
        ("testDrawCircle", testDrawCircle),
    ]
}
