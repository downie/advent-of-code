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
    private let isDemo = false
    private let isPartTwo = true
    
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
            let result = folds.reduce(into: dots) { updatedDots, nextFold in
                updatedDots = fold(points: updatedDots, folding: nextFold)
            }
            output = display(dots: result)
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
//        print("fold is \(folding)")
        let movedPoints = pointsToMove.map { point -> Point in
            let newPoint: Point
            switch folding {
            case .up(let yAxis):
                let distance = point.y - yAxis
                let newY = yAxis - distance
                newPoint = Point(x: point.x, y: newY)
            case .left(let xAxis):
                let distance = point.x - xAxis
                let newX = xAxis - distance
                newPoint = Point(x: newX, y: point.y)
            }
//            print("Moving \(point) to \(newPoint)")
            return newPoint
        }
        
        let newSet = points.subtracting(pointsToMove).union(movedPoints)
        return newSet
    }
    
    private func display(dots: Set<Point>) -> String {
        let topLeft = dots.reduce(into: Point(x: 0, y: 0)) { lowestPoint, nextPoint in
            let x = min(lowestPoint.x, nextPoint.x)
            let y = min(lowestPoint.y, nextPoint.y)
            lowestPoint = Point(x: x, y: y)
        }
        let bottomRight = dots.reduce(into: Point(x: 0, y: 0)) { highestPoint, nextPoint in
            let x = max(highestPoint.x, nextPoint.x)
            let y = max(highestPoint.y, nextPoint.y)
            highestPoint = Point(x: x, y: y)
        }
        
        let lines = (topLeft.y...bottomRight.y)
            .map { y -> String in
                let letters = (topLeft.x...bottomRight.x).map { x -> Character in
                    if dots.contains(Point(x: x, y: y)) {
                        return "#"
                    }
                    return "."
                }
                return String(letters)
            }
        return lines.joined(separator: "\n")
    }
}

struct Challenge13: View {
    @StateObject var state = PaperFlipper()
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

struct Challenge13_Previews: PreviewProvider {
    static var previews: some View {
        Challenge13()
    }
}
