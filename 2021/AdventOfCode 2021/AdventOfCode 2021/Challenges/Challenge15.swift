//
//  Challenge15.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

private let demoInput = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581

"""

class PathFinder: ObservableObject {
    @Published var output = ""
    private let isDemo = true
    private let isPartTwo = false
    
    let maxX: Int
    let maxY: Int
    
    let riskMap: [Point: Int]
    var accumulatedRisk = [Point: RiskTotal]()
    
    struct RiskTotal: Equatable, Hashable {
        let risk: Int
        let from: Point
    }

    init() {
        let input: String
        if isDemo {
            input = demoInput
        } else {
            let inputData = NSDataAsset(name: "15")!.data
            input = String(data: inputData, encoding: .utf8)!
        }
        
        let lines = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
        maxX = lines.first!.count
        maxY = lines.count
        
        riskMap = lines.enumerated().reduce(into: [Point: Int]()) { partialResult, pair in
            let y = pair.offset
            let line = pair.element
            partialResult = line.enumerated().reduce(into: partialResult) { partialResult, innerPair in
                let x = innerPair.offset
                let risk = Int(String(innerPair.element))!
                partialResult[Point(x: x, y: y)] = risk
            }
        }
    }
    
    func solve() {
        let start = Point(x: 0, y: 0)
        let end = Point(x: maxX-1, y: maxY-1)
        accumulatedRisk[start] = RiskTotal(risk: 0, from: start)
        
        var openSet = Set<Point>([start])
        var currentPoint = start

        while !openSet.isEmpty  {
            // The next point to expand is the lowest risk one. If there are multiple. chose the one closer to the exit.
            currentPoint = openSet.sorted { left, right in
                let leftRisk = riskMap[left, default: Int.max]
                let rightRisk = riskMap[right, default: Int.max]
                if leftRisk == rightRisk {
                    return manhattanDistance(from: left, to: end) < manhattanDistance(from: right, to: end)
                } else {
                    return leftRisk < rightRisk
                }
            }.first!
            print("current point is \(currentPoint)")
            if currentPoint == end {
                let totalRisk = accumulatedRisk[currentPoint]!
                output = "\(totalRisk.risk)"
                tracePath(from: totalRisk)
                return
            }
            openSet.remove(currentPoint)
            
            let currentRisk = accumulatedRisk[currentPoint]!

            for neighbor in currentPoint.adjacentPoints(includingDiagonals: false) where neighbor.x >= 0 && neighbor.x < maxX && neighbor.y >= 0 && neighbor.y < maxY {
                let totalRisk = currentRisk.risk + riskMap[neighbor]!
                if totalRisk < (accumulatedRisk[neighbor]?.risk ?? Int.max) {
                    accumulatedRisk[neighbor] = RiskTotal(risk: totalRisk, from: currentPoint)
                    openSet.insert(neighbor)
                }
            }
        }
        
        print("Open set is emptied but we never got there?")
        
    }
    
    func manhattanDistance(from: Point, to: Point) -> Int {
        abs(from.x - to.x) + abs(from.y - to.y)
    }

    func tracePath(from end: RiskTotal) {
        var output = [String]()
        var riskPointer = end
        while riskPointer.from != Point(x: 0, y: 0) {
            output.append("\(riskPointer.risk) from \(riskPointer.from)")
            riskPointer = accumulatedRisk[riskPointer.from]!
        }
        
        print(output.reversed().joined(separator: "\n"))
        
        let map = (0..<maxY).map { y in
            (0..<maxX)
                .map { x in accumulatedRisk[Point(x: x, y: y)]?.risk ?? -1 }
                .map(String.init)
                .joined(separator: " ")
        }.joined(separator: "\n")
        print(map)
    }
}

struct Challenge15: View {
    @StateObject var state = PathFinder()
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

struct Challenge15_Previews: PreviewProvider {
    static var previews: some View {
        Challenge15()
    }
}
