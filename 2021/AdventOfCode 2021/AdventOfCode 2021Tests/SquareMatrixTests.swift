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
    
    func testIdentityDotProduct() throws {
        var input = SquareMatrix(size: 3)
        input.update(row: 0, column: 1, to: 5)
        input.update(row: 1, column: 0, to: 3)
        var identity = SquareMatrix(size: 3)
        identity.update(row: 0, column: 0, to: 1)
        identity.update(row: 1, column: 1, to: 1)
        identity.update(row: 2, column: 2, to: 1)
        let output = input * identity
        let expected = input
        XCTAssertEqual(output, expected)
    }
    
    func testWebsiteDotProduct() throws {
        // https://www.mathsisfun.com/algebra/matrix-multiplying.html
        //  1 2  *  2 0  =  4 4
        //  3 4     1 2    10 8
        var left = SquareMatrix(size: 2)
        left.update(row: 0, column: 0, to: 1)
        left.update(row: 0, column: 1, to: 2)
        left.update(row: 1, column: 0, to: 3)
        left.update(row: 1, column: 1, to: 4)
        var right = SquareMatrix(size: 2)
        right.update(row: 0, column: 0, to: 2)
        right.update(row: 0, column: 1, to: 0)
        right.update(row: 1, column: 0, to: 1)
        right.update(row: 1, column: 1, to: 2)
        var expected = SquareMatrix(size: 2)
        expected.update(row: 0, column: 0, to: 4)
        expected.update(row: 0, column: 1, to: 4)
        expected.update(row: 1, column: 0, to: 10)
        expected.update(row: 1, column: 1, to: 8)
        let result = left * right
        XCTAssertEqual(result, expected)
    }
    
}
