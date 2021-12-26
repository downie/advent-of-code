//
//  Challenge05.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/5/21.
//

import SwiftUI

struct Point: Hashable {
    let x: Int
    let y: Int
}

extension Point {
    static let zero = Point(x: 0, y: 0)
}

extension Point: AdditiveArithmetic {
    static func - (lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

struct Line {
    let from: Point
    let to: Point
}

private let demoInput = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""


class HydrothermalVents: ObservableObject {
    @Published var output: String = "Loading..."
    
    private let lines: [Line]
    private var sparseOverlapCount = [Point: Int]()
    private let isPartTwo: Bool
    
    init(isDemo: Bool = false, isPartTwo: Bool = false) {
        self.isPartTwo = isPartTwo
        // Load the input
        let input: String
        if !isDemo {
            let inputData = NSDataAsset(name: "05")!.data
            input = String(data: inputData, encoding: .utf8)!
        } else {
            input = demoInput
        }
        
        // Parse it
        lines = Self.parseInput(string: input)
    }
    
    func solve() {
        output = "Counting overlaps..."
        computeSparseOverlap()
        let pointsOfOverlap = sparseOverlapCount
            .filter { (_, count) in
                count > 1
            }
            .count
        output = "\(pointsOfOverlap)"
    }
    
    private func computeSparseOverlap() {
        sparseOverlapCount = lines.reduce(into: [:]) { partialResult, line in
            let strideX: [Int]
            let strideY: [Int]
            
            if line.from.x == line.to.x {
                // vertical line
                let direction = line.from.y < line.to.y ? 1 : -1
                strideY = Array(stride(from: line.from.y, through: line.to.y, by: direction))
                strideX = Array(repeating: line.from.x, count: abs(line.to.y - line.from.y) + 1)
            } else if line.from.y == line.to.y {
                // horizontal line
                let direction = line.from.x < line.to.x ? 1 : -1
                strideY = Array(repeating: line.from.y, count: abs(line.to.x - line.from.x) + 1)
                strideX = Array(stride(from: line.from.x, through: line.to.x, by: direction))
            } else if isPartTwo{
                // diagonal line.
                let yDirection = line.from.y < line.to.y ? 1 : -1
                let xDirection = line.from.x < line.to.x ? 1 : -1
                strideY = Array(stride(from: line.from.y, through: line.to.y, by: yDirection))
                strideX = Array(stride(from: line.from.x, through: line.to.x, by: xDirection))
            } else {
                strideY = []
                strideX = []
            }
            assert(strideX.count == strideY.count)

            let points = zip(strideX, strideY)
                .map { Point(x: $0.0, y: $0.1) }
            partialResult = points.reduce(into: partialResult) { overlapCount, nextPoint in
                if let count = overlapCount[nextPoint] {
                    overlapCount[nextPoint] = count + 1
                } else {
                    overlapCount[nextPoint] = 1
                }
            }
        }
    }
    
    private static func parseInput(string: String) -> [Line] {
        string
            .components(separatedBy: .newlines)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { line in
                let points = line
                    .components(separatedBy: " -> ")
                    .map { pointString -> Point in
                        let coordinates = pointString
                            .components(separatedBy: ",")
                            .compactMap(Int.init)
                        return Point(x: coordinates[0], y: coordinates[1])
                    }
                return Line(from: points[0], to: points[1])
            }
    }
}

struct Challenge05: View {
    @StateObject var state = HydrothermalVents(isPartTwo: true)
    
    var body: some View {
        Text(state.output)
            .frame(minWidth: 200)
            .onAppear {
                state.solve()
            }
    }
}

struct Challenge05_Previews: PreviewProvider {
    static var previews: some View {
        Challenge05()
    }
}
