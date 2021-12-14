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

class PolymerExtruder: ObservableObject {
    struct Rule {
        let replace: String
        let with: String
    }
    
    @Published var output = ""
    private let isDemo = true
    private let isPartTwo = true
    private let isMultithreaded = true
    private var maxSteps: Int {
        isPartTwo ? 40 : 10
    }
    
    var polymer: String
    var rules: [String: Character] // [from : to]
    
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
    }
    
    private let queue = OperationQueue()
    private class IterateOperation: Operation {
        private let polymer: ArraySlice<Character>
        private let rules: [String: Character]
        private let includingLastLetter: Bool
        var result = [Character]()
        
        init(polymer: ArraySlice<Character>, rules: [String: Character], includingLastLetter: Bool = false) {
            self.polymer = polymer
            self.rules = rules
            self.includingLastLetter = includingLastLetter
        }
        
        override func main() {
            for offset in 0..<polymer.count-1 {
                let index = polymer.index(polymer.startIndex, offsetBy: offset, limitedBy: polymer.endIndex)!
                let pair = polymer[index...polymer.index(after: index)]
                result.append(polymer[index])
                if let insertion = rules[String(pair)] {
                    result.append(insertion)
                }
            }
            if includingLastLetter {
                result.append(polymer.last!)
            }
        }
    }
    
    private class CombineOperation: Operation {
        private let callback: ([Character]) -> Void
        
        init(callback: @escaping ([Character]) -> Void) {
            self.callback = callback
        }
        
        override func main() {
            let chars = dependencies.flatMap { op in
                (op as! IterateOperation).result
            }
            callback(chars)
        }
    }
    
    func solve() {
        if isMultithreaded {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                var chars: [Character] = Array(self.polymer)
                let chunkSize = chars.count
                (0..<self.maxSteps).forEach { step in
                    let chunks = stride(from: 0, to: chars.count, by: chunkSize)
                        .map { startIndex -> ArraySlice<Character> in
                            let end = min((startIndex+1)*chunkSize + 1, chars.count)
                            let subset = chars[startIndex..<end]
                            return subset
                        }
                    var operations: [Operation] = chunks.map { slice in
                        IterateOperation(polymer: slice, rules: self.rules, includingLastLetter: false)
                    }
                    let resultOperation = CombineOperation { newChars in
                        let lastChar = chars.last!
                        chars = newChars
                        chars.append(lastChar)
                        if self.isDemo {
                            if step < 4 {
                                print("After step \(step + 1): \(String(chars))")
                            } else {
                                print("After step \(step + 1): \(chars.count)")
                            }
                        }
                    }
                    operations.forEach { op in
                        resultOperation.addDependency(op)
                    }
                    operations.append(resultOperation)
                    self.queue.addOperations(operations, waitUntilFinished: true)
                }

                let finalResult = String(chars)
                DispatchQueue.main.async { [weak self] in
                    self?.output = finalResult
                }
            }

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
