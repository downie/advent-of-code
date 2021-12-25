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
    private let isPartTwo = true
    private let partTwoGridMultiple = 5
    
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
    
    func risk(for point: Point) -> Int? {
        guard isPartTwo else {
            return riskMap[point]
        }
        let originPoint = Point(x: point.x % maxX, y: point.y % maxY)
        guard let originValue = riskMap[originPoint] else {
            return nil
        }
        let multipleX = point.x / maxX
        let multipleY = point.y / maxY
        if multipleX >= partTwoGridMultiple || multipleY >= partTwoGridMultiple {
            return nil
        }
        var totalSum = (originValue + multipleX + multipleY)
        while totalSum > 9 {
            totalSum -= 9
        }
        return totalSum
    }
    
    func solve() {
        let start = Point(x: 0, y: 0)
        let end: Point
        if isPartTwo {
            end = Point(x: (maxX * partTwoGridMultiple) - 1, y: (maxY * partTwoGridMultiple) - 1)
        } else {
            end = Point(x: maxX-1, y: maxY-1)
        }
        accumulatedRisk[start] = RiskTotal(risk: 0, from: start)
        
        var openSet = Set<Point>([start])
        var currentPoint = start

        while !openSet.isEmpty  {
            // The next point to expand is the lowest risk one. If there are multiple. chose the one closer to the exit.
            currentPoint = openSet.sorted { left, right in
                let leftExtraRisk = risk(for: left)
                let rightExtraRisk = risk(for: right)
                let leftRiskSoFar = accumulatedRisk[left]?.risk
                let rightRiskSoFar = accumulatedRisk[right]?.risk
                
                let leftValue: Int
                
                if let leftExtraRisk = leftExtraRisk, let leftRiskSoFar = leftRiskSoFar {
                    leftValue = leftExtraRisk + leftRiskSoFar + manhattanDistance(from: left, to: end)
                } else {
                    leftValue = Int.max
                }
                
                let rightValue: Int
                if let rightExtraRisk = rightExtraRisk, let rightRiskSoFar = rightRiskSoFar {
                    rightValue = rightExtraRisk + rightRiskSoFar + manhattanDistance(from: right, to: end)
                } else {
                    rightValue = Int.max
                }
                return leftValue < rightValue
            }.first!
//            print("current point is \(currentPoint)")
            if currentPoint == end {
                let totalRisk = accumulatedRisk[currentPoint]!
                output = "\(totalRisk.risk)"
                tracePath(from: totalRisk)
                return
            }
            openSet.remove(currentPoint)
            
            let currentRisk = accumulatedRisk[currentPoint]!

            for neighbor in currentPoint.adjacentPoints(includingDiagonals: false) where isInBounds(point: neighbor) {
                let totalRisk = currentRisk.risk + risk(for: neighbor)!
                if totalRisk < (accumulatedRisk[neighbor]?.risk ?? Int.max) {
                    accumulatedRisk[neighbor] = RiskTotal(risk: totalRisk, from: currentPoint)
                    openSet.insert(neighbor)
                }
            }
//            print(showRiskMap(accumulatedRisk))
        }
        
        print("Open set is emptied but we never got there?")
        
    }
    
    func isInBounds(point: Point) -> Bool {
        if isPartTwo {
            return point.x >= 0
            && point.x < maxX * partTwoGridMultiple
            && point.y >= 0
            && point.y < maxY * partTwoGridMultiple
        } else {
            return point.x >= 0
            && point.x < maxX
            && point.y >= 0
            && point.y < maxY
        }
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
        showRiskMap(accumulatedRisk)
    }
    
    func showRiskMap(_ accumulatedRisk: [Point: RiskTotal]) {
        let map = (0..<maxY).map { y in
            (0..<maxX)
                .map { x in accumulatedRisk[Point(x: x, y: y)]?.risk ?? -1 }
                .map(String.init)
                .map(pad(string:))
                .joined(separator: " ")
        }.joined(separator: "\n")
        print(map)
    }
    
    func pad(string: String) -> String {
        if string.count < 2 {
            return " \(string)"
        }
        return string
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
