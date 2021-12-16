//
//  BitStreamTests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/16/21.
//

import XCTest
@testable import AdventOfCode_2021

class BitStreamTests: XCTestCase {

    func testReadingThreeBitsWorksTheFirstTime() throws {
        var stream = BitStream(bits: [0xaf00_0000_0000_0000])
        let five = stream.read(bits: 3)
        XCTAssertEqual(five, 5)
    }

    func testReadingTheSecondThreeBits() throws {
        var stream = BitStream(bits: [0xaf00_0000_0000_0000])
        let five = stream.read(bits: 3)
        let three = stream.read(bits: 3)
        XCTAssertEqual(three, 3)
    }
}
