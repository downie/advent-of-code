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
class SegmentDescrambler: ObservableObject {
    @Published var output = ""
    private var isDemo = true
    
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
