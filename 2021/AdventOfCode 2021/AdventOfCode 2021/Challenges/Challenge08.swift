//
//  Challenge08.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/8/21.
//

import SwiftUI

private let demoInput = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce

"""
struct ScrambledSegment {
    let allDigits: [String]
    let outputDigits: [String]
    
    var outputValue: Int {
        outputDigits.reduce(0) { value, digitString in
            guard value >= 0 else {
                return value
            }
            guard let digit = segmentToDisplay[digitString] else {
                return -1
            }

            var newValue = value * 10
            newValue += digit
            return newValue
        }
    }
    
    private var segmentToDisplay = [String: Int]()
    
    init(line: String) {
        let parts = line.components(separatedBy: " | ")
        let inputs = parts[0]
            .components(separatedBy: .whitespaces)
            .map { input in
                String(input.sorted())
            }.sorted { left, right in
                left.count < right.count
            }
        let outputs = parts[1]
            .components(separatedBy: .whitespaces)
            .map { input in
                String(input.sorted())
            }
        allDigits = inputs
        outputDigits = outputs
        
        solve()
    }
    
    func solve() {
        
    }
}

class SegmentDescrambler: ObservableObject {
    @Published var output = ""
    private var isDemo = true
    private let isPartTwo = true
    
    private var input: String
    init() {
//        let input: String
        if !isDemo {
            let inputData = NSDataAsset(name: "08")!.data
            input = String(data: inputData, encoding: .utf8)!
        } else {
            input = demoInput
        }
    }
    
    func solve() {
        if isPartTwo {
            solvePartTwo()
        } else {
            solvePartOne()
        }
    }
    
    func solvePartOne() {
        let outputs = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .map { line -> [String] in
                let parts = line.components(separatedBy: " | ")
                // disard line[0]
                let outputs = parts[1].components(separatedBy: .whitespaces)
                return outputs
            }
            .flatMap { $0 }
        let result = outputs.reduce(0) { sum, outputString in
            let numberOfSegmentsOn = outputString.count
            switch numberOfSegmentsOn {
            case 2, 3, 4, 7:
                return sum + 1
            default:
                return sum
            }
        }
        output = "\(result)"
    }
    
    func solvePartTwo() {
        var lines = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)

        if isDemo {
            // Only do the first line for demo input on part 2
            lines = Array(lines[...0])
        }
        
        let segments = lines.map { ScrambledSegment(line: $0) }
        let result = segments
            .map { $0.outputValue }
            .reduce(0, +)
        output = "\(result)"
    }
}

struct Challenge08: View {
    @StateObject var state = SegmentDescrambler()
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

struct Challenge08_Previews: PreviewProvider {
    static var previews: some View {
        Challenge08()
    }
}
