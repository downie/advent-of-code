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
    
    func testOperatorValueWithTwoSubPackets() throws {
        let packet = try decoder.decode(hexadecimalString: "38006F45291200")
        let expected = Packet(version: 1, type: .operatorWith(packets: [
            Packet(version: 7, type: .literal(value: 10)), // I'm pretty sure these versions are right
            Packet(version: 2, type: .literal(value: 20))
        ]))
        XCTAssertEqual(packet, expected)
    }
    
    func testOperatorValueWithThreeSubPackets() throws {
        let packet = try decoder.decode(hexadecimalString: "EE00D40C823060")
        let expected = Packet(version: 7, type: .operatorWith(packets: [
            Packet(version: 2, type: .literal(value: 1)),
            Packet(version: 4, type: .literal(value: 2)),
            Packet(version: 1, type: .literal(value: 3)),
        ]))
        XCTAssertEqual(packet, expected)
    }
    
}
