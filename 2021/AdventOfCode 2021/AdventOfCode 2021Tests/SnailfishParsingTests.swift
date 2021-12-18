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
    func testAdditionWithoutAnyReduction() {
        let left = SnailfishNumber.pair(left: .value(1), right: .value(2))
        let right = SnailfishNumber.pair(left: .pair(left: .value(3), right: .value(4)), right: .value(5))
        let result = left + right
        let expected = SnailfishNumber.pair(
            left: .pair(left: .value(1), right: .value(1)),
            right: .pair(left: .pair(left: .value(3), right: .value(4)), right: .value(5))
        )
        XCTAssertEqual(result, expected)
    }
}
