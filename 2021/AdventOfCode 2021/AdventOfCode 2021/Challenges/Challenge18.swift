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

class SnailfishNumber: Equatable {
    static func == (lhs: SnailfishNumber, rhs: SnailfishNumber) -> Bool {
        lhs.value == rhs.value && lhs.left == rhs.left && lhs.right == rhs.right
    }
    
    let value: Int?
    let left: SnailfishNumber?
    let right: SnailfishNumber?
    
    init(_ value: Int) {
        self.value = value
        self.left = nil
        self.right = nil
    }
    
    static func value(_ value: Int) -> SnailfishNumber {
        .init(value)
    }
    
    init(left: SnailfishNumber, right: SnailfishNumber)  {
        self.value = nil
        self.left = left
        self.right = right
    }
    static func pair(left: SnailfishNumber, right: SnailfishNumber) -> SnailfishNumber {
        .init(left: left, right: right)
    }
    
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
        reduce(.pair(left: lhs, right: rhs))
    }
    
    private static func firstOverlyNestedNumber(in number: SnailfishNumber, depth: Int = 0) -> SnailfishNumber? {
        guard depth < 4 else {
            return number
        }
        if let left = number.left, let right = number.right {
            if let match = firstOverlyNestedNumber(in: left, depth: depth + 1) {
                return match
            } else if let match = firstOverlyNestedNumber(in: right, depth: depth + 1) {
                return match
            }
        }
        return nil
    }
    
    private static func firstPairWithALargeValue(in number: SnailfishNumber) -> SnailfishNumber? {
        nil
    }
    
    private static func reduce(_ number: SnailfishNumber) -> SnailfishNumber {
        if let pairToExplode = firstOverlyNestedNumber(in: number) {
//            guard case let .pair(left, right) = pairToExplode else {
//                fatalError()
//            }
//            switch (left, right) {
//            case let (.pair(innerLeft, innerRight), _):
//
//            case let (_ .pair(innerLeft, innerRight)):
//            }
        } else if let pairToSplit = firstPairWithALargeValue(in: number) {

        } else {
            return number
        }
        return number
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
