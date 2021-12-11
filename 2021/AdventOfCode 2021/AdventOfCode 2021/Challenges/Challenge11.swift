//
//  Challenge11.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/11/21.
//

import SwiftUI
private let demoInput = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526

"""

extension Point {
    func adjacentPoints(includingDiagonals: Bool) -> [Point] {
        let cardinals = [
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x, y: y - 1),
            Point(x: x, y: y + 1)
        ]
        guard includingDiagonals else {
            return cardinals
        }
        let diagonals = [
            Point(x: x - 1, y: y - 1),
            Point(x: x - 1, y: y + 1),
            Point(x: x + 1, y: y - 1),
            Point(x: x + 1, y: y + 1)
        ]
        return [cardinals, diagonals].flatMap { $0 }
    }
}

class OctopusLightShow: ObservableObject {
    @Published var output = ""
    var steps = 100
    private var flashes = 0
    private let isDemo = false
    private var energyGrid: [Point: Int]
    
    init() {
        let input: String
        if !isDemo {
            let inputData = NSDataAsset(name: "11")!.data
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
        
        energyGrid = allPoints
            .reduce(into: [:]) { partialResult, pair in
                let (point, value) = pair
                partialResult[point] = value
            }
    }

    func solve() {
        for _ in 0..<steps {
            var nextGrid = [Point: Int]()
            var flashesToResolve = Set<Point>()
            var resolvedFlashes = Set<Point>()
            
            // Increment
            for (key, value) in energyGrid {
                let newValue = value + 1
                nextGrid[key] = newValue
                
                if newValue > 9 {
                    flashesToResolve.insert(key)
                }
            }
            
            while !flashesToResolve.isEmpty {
                let flash = flashesToResolve.removeFirst()
                flashes += 1
                resolvedFlashes.insert(flash)
                
                flash.adjacentPoints(includingDiagonals: true).forEach { point in
                    guard let oldValue = nextGrid[point] else {
                        return
                    }
                    let newValue = oldValue + 1
                    nextGrid[point] = newValue
                    if newValue > 9 && !resolvedFlashes.contains(point) {
                        flashesToResolve.insert(point)
                    }
                }
            }
            
            resolvedFlashes.forEach { point in
                nextGrid[point] = 0
            }
            energyGrid = nextGrid
        }
        
        output = "\(flashes)"
    }
}

struct Challenge11: View {
    @StateObject var state = OctopusLightShow()
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

struct Challenge11_Previews: PreviewProvider {
    static var previews: some View {
        Challenge11()
    }
}
