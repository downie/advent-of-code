//
//  Challenge18.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

class SnailfishSolver: Solver {
    override class var demoInput: String { """
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    """ }
    
    override func solveOrThrow() throws -> String {
        "Snailfishhhhhh"
    }
}

class SnailfishSolverState: ObservableObject {
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
    
    var value: Int?
    var left: SnailfishNumber?
    var right: SnailfishNumber?
    
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
        var workingNumber = number
        reduceInPlace(&workingNumber)
        return workingNumber
    }
    
    private static func reduceInPlace(_ number: inout SnailfishNumber) {
        if let pairToExplode = firstOverlyNestedNumber(in: number) {
            guard let left = pairToExplode.left, let right = pairToExplode.right else {
                fatalError()
            }
            
            if let innerRight = left.right?.value, let rightValue = right.value {
                pairToExplode.left = .value(0)
                pairToExplode.right = .value(rightValue + innerRight)
            } else if let leftValue = left.value, let innerLeft = right.left?.value {
                pairToExplode.left = .value(leftValue + innerLeft)
                pairToExplode.right = .value(0)
            }
            reduceInPlace(&number)
        }
    }
}

struct Challenge18: View {
    @StateObject var state = SnailfishSolverState()
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
