import XCTest

import EPSKitTests

var tests = [XCTestCaseEntry]()
tests += EPSKitTests.allTests()
tests += EPSKitGeometryTests.allTests()
XCTMain(tests)
