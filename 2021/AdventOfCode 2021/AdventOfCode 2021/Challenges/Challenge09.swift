//
//  Challenge09.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/9/21.
//

import SwiftUI
private let demoInput = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""

class SteamDepthmap: ObservableObject {
    @Published var output = ""
    private let depthGrid: [Point: Int]
    private let isDemo = true
    private let isPartOne = false
    
    init() {
        let input: String
        if !isDemo {
            let inputData = NSDataAsset(name: "09")!.data
            input = String(data: inputData, encoding: .utf8)!
        } else {
            input = demoInput
        }
        
        let allPoints = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .enumerated()
            .map { row, line in
                line
                    .enumerated()
                    .map { column, letter -> (Point, Int) in
                        let value = Int(String(letter))!
                        let point = Point(x: column, y: row)
                        return (point, value)
                    }
            }
            .flatMap { $0 }
        
        depthGrid = allPoints
            .reduce(into: [:]) { partialResult, pair in
                let (point, value) = pair
                partialResult[point] = value
            }
    }
    
    func depth(at point: Point) -> Int {
        depthGrid[point] ?? Int.max
    }
    
    func basinSize(from lowestPoint: Point) -> Int {
        var basin = Set([lowestPoint])
        var boundaryPoints = Set(
            [
                Point(x: lowestPoint.x, y: lowestPoint.y - 1),
                Point(x: lowestPoint.x, y: lowestPoint.y + 1),
                Point(x: lowestPoint.x - 1, y: lowestPoint.y),
                Point(x: lowestPoint.x + 1, y: lowestPoint.y),
            ].filter { depth(at: $0) < 9 }
        )
        
        while !boundaryPoints.isEmpty {
            basin = basin.union(boundaryPoints)
            
            let newBoundary = boundaryPoints
                .flatMap { point in
                    [
                        Point(x: point.x, y: point.y - 1),
                        Point(x: point.x, y: point.y + 1),
                        Point(x: point.x - 1, y: point.y),
                        Point(x: point.x + 1, y: point.y),
                    ]
                        .filter { !basin.contains($0) }
                        .filter { depth(at: $0) < 9 }
                }
            boundaryPoints = Set(newBoundary)
        }
        return basin.count
    }
    
    func solve() {
        let lowestPoints = depthGrid
            .keys
            .filter { point in
                let above = Point(x: point.x, y: point.y - 1)
                let below = Point(x: point.x, y: point.y + 1)
                let left  = Point(x: point.x - 1, y: point.y)
                let right = Point(x: point.x + 1, y: point.y)
                
                let thisDepth = depth(at: point)
                return thisDepth < depth(at: above)
                && thisDepth < depth(at: below)
                && thisDepth < depth(at: left)
                && thisDepth < depth(at: right)
            }
        if isPartOne {
            let result = lowestPoints
                .map(depth(at:))
                .map { $0 + 1 }
                .reduce(0, +)
            output = "\(result)"
        } else {
            let threeLargestBasins = lowestPoints.map { point -> (Point, Int) in
                (point, basinSize(from: point))
            }
            .sorted { left, right in
                left.1 > right.1
            }[0..<3]
            
            let product = threeLargestBasins
                .map { $0.1 }
                .reduce(1, *)
            output = "\(product)"
        }
    }
}

struct Challenge09: View {
    @StateObject var state = SteamDepthmap()
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

struct Challenge09_Previews: PreviewProvider {
    static var previews: some View {
        Challenge09()
    }
}
