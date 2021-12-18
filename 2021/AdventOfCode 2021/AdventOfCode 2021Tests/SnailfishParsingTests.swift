//
//  SnailfishNumberTests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/18/21.
//

import XCTest
@testable import AdventOfCode_2021

// MARK: - Parsing
class SnailfishParsingTests: XCTestCase {
    
    func testParsingSimplePair() throws {
        let result = SnailfishNumber.from(string: "[1,2]")
        let expected = SnailfishNumber.pair(left: .value(1), right: .value(2))
        XCTAssertEqual(result, expected)
    }
    
    func testParsingLeftNestedPair() throws {
        let result = SnailfishNumber.from(string: "[[1,2],3]")
        let expected = SnailfishNumber.pair(left: .pair(left: .value(1), right: .value(2)), right: .value(3))
        XCTAssertEqual(result, expected)
    }
    
    func testParsingRightNestedPair() throws {
        let result = SnailfishNumber.from(string: "[9,[8,7]]")
        let expected = SnailfishNumber.pair(left: .value(9), right: .pair(left: .value(8), right: .value(7)))
        XCTAssertEqual(result, expected)
    }
    
    func testParsingComplexNestedPair() throws {
        //[
        //    [
        //        [
        //            [1,3],
        //            [5,3]
        //        ],
        //        [
        //            [1,3],
        //            [8,7]
        //        ]
        //    ],
        //    [
        //        [
        //            [4,9],
        //            [6,9]
        //        ],
        //        [
        //            [8,2],
        //            [7,3]
        //        ]
        //    ]
        //]
        let result = SnailfishNumber.from(string: "[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]")
        let expected = SnailfishNumber.pair(
            left: .pair(
                left: .pair(
                    left: .pair(left: .value(1), right: .value(3)),
                    right: .pair(left: .value(5), right: .value(3))
                ),
                right: .pair(
                    left: .pair(left: .value(1), right: .value(3)),
                    right: .pair(left: .value(8), right: .value(7))
                )
            ),
            right: .pair(
                left: .pair(
                    left: .pair(left: .value(4), right: .value(9)),
                    right: .pair(left: .value(6), right: .value(9))
                ),
                right: .pair(
                    left: .pair(left: .value(8), right: .value(2)),
                    right: .pair(left: .value(7), right: .value(3))
                )
            )
        )
        XCTAssertEqual(result, expected)
    }
}

// MARK: - Addition
class SnailfishNumberAdditionTests: XCTestCase {
    private let ones   = SnailfishNumber.pair(left: .value(1), right: .value(1))
    private let twos   = SnailfishNumber.pair(left: .value(2), right: .value(2))
    private let threes = SnailfishNumber.pair(left: .value(3), right: .value(3))
    private let fours  = SnailfishNumber.pair(left: .value(4), right: .value(4))
    private let fives  = SnailfishNumber.pair(left: .value(5), right: .value(5))
    private let sixes  = SnailfishNumber.pair(left: .value(6), right: .value(6))
    
    func testAdditionWithoutAnyReduction() {
        let left = SnailfishNumber.pair(left: .value(1), right: .value(2))
        let right = SnailfishNumber.pair(left: .pair(left: .value(3), right: .value(4)), right: .value(5))
        let result = left + right
        let expected = SnailfishNumber.pair(
            left: .pair(left: .value(1), right: .value(2)),
            right: .pair(left: .pair(left: .value(3), right: .value(4)), right: .value(5))
        )
        XCTAssertEqual(result, expected)
    }
    
    func testMultipleAdditionWithoutAnyReduction() {
        let result = ones + twos + threes + fours
        let expected = SnailfishNumber.from(string: "[[[[1,1],[2,2]],[3,3]],[4,4]]")
        XCTAssertEqual(result, expected)
    }
    
    func testMultipleAdditionWithSingleReduction() {
        let result = ones + twos + threes + fours + fives
        let expected = SnailfishNumber.from(string: "[[[[3,0],[5,3]],[4,4]],[5,5]]")
        XCTAssertEqual(result, expected)
    }
    
    func testMultipleAdditionWithMultipleReduction() {
        let result = ones + twos + threes + fours + fives + sixes
        let expected = SnailfishNumber.from(string: "[[[[5,0],[7,4]],[5,5]],[6,6]]")
        XCTAssertEqual(result, expected)
    }
}
