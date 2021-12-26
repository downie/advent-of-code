//
//  Challenge17Tests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/26/21.
//

import XCTest
@testable import AdventOfCode_2021

class Challenge17Tests: XCTestCase {

    func testPointInsideRange() throws {
        let test = Point(x: 4, y: 4)
        let topLeft = Point(x: 2, y: 10)
        let bottomRight = Point(x: 10, y: 2)
        let result = BallisticSolver.isPoint(test, between: topLeft, and: bottomRight)
        XCTAssertTrue(result)
    }
    
    func testPointOutsideRange() throws {
        let test = Point(x: 0, y: 0)
        let topLeft = Point(x: 2, y: 10)
        let bottomRight = Point(x: 10, y: 2)
        XCTAssertFalse(BallisticSolver.isPoint(test, between: topLeft, and: bottomRight))
    }
}
