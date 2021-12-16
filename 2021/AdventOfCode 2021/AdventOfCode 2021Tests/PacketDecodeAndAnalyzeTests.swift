//
//  PacketDecodeAndAnalyzeTests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/16/21.
//

import XCTest
@testable import AdventOfCode_2021

class PacketDecodeAndAnalyzeTests: XCTestCase {
    let decoder = PacketDecoder()
    let analyzer = PacketAnalyzer()

    func testTreeNestedExampleWithFirstLengthType() throws {
        let root = try decoder.decode(hexadecimalString: "620080001611562C8802118E34")
        let result = analyzer.sumVersions(of: root)
        let expected = 12
        XCTAssertEqual(result, expected)
    }
    
    func testTreeNestedExampleWithSecondLengthType() throws {
        let root = try decoder.decode(hexadecimalString: "C0015000016115A2E0802F182340")
        let result = analyzer.sumVersions(of: root)
        let expected = 23
        XCTAssertEqual(result, expected)
    }
    
    func testThreeLiteralValuesDeeplyNested() throws {
        let root = try decoder.decode(hexadecimalString: "A0016C880162017C3686B18A3D4780")
        let result = analyzer.sumVersions(of: root)
        let expected = 31
        XCTAssertEqual(result, expected)
    }
}
