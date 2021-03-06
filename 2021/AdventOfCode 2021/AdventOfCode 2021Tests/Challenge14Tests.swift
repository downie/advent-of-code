//
//  Challenge14Tests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/20/21.
//

import XCTest
@testable import AdventOfCode_2021

class Challenge14Tests: XCTestCase {
    func testMatrixFrequencyCounterWithDoubleLetterExample() throws {
        let letters: [Character] = ["A", "B"]
        // Matrix represents the string "AA"
        //     A   B
        // A   1   0
        // B   0   0
        var matrix = SquareMatrix(size: 2)
        matrix.update(row: 0, column: 0, to: 1)
        let expected: [Character: Int] = [
            "A": 2,
            "B": 0
        ]
        let result = PolymerExtruder.letterFrequencies(for: matrix, content: letters, lastLetter: "A")
        XCTAssertEqual(result, expected)
    }
    
    func testMatrixFrequencyCounterWithNonDoubleLetterExample() throws {
        let letters: [Character] = ["A", "B"]
        // Matrix represents the string "AB"
        //     A   B
        // A   0   1
        // B   0   0
        var matrix = SquareMatrix(size: 2)
        matrix.update(row: 0, column: 1, to: 1)
        let expected: [Character: Int] = [
            "A": 1,
            "B": 1
        ]
        let result = PolymerExtruder.letterFrequencies(for: matrix, content: letters, lastLetter: "B")
        XCTAssertEqual(result, expected)
    }
    
    func testMatrixFrequencyCounterWithThreeLetterExample() throws {
        let letters: [Character] = ["A", "B"]
        // Matrix represents the string "ABA"
        //     A   B
        // A   0   1
        // B   1   0
        var matrix = SquareMatrix(size: 2)
        matrix.update(row: 0, column: 1, to: 1)
        matrix.update(row: 1, column: 0, to: 1)
        let expected: [Character: Int] = [
            "A": 2,
            "B": 1
        ]
        let result = PolymerExtruder.letterFrequencies(for: matrix, content: letters, lastLetter: "A")
        XCTAssertEqual(result, expected)
    }
    
    func testMatrixFrequencyCounterWithFiveAsExample() throws {
        let letters: [Character] = ["A", "B"]
        // Matrix represents the string "AAAAA"
        //     A   B
        // A   4   0
        // B   0   0
        var matrix = SquareMatrix(size: 2)
        matrix.update(row: 0, column: 0, to: 4)
        let expected: [Character: Int] = [
            "A": 5,
            "B": 0
        ]
        let result = PolymerExtruder.letterFrequencies(for: matrix, content: letters, lastLetter: "A")
        XCTAssertEqual(result, expected)
    }
    
    func testMatrixFrequencyCounterWithComplexExample() throws {
        let letters: [Character] = ["A", "B", "C"]
        // Matrix represents the string "ABBACBBAA"
        //     A   B   C
        // A   1   1   1
        // B   2   2   0
        // C   0   1   0
        var matrix = SquareMatrix(size: 3)
        matrix.update(row: 0, column: 0, to: 1)
        matrix.update(row: 0, column: 1, to: 1)
        matrix.update(row: 0, column: 2, to: 1)
        matrix.update(row: 1, column: 0, to: 2)
        matrix.update(row: 1, column: 1, to: 2)
        matrix.update(row: 1, column: 2, to: 0)
        matrix.update(row: 2, column: 0, to: 0)
        matrix.update(row: 2, column: 1, to: 1)
        matrix.update(row: 2, column: 2, to: 0)
        
        let expected: [Character: Int] = [
            "A": 4,
            "B": 4,
            "C": 1
        ]
        let result = PolymerExtruder.letterFrequencies(for: matrix, content: letters, lastLetter: "A")
        XCTAssertEqual(result, expected)
    }
}
