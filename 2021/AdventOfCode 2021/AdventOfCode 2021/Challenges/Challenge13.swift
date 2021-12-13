//
//  Challenge13.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/13/21.
//

import SwiftUI

private let demoInput = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5

"""

enum Fold {
    case up(yAxis: Int)
    case left(xAxis: Int)
}

class PaperFlipper: ObservableObject {
    @Published var output = ""
    private let isDemo = true
    private let isPartTwo = false
    
    private var dots = Set<Point>()
    private var folds = [Fold]()
    
    init() {
        let input: String
        if isDemo {
            input = demoInput
        } else {
            let inputData = NSDataAsset(name: "13")!.data
            input = String(data: inputData, encoding: .utf8)!
        }
        
        let parts = input
            .trimmingCharacters(in: .newlines)
            .components(separatedBy: "\n\n")
        dots = parts[0]
            .components(separatedBy: .newlines)
            .map { line -> Point in
                let points = line.components(separatedBy: ",")
                return Point(x: Int(points[0])!, y: Int(points[1])!)
            }
            .reduce(into: Set<Point>()) { partialResult, nextPoint in
                partialResult.insert(nextPoint)
            }
        folds = parts[1]
            .components(separatedBy: .newlines)
            .map { $0.dropFirst("fold along ".count) }
            .map { line -> Fold in
                let pair = line.components(separatedBy: "=")
                switch pair[0] {
                case "x":
                    return .left(xAxis: Int(pair[1])!)
                case "y":
                    return .up(yAxis: Int(pair[1])!)
                default:
                    fatalError()
                }
            }
    }
    
    
    func solve() {
        if isPartTwo {
            
        } else {
            // just do the first fold
            let result = fold(points: dots, folding: folds.first!)
            output = "\(result.count)"
        }
    }
    
    private func fold(points: Set<Point>, folding: Fold) -> Set<Point> {
        let pointsToMove = points.filter { point in
            switch folding {
            case .up(let yAxis):
                return point.y > yAxis
            case .left(let xAxis):
                return point.x > xAxis
            }
        }
        
        let movedPoints = points.map { point -> Point in
            switch folding {
            case .up(let yAxis):
                let distance = point.y - yAxis
                let newY = point.y - distance
                return Point(x: point.x, y: newY)
            case .left(let xAxis):
                let distance = point.x - xAxis
                let newX = point.x - distance
                return Point(x: newX, y: point.y)
            }
        }
        
        let newSet = points.subtracting(pointsToMove).union(movedPoints)
        return newSet
    }
}

struct Challenge13: View {
    @StateObject var state = PaperFlipper()
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

struct Challenge13_Previews: PreviewProvider {
    static var previews: some View {
        Challenge13()
    }
}
