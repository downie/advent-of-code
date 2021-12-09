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
//    private let size: CGSize
    
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
//        size = allPoints.reduce(CGSize.zero) { partialResult, pair in
//            let (point, _) = pair
//            let width = max(point.x, partialResult.width)
//            let height = max(point.y, partialResult.height)
//            return CGSize(width: width, height: height)
//        }
    }
    
    func depth(at point: Point) -> Int {
        depthGrid[point] ?? Int.max
    }
    
    func solve() {
        let result = depthGrid
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
            .map(depth(at:))
            .map { $0 + 1 }
            .reduce(0, +)
        output = "\(result)"
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
