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
    
    func solve() {
        if isPartTwo {
            output = "::shrugs::"
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
