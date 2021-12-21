//
//  Challenge14.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/14/21.
//

import SwiftUI

private let demoInput = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C

"""

struct SquareMatrix: Equatable, CustomStringConvertible {
    let size: Int
    private var values = [Point: Int]()
    
    init(size: Int) {
        self.size = size
    }
    
    func valueAt(row: Int, column: Int) -> Int {
        values[Point(x: column, y: row)] ?? 0
    }
    
    mutating func update(row: Int, column: Int, to value: Int) {
        precondition(0 <= row && row < size)
        precondition(0 <= column && column < size)
        values[Point(x: column, y: row)] = value
    }
    
    static func *(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        precondition(lhs.size == rhs.size)
        let size = lhs.size
        var result = SquareMatrix(size: size)
        for leftRow in 0..<size {
            for rightColumn in 0..<size {
                let leftValues = (0..<size).map { lhs.valueAt(row: leftRow, column: $0) }
                let rightValues = (0..<size).map { rhs.valueAt(row: $0, column: rightColumn)}
                let value = zip(leftValues, rightValues).reduce(0) { partialResult, pair in
                    partialResult + pair.0 * pair.1
                }
                result.update(row: leftRow, column: rightColumn, to: value)
            }
        }
        return result
    }
    
    static func *(lhs: Int, rhs: SquareMatrix) -> SquareMatrix {
        var result = SquareMatrix(size: rhs.size)
        for row in 0..<rhs.size {
            for column in 0..<rhs.size {
                let value = rhs.valueAt(row: row, column: column)
                result.update(row: row, column: column, to: lhs * value)
            }
        }
        return result
    }
    
    static func +(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        precondition(lhs.size == rhs.size)
        var result = SquareMatrix(size: lhs.size)
        for leftRow in 0..<lhs.size {
            for leftColumn in 0..<lhs.size {
                let left = lhs.valueAt(row: leftRow, column: leftColumn)
                let right = rhs.valueAt(row: leftRow, column: leftColumn)
                result.update(row: leftRow, column: leftColumn, to: left + right)
            }
        }
        return result
    }
    
    static func ==(lhs: SquareMatrix, rhs: SquareMatrix) -> Bool {
        guard lhs.size == rhs.size else {
            return false
        }
        for row in 0..<lhs.size {
            for col in 0..<rhs.size {
                guard lhs.valueAt(row: row, column: col) == rhs.valueAt(row: row, column: col) else {
                    return false
                }
            }
        }
        return true
    }
    
    var description: String {
        (0..<size).map { row -> String in
            (0..<size).map { col in
                values[Point(x: col, y: row)] ?? 0
            }
            .map(String.init)
            .joined(separator: " ")
        }
        .joined(separator: "\n")
    }
}

class PolymerExtruder: ObservableObject {
    struct Rule {
        let replace: String
        let with: String
    }
    
    @Published var output = ""
    private let isDemo = true
    private let isPartTwo = false
    private let isDFS = false
    private let isMatrixSolution = true
    private var maxSteps: Int {
        isPartTwo ? 40 : 10
    }
    
    var polymer: String
    var rules: [String: Character] // [from : to]
    var treeRules: [Character: [Character: Character]]
    
    // Matrix attempt
    let indexContent: [Character]
    var countMatrix: SquareMatrix
    let changeMap: [String: SquareMatrix]
    
    init() {
        let input: String
        if isDemo {
            input = demoInput
        } else {
            let inputData = NSDataAsset(name: "14")!.data
            input = String(data: inputData, encoding: .utf8)!
        }
        
        let parts = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n\n")
        polymer = parts[0]
        rules = parts[1]
            .components(separatedBy: .newlines)
            .reduce(into: [String: Character]()) { partialResult, line in
                let pair = line.components(separatedBy: " -> ")
                partialResult[pair[0]] = Character(pair[1])
            }
        let allLetters: Set<Character> = rules.reduce(into: Set<Character>()) { partialResult, pair in
            partialResult.insert(pair.value)
            pair.key.forEach { partialResult.insert($0) }
        }
        indexContent = Array(allLetters)
        let size = indexContent.count
        // Set up that matrix
        countMatrix = SquareMatrix(size: size)
        
        for offset in 0..<polymer.count-1 {
            let index = polymer.index(polymer.startIndex, offsetBy: offset, limitedBy: polymer.endIndex)!
            let pair = polymer[index...polymer.index(after: index)]
            let row = indexContent.firstIndex(of: pair.first!)!
            let column = indexContent.firstIndex(of: pair.last!)!
            countMatrix.update(row: row, column: column, to: countMatrix.valueAt(row: row, column: column) + 1)
        }

        changeMap = rules.reduce(into: [String: SquareMatrix]()) { [indexContent] partialResult, pair in
            let (key, value) = pair
            let firstIndex = indexContent.firstIndex(of: key.first!)!
            let lastIndex = indexContent.firstIndex(of: key.last!)!
            let middleIndex = indexContent.firstIndex(of: value)!
            
            var matrix = SquareMatrix(size: size)
            matrix.update(row: firstIndex, column: lastIndex, to: matrix.valueAt(row: firstIndex, column: lastIndex) - 1)
            matrix.update(row: firstIndex, column: middleIndex, to: matrix.valueAt(row: firstIndex, column: middleIndex) + 1)
            matrix.update(row: middleIndex, column: lastIndex, to: matrix.valueAt(row: middleIndex, column: lastIndex) + 1)

            partialResult[key] = matrix
        }
        
        treeRules = rules.reduce(into: [Character: [Character: Character]]()) { partialResult, pair in
            let firstLetter = pair.key[pair.key.startIndex]
            let secondLetter = pair.key[pair.key.index(after: pair.key.startIndex)]
            var firstLetterMap = partialResult[firstLetter, default: [Character: Character]()]
            firstLetterMap[secondLetter] = pair.value
            partialResult[pair.key[pair.key.startIndex]] = firstLetterMap
        }
    }
    
    func solve() {
        if isMatrixSolution {
            let result = solveWithMatrixMath()
            output = "\(result)"
        } else if isDFS { // isPartTwo
            // Expanding the string is a kind of bredth-first search. Let's do depth
            let result = depthFirstScore(polymer: Array(polymer))
            output = "\(result)"
        } else {
            var chars = Array(polymer)
            (0..<maxSteps).forEach { step in
                let nextPolymer = iterate(polymerCharacters: chars)
                if isDemo {
                    if step < 4 {
                        print("After step \(step + 1): \(nextPolymer)")
                    } else {
                        print("After step \(step + 1): \(nextPolymer.count)")
                    }
                }
                chars = nextPolymer
            }
            let result = score(polymer: String(chars))
            output = "\(result)"
        }
    }
    
    func solveWithMatrixMath() -> Int {
        print(countMatrix)
        print(Self.letterFrequencies(for: countMatrix, content: indexContent, lastLetter: polymer.last!))
        let size = indexContent.count
        (0..<maxSteps).forEach { _ in
            var nextStepCount = countMatrix
            (0..<size).forEach { row in
                (0..<size).forEach { col in
                    let multiple = countMatrix.valueAt(row: row, column: col)
                    let key = "\(indexContent[row])\(indexContent[col])"
                    if let matrix = changeMap[key] {
                        nextStepCount = nextStepCount + multiple * matrix
                    }
                }
            }
            countMatrix = nextStepCount
            print(countMatrix)
            print(Self.letterFrequencies(for: countMatrix, content: indexContent, lastLetter: polymer.last!))
        }
        return Self.score(matrix: countMatrix, content: indexContent, lastLetter: polymer.last!)
    }
    
    static func letterFrequencies(for matrix: SquareMatrix, content: [Character], lastLetter: Character) -> [Character: Int] {
        precondition(matrix.size == content.count)
        var result = [Character: Int]()
        result[lastLetter] = 1
        let size = matrix.size
        for row in 0..<size {
            for col in 0..<size {
                let rowChar = content[row]
                let value = matrix.valueAt(row: row, column: col)
                
                result[rowChar] = result[rowChar, default: 0] + value
            }
        }
        return result
    }
    
    static func score(matrix: SquareMatrix, content: [Character], lastLetter: Character) -> Int {
        let frequencies = letterFrequencies(for: matrix, content: content, lastLetter: lastLetter)
        print(frequencies)
        let maximum = frequencies.map { $0.value }.reduce(0, max)
        let minimum = frequencies.map { $0.value }.reduce(Int.max, min)
        return maximum - minimum
    }
    
    func iterate(polymer: String) -> String {
        String(iterate(polymerCharacters: Array(polymer)))
    }
    
    func iterate(polymerCharacters polymer: [Character]) -> [Character] {
        var parts = [Character]()
        
        for offset in 0..<polymer.count-1 {
            let index = polymer.index(polymer.startIndex, offsetBy: offset, limitedBy: polymer.endIndex)!
            let pair = polymer[index...polymer.index(after: index)]
            parts.append(polymer[index])
            if let insertion = rules[String(pair)] {
                parts.append(insertion)
            }
        }
        parts.append(polymer.last!)
        
        return parts
    }
    
    func score(polymer: String) -> Int {
        let counts = Dictionary(grouping: polymer, by: { $0 })
            .map { pair in
                (pair.key, pair.value.count)
            }
            .reduce(into: [Character: Int]()) { partialResult, pair in
                partialResult[pair.0] = pair.1
            }
        let maximum = counts.reduce(0) { partialResult, pair in
            max(partialResult, pair.value)
        }
        let minimum = counts.reduce(Int.max) { partialResult, pair in
            min(partialResult, pair.value)
        }
        return maximum - minimum
    }
    
    func depthFirstScore(polymer: [Character]) -> Int {
        var counts = [Character : Int]()
        
        for offset in 0..<polymer.count-1 {
            let index = polymer.index(polymer.startIndex, offsetBy: offset, limitedBy: polymer.endIndex)!
            let pair = polymer[index...polymer.index(after: index)]
            print("Starting depth 0 at offset \(offset)")
            depthFirstScore(polymer: Array(pair), depth: 0, counts: &counts)
        }
        print("Completed All Offsets.")
        counts[polymer.last!] = counts[polymer.last!, default: 0] + 1
        
        let maximum = counts.reduce(0) { partialResult, pair in
            max(partialResult, pair.value)
        }
        let minimum = counts.reduce(Int.max) { partialResult, pair in
            min(partialResult, pair.value)
        }
        return maximum - minimum
    }
    
    func depthFirstScore(polymer: [Character], depth: Int, counts: inout [Character: Int]) {
        guard depth < maxSteps,
              let insertion = rules[String(polymer)] else {
//                  let insertion = tree[polymer[polymer.startIndex]][polymer[polymer.index(after: polymer.startIndex)]] else {
            // only count the first letter
            let letter = polymer.first!
            counts[letter] = counts[letter, default: 0] + 1
            return
        }
        let left = [polymer.first!, insertion]
        depthFirstScore(polymer: left, depth: depth + 1, counts: &counts)
        
        let right = [insertion, polymer.last!]
        depthFirstScore(polymer: right, depth: depth + 1, counts: &counts)
    }
}



struct Challenge14: View {
    @StateObject var state = PolymerExtruder()
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        VStack {
            Text(state.output)
                .font(.system(.body, design: .monospaced))
                .onAppear {
                    state.solve()
                }
            Button {
                pasteboard.prepareForNewContents()
                _ = pasteboard.setString(state.output, forType: .string)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
        }
        .frame(minWidth: 200)
    }
}

struct Challenge14_Previews: PreviewProvider {
    static var previews: some View {
        Challenge14()
    }
}
