//
//  SquareMatrixTests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/20/21.
//

import XCTest
@testable import AdventOfCode_2021

class SquareMatrixTests: XCTestCase {
    func testPositiveScalarMultiplication() throws {
        var input = SquareMatrix(size: 2)
        input.update(row: 1, column: 1, to: 5)
        var expected = SquareMatrix(size: 2)
        expected.update(row: 1, column: 1, to: 10)
        let result = 2 * input
        XCTAssertEqual(result, expected)
    }
    
    func testNegativeScalarMultiplication() throws {
        var input = SquareMatrix(size: 2)
        input.update(row: 1, column: 1, to: 5)
        var expected = SquareMatrix(size: 2)
        expected.update(row: 1, column: 1, to: -10)
        let result = -2 * input
        XCTAssertEqual(result, expected)
    }
}
