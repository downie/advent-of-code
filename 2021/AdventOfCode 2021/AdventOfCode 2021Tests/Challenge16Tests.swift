//
//  Challenge16Tests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/16/21.
//

import XCTest
@testable import AdventOfCode_2021

class Challenge16Tests: XCTestCase {

    // MARK: Part 1
    
    func testDemo0Part1() throws {
        let solver = BitTwiddler(demoInput: "8A004A801A8002F478")
        solver.solve()
        XCTAssertEqual(solver.output, "16")
    }

    func testDemo1Part1() throws {
        let solver = BitTwiddler(demoInput: "620080001611562C8802118E34")
        solver.solve()
        XCTAssertEqual(solver.output, "12")
    }
    
    func testDemo2Part1() throws {
        let solver = BitTwiddler(demoInput: "C0015000016115A2E0802F18234")
        solver.solve()
        XCTAssertEqual(solver.output, "23")
    }
    
    func testDemo3Part1() throws {
        let solver = BitTwiddler(demoInput: "A0016C880162017C3686B18A3D4780")
        solver.solve()
        XCTAssertEqual(solver.output, "31")
    }
    
    // MARK: - Part Two
    
    func testDemo0Part2Sum() throws {
        let solver = BitTwiddler(demoInput: "C200B40A82", isPartTwo: true)
        solver.solve()
        XCTAssertEqual(solver.output, "3")
    }

    func testDemo1Part2Product() throws {
        let solver = BitTwiddler(demoInput: "04005AC33890", isPartTwo: true)
        solver.solve()
        XCTAssertEqual(solver.output, "54")
    }
    
    func testDemo2Part2Minimum() throws {
        let solver = BitTwiddler(demoInput: "880086C3E88112", isPartTwo: true)
        solver.solve()
        XCTAssertEqual(solver.output, "7")
    }
    
    func testDemo3Part2Maximum() throws {
        let solver = BitTwiddler(demoInput: "CE00C43D881120", isPartTwo: true)
        solver.solve()
        XCTAssertEqual(solver.output, "9")
    }
    
    func testDemoLessThanOperation() throws {
        let solver = BitTwiddler(demoInput: "D8005AC2A8F0", isPartTwo: true)
        solver.solve()
        XCTAssertEqual(solver.output, "1")
    }
    
    func testDemoGreaterThanOperation() throws {
        let solver = BitTwiddler(demoInput: "F600BC2D8F", isPartTwo: true)
        solver.solve()
        XCTAssertEqual(solver.output, "0")
    }
    
    func testDemoNotEqualToOperation() throws {
        let solver = BitTwiddler(demoInput: "9C005AC2F8F0", isPartTwo: true)
        solver.solve()
        XCTAssertEqual(solver.output, "0")
    }
    
    func testDemoComplicatedEqualityOperation() throws {
        let solver = BitTwiddler(demoInput: "9C0141080250320F1802104A08", isPartTwo: true)
        solver.solve()
        XCTAssertEqual(solver.output, "1")
    }
}
