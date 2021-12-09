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

private let partTwoDemoInput = """
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
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
    
    mutating func solve() {
        // Canonical wire layout
        //   aaaa
        //  b    c
        //  b    c
        //   dddd
        //  e    f
        //  e    f
        //   gggg
        
        // allDigits is sorted, so we know the position of a few numbers
        let wiresCF = allDigits[0]
        assert(wiresCF.count == 2)
        let wiresACF = allDigits[1]
        assert(wiresACF.count == 3)
        let wiresBCDF = allDigits[2]
        assert(wiresBCDF.count == 4)
        let wiresABCDEFG = allDigits[9]
        assert(wiresABCDEFG.count == 7)
        
        segmentToDisplay[wiresCF] = 1
        segmentToDisplay[wiresACF] = 7
        segmentToDisplay[wiresBCDF] = 4
        segmentToDisplay[wiresABCDEFG] = 8
        
        let fiveSegments = allDigits.filter { $0.count == 5 }
        var sixSegments = allDigits.filter { $0.count == 6 }

        // 6 is a 6-segment that doesn't contains wires CF
        let wiresABDEFGIndex = sixSegments.firstIndex { segments in
            !wiresCF.allSatisfy { segments.contains($0) }
        }!
        let wiresABDEFG = sixSegments.remove(at: wiresABDEFGIndex)
        segmentToDisplay[wiresABDEFG] = 6
        let wiresABCDFGIndex = sixSegments.firstIndex { segments in
            Set(segments).isSuperset(of: Set(wiresBCDF))
        }!
        let wiresABCDFG = sixSegments.remove(at: wiresABCDFGIndex)
        segmentToDisplay[wiresABCDFG] = 9
        assert(sixSegments.count == 1)
        let wiresABCEFG = sixSegments.first!
        segmentToDisplay[wiresABCEFG] = 0
        
        // 5 only has one difference between the 6 segment display, the other 5-segs have 2 differences
        let wiresABDFG = fiveSegments.first { segments in
            let difference = Set(wiresABDEFG).subtracting(Set(segments)).count
            return difference == 1
        }!
        segmentToDisplay[wiresABDFG] = 5
        let bitThatRepresentsE = Array(Set(wiresABDEFG).subtracting(Set(wiresABDFG))).first!
        let wiresACDEG = fiveSegments.first { segments in
            segments != wiresABDFG && segments.contains(bitThatRepresentsE)
        }!
        segmentToDisplay[wiresACDEG] = 2
        let wiresACDFG = fiveSegments.first { segments in
            segments != wiresABDFG && segments != wiresACDEG
        }!
        segmentToDisplay[wiresACDFG] = 3
    }
}

class SegmentDescrambler: ObservableObject {
    @Published var output = ""
    private var isDemo = false
    private let isPartTwo = true
    
    private var input: String
    init() {
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
        let lines = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
        
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
