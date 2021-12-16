//
//  PacketDecoderTests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/16/21.
//

@testable import AdventOfCode_2021
import XCTest

class PacketDecoderTests: XCTestCase {
    var decoder: PacketDecoder!

    override func setUpWithError() throws {
        decoder = PacketDecoder()
    }

    func testLiteralValue() throws {
        let packet = try decoder.decode(hexadecimalString: "D2FE28")
        let expected = Packet(version: 6, type: .literal(value: 2021))
        XCTAssertEqual(packet, expected)
    }
    
    func testOperatorValueWithFixedBitLengthOfSubPackets() throws {
        let packet = try decoder.decode(hexadecimalString: "38006F45291200")
        let expected = Packet(version: 1, type: .operatorWith(packets: [
            Packet(version: 6, type: .literal(value: 10)),
            Packet(version: 2, type: .literal(value: 20))
        ]))
        XCTAssertEqual(packet, expected)
    }
    
    func testOperatorValueWithFixedNumberOfSubPackets() throws {
        let packet = try decoder.decode(hexadecimalString: "EE00D40C823060")
        let expected = Packet(version: 7, type: .operatorWith(packets: [
            Packet(version: 2, type: .literal(value: 1)),
            Packet(version: 4, type: .literal(value: 2)),
            Packet(version: 1, type: .literal(value: 3)),
        ]))
        XCTAssertEqual(packet, expected)
    }
    
    // MARK: - Bit chunking tests
    
    func testSmallNumbersAreIdenticalToIntParsing() throws {
        let result = decoder.bits(from: "D2FE28")
        let expected = [
            UInt64(0xD2FE2800_00000000)
        ]
        print(String(expected.first!, radix: 2))
        print(String(result.first!, radix: 2))
        XCTAssertEqual(result, expected)
    }
}
