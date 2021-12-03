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
    let temp = numbers
        .map { $0 & mask }
        .map { $0 >> position }
//    print(temp)
    let onesFound = temp
        .reduce(0, +)
    
    return Double(onesFound) >= (Double(numbers.count) / 2.0)
}
assert(isMostCommonBitOne(in: [
    0b11110,
    0b10110,
    0b10111,
    0b10101,
    0b11100,
    0b10000,
    0b11001
], at: 3) == false)
//assert(isMostCommonBitOne(in: [30, 22, 23, 21, 28, 16, 25], at: 3) == false)


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

// MARK: - Part 2

func lifeSupportRating(for string: String) -> Int {
    let (numbers, size) = parseInput(from: string)
    var oxygenRating = numbers
    var carbonDioxideRating = numbers
    
    // Oxygen
    var position = size - 1
    while oxygenRating.count != 1 && position >= 0 {
//        print(oxygenRating.map {String($0, radix: 2)})
        let isOne = isMostCommonBitOne(in: oxygenRating, at: position)
//        print("is 1 most common at \(position)? \(isOne)")
//        print(oxygenRating)
        let mask = 0x01 << position
        oxygenRating = oxygenRating
            .filter { number in
                let bit = (number & mask) >> position
                return bit == (isOne ? 1 : 0)
            }
        position -= 1
    }
    
    // CO2
    position = size - 1
    while carbonDioxideRating.count != 1 && position >= 0 {
        let isOne = isMostCommonBitOne(in: carbonDioxideRating, at: position)
        let mask = 0x01 << position
        carbonDioxideRating = carbonDioxideRating
            .filter { number in
                let bit = (number & mask) >> position
                return bit == (!isOne ? 1 : 0)
            }
        position -= 1
    }
    
    return oxygenRating.first! * carbonDioxideRating.first!
}

assert(lifeSupportRating(for: demoInputString) == 230)

print("Part 2: \(lifeSupportRating(for: inputString))")

//: [Next](@next)
