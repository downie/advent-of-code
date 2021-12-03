//: [Previous](@previous)

import Foundation

// Input parsing
let file = Bundle.main.url(forResource: "03", withExtension: "txt")!
var inputData = try! Data(contentsOf: file)
let inputString = String(data: inputData, encoding: .utf8)!

let demoInputString = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""

// Return the numbers, and the width of the binary number
func parseInput(from string: String) -> ([Int], Int) {
    let lines = string.components(separatedBy: .newlines)
    guard let size = lines.first?.count else {
        return ([], 0)
    }
    let numbers = lines.compactMap { Int($0, radix: 2) }
    return (numbers, size)
}

let demoResult = parseInput(from: demoInputString)
assert(demoResult.1 == 5)

// `position` is a 0-based count from the least significant digit.
func isMostCommonBitOne(in numbers: [Int], at position: Int) -> Bool {
    let mask = 0x01 << position
    let onesFound = numbers
        .map { $0 & mask }
        .map { $0 >> position }
        .reduce(0, +)
    return onesFound >= numbers.count / 2
}

// MARK: - Part 1
func powerConsumption(for string: String) -> Int {
    var gamma = 0
    var epsilon = 0
    
    let (numbers, size) = parseInput(from: string)
    
    for shift in 0..<size {
        if isMostCommonBitOne(in: numbers, at: shift) {
            gamma = gamma | (0x01 << shift)
        } else {
            epsilon = epsilon | (0x01 << shift)
        }
    }
    
    return gamma * epsilon
}

assert(powerConsumption(for: demoInputString) == 198)

print("Part 1: \(powerConsumption(for: inputString))")


//: [Next](@next)
