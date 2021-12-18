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

indirect enum SnailfishNumber: Equatable, Hashable {
    case value(_: Int)
    case pair(left: SnailfishNumber, right: SnailfishNumber)
    
    static func from(string: String) -> SnailfishNumber {
        if let number = Int(string, radix: 10) {
            return .value(number)
        }
        let array = try! JSONSerialization.jsonObject(with: string.data(using: .utf8)!, options: []) as! Array<Any>
        return number(from: array)
    }
    
    private static func number(from array: [Any]) -> SnailfishNumber {
        if let array = array as? [Int] {
            return .pair(left: .value(array[0]), right: .value(array[1]))
        }
        assert(array.count == 2)
        let left: SnailfishNumber
        if let leftNumber = array[0] as? Int {
            left = .value(leftNumber)
        } else {
            left = number(from: array[0] as! [Any])
        }
        
        let right: SnailfishNumber
        if let leftNumber = array[1] as? Int {
            right = .value(leftNumber)
        } else {
            right = number(from: array[1] as! [Any])
        }
        
        return .pair(left: left, right: right)
    }
    
    public static func +(lhs: SnailfishNumber, rhs: SnailfishNumber) -> SnailfishNumber {
        lhs
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
