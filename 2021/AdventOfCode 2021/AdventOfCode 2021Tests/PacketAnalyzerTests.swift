//
//  PacketAnalyzerTests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/16/21.
//

import XCTest
@testable import AdventOfCode_2021

class PacketAnalyzerTests: XCTestCase {
    let analyzer = PacketAnalyzer()
    
    func testDeepNestedOperatorPackets() throws {
        let input = Packet(version: 4, type: .sum(packets: [
            Packet(version: 1, type: .sum(packets: [
                Packet(version: 5, type: .sum(packets: [
                    Packet(version: 6, type: .literal(value: 100)) // 100 is a guess here.
                ]))
            ]))
        ]))
        let expected = 16
        let result = analyzer.sumVersions(of: input)
        XCTAssertEqual(result, expected)
    }
}
