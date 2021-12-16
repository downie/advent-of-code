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
        let result = stream.read(bits: 3)
        let expected = 0b101
        XCTAssertEqual(result, expected)
    }

    func testReadingTheSecondThreeBits() throws {
        var stream = BitStream(bits: [0xaf00_0000_0000_0000])
        _ = stream.read(bits: 3)
        let result = stream.read(bits: 3)
        let expected = 0b011
        XCTAssertEqual(result, expected)
    }
    
    func testReadingAcrossMultipleChunks() throws {
        var stream = BitStream(bits: [0x0000_0000_0000_0002, 0xffff_0000_0000_0000])
        _ = stream.read(bits: 62)
        let result = stream.read(bits: 4)
        let expected = 0b1011
        XCTAssertEqual(result, expected)
    }
    
    func testReadingAfterTheLastChunk() throws {
        var stream = BitStream(bits: [0x0000_0000_0000_0002])
        _ = stream.read(bits: 62)
        let result = stream.read(bits: 4)
        let expected = 0b1000
        XCTAssertEqual(result, expected)
    }
}
