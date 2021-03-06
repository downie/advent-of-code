//
//  Challenge10.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/10/21.
//

import SwiftUI

private let demoInput = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

class ParenParser: ObservableObject {
    @Published var output = ""
    private let isDemo = false
    private let isPartTwo = true
    private let input: String
    enum ParseResult {
        case complete
        case incomplete(unmatched: String)
        case corrupted(token: Character)
    }
    
    init() {
        if !isDemo {
            let inputData = NSDataAsset(name: "10")!.data
            input = String(data: inputData, encoding: .utf8)!
        } else {
            input = demoInput
        }
    }

    func solve() {
        if !isPartTwo {
            let corruptedLines = input
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)
                .map { verify(line: $0) }
                .filter { result in
                    if case .corrupted = result {
                        return true
                    }
                    return false
                }
            let result = corruptedLines
                .map { score(result: $0) }
                .reduce(0, +)
            output = "\(result)"
        } else {
            let missingLines = input
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .newlines)
                .map { verify(line: $0) }
                .filter { result in
                    if case .incomplete = result {
                        return true
                    }
                    return false
                }
            let scores = missingLines
                .map { score(result: $0) }
                .sorted()
            let middleValue = scores[scores.count / 2]
            output = "\(middleValue)"
        }
    }
    
    private func verify(line: String) -> ParseResult {
        var stack = [Character]()

        for letter in line {
            if "([{<".contains(letter) {
                stack.append(letter)
            } else if let matching = stack.popLast() {
                switch (matching, letter) {
                case ("(", ")"),
                    ("[", "]"),
                    ("{", "}"),
                    ("<", ">"):
                    break
                default:
                    return .corrupted(token: letter)
                }
            } else {
                // close before open
                return .corrupted(token: letter)
            }
        }
        guard stack.isEmpty else {
            return .incomplete(unmatched: String(stack.reversed()))
        }
        return .complete
    }
    
    private func score(result: ParseResult) -> Int {
        switch result {
        case .complete:
            return 0
        case .incomplete(let missing):
            return missing.reduce(0) { partialResult, nextLetter in
                var letterValue: Int
                switch nextLetter {
                case ")", "(": letterValue = 1
                case "]", "[": letterValue = 2
                case "}", "{": letterValue = 3
                case ">", "<": letterValue = 4
                default: fatalError()
                }
                return 5 * partialResult + letterValue
            }
        case .corrupted(let token) where token == ")":
            return 3
        case .corrupted(let token) where token == "]":
            return 57
        case .corrupted(let token) where token == "}":
            return 1197
        case .corrupted(let token) where token == ">":
            return 25137
        case .corrupted:
            return -1
        }
    }
}

struct Challenge10: View {
    @StateObject var state = ParenParser()
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        VStack {
            Text(state.output)
                .frame(minWidth: 200)
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
    }
}
struct Challenge10_Previews: PreviewProvider {
    static var previews: some View {
        Challenge10()
    }
}
