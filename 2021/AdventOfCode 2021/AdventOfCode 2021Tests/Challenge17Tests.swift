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
    
    // MARK: Trajectory tests
    
    func testShallowArcTrjectory() throws {
        let velocity = Point(x: 9, y: 0)
        let result = BallisticSolver.trajectory(from: .zero, initialVelocity: velocity, before: Point(x: 30, y: -10))
        let expected = [
            Point(x: 9, y: 0),
            Point(x: 17, y: -1),
            Point(x: 24, y: -3),
            Point(x: 30, y: -6)
        ]
        XCTAssertEqual(result, expected)
    }
    
    // MARK: - Velocity Tests
    
    func testValidHorizontalVelocitiesForDemoInput() throws {
        let topLeft = Point(x: 20, y: -5)
        let bottomRight = Point(x: 30, y: -10)
        let expected = [6, 7, 9]
        let result = BallisticSolver.validXVelicities(topLeft: topLeft, bottomRight: bottomRight)
        XCTAssertEqual(result, expected)
    }
}
