//
//  Challenge18.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

class SnailfishSolver: ObservableObject {
    @Published var output = ""
    
    private let isPartTwo: Bool
    private let input: String
    
    init(demoInput: String? = nil, isPartTwo: Bool = false) {
        self.isPartTwo = isPartTwo
        if let demoInput = demoInput {
            input = demoInput
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            let inputData = NSDataAsset(name: "16")!.data
            input = String(data: inputData, encoding: .utf8)!
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func solve() {
        output = "Snailfish"
    }
}

indirect enum SnailfishNumber {
    case value(_: Int)
    case pair(left: SnailfishNumber, right: SnailfishNumber)
    
    static func from(string: String) -> SnailfishNumber {
        .value(0)
    }
}

struct Challenge18: View {
    @StateObject var state = SnailfishSolver()
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

struct Challenge18_Previews: PreviewProvider {
    static var previews: some View {
        Challenge18()
    }
}
