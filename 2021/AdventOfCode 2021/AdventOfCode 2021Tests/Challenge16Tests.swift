//
//  Challenge16Tests.swift
//  AdventOfCode 2021Tests
//
//  Created by Chris Downie on 12/16/21.
//

import XCTest
@testable import AdventOfCode_2021

class Challenge16Tests: XCTestCase {

    func testDemo0() throws {
        let solver = BitTwiddler(demoInput: "8A004A801A8002F478")
        solver.solve()
        XCTAssertEqual(solver.output, "16")
    }

    func testDemo1() throws {
        let solver = BitTwiddler(demoInput: "620080001611562C8802118E34")
        solver.solve()
        XCTAssertEqual(solver.output, "12")
    }
    
    func testDemo2() throws {
        let solver = BitTwiddler(demoInput: "C0015000016115A2E0802F18234")
        solver.solve()
        XCTAssertEqual(solver.output, "23")
    }
    
    func testDemo3() throws {
        let solver = BitTwiddler(demoInput: "A0016C880162017C3686B18A3D4780")
        solver.solve()
        XCTAssertEqual(solver.output, "31")
    }
}
