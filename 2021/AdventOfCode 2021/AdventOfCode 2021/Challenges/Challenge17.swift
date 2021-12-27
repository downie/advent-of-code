//
//  Challenge17.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

class BallisticSolver: Solver {
    override func solveOrThrow() throws -> String {
        let input = self.input.dropFirst("target area: ".count)
        let parts = input.components(separatedBy: ", ")
        let xRange = parts.first!.dropFirst("x=".count)
        let yRange = parts.last!.dropFirst("y=".count)
        let xParts = xRange.components(separatedBy: "..").compactMap(Int.init)
        let yParts = yRange.components(separatedBy: "..").compactMap(Int.init)
        let topLeft = Point(x: xParts.reduce(Int.max, min), y: yParts.reduce(Int.min, max))
        let bottomRight = Point(x: xParts.reduce(Int.min, max), y: yParts.reduce(Int.max, min))

        
        return "\(topLeft), \(bottomRight)"
    }
    
    static func isPoint(_ point: Point, between topLeft: Point, and bottomRight: Point) -> Bool {
        topLeft.x <= point.x
        && point.x <= bottomRight.x
        && bottomRight.y <= point.y
        && point.y <= topLeft.y 
    }
    
    static func trajectory(from start: Point, initialVelocity: Point, before bottomRight: Point) -> [Point] {
        var lastPoint = start
        var velocity = initialVelocity
        var points = [Point]()
        while lastPoint.x <= bottomRight.x && lastPoint.y >= bottomRight.y {
            if lastPoint != start {
                points.append(lastPoint)
            }
            lastPoint += velocity
            velocity += Point(x: velocity.x > 0 ? -1 : 0, y: -1)
        }

        return points
    }
    
    static func validXVelicities(topLeft: Point, bottomRight: Point) -> [Int] {
        let velocities = (topLeft.x...bottomRight.x).flatMap { endX -> [Int] in
            (0...endX).compactMap { startingSpeed -> Int? in
                var reverseSpeed = startingSpeed
                var position = endX
                while position > 0 {
                    reverseSpeed += 1
                    position -= reverseSpeed
                }
                if position == 0 {
                    return reverseSpeed
                } else {
                    return nil
                }
            }
        }
        return Set(velocities).sorted()
    }
    
    static func validYVelocities(topLeft: Point, bottomRight: Point) -> [Int] {
        let speedToZero = (bottomRight.y...topLeft.y).flatMap { endY -> [Int] in
            (endY...0).compactMap { startingSpeed -> Int? in
                var reverseSpeed = abs(startingSpeed)
                var position = endY
                while position < 0 && reverseSpeed > 0 {
                    position += reverseSpeed
                    reverseSpeed -= 1
                }
                if position == 0 {
                    return reverseSpeed  // and -reverse speed?
                }
                return nil
            }
        }
        return speedToZero
    }
}

class SolverState: ObservableObject {
    @Published var isDemoInput = true {
        didSet {
            resetSolver()
        }
    }
    
    @Published var isPartTwo = false {
        didSet {
            resetSolver()
        }
    }
    
    @Published var output = ""
    @Published var isSolving = false
    
    var solver: Solver!
    let solverType: Solver.Type
    
    init(type: Solver.Type) {
        solverType = type
        resetSolver()
    }
    
    func resetSolver() {
        let input: String
        if isDemoInput {
            input = "target area: x=20..30, y=-10..-5"
        } else {
            let inputData = NSDataAsset(name: "17")!.data
            input = String(data: inputData, encoding: .utf8)!
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        solver = solverType.init(input: input, isPartTwo: isPartTwo)
    }
    
    func solve() {
        isSolving = true
        solver.solve { [weak self] result in
            guard let self = self else { return }
            defer {
                self.isSolving = false
            }
            switch result {
            case .failure(let error):
                self.output = "Error: \(error.localizedDescription)"
            case .success(let result):
                self.output = result
            }
        }
    }
}

struct Challenge17: View {
    @StateObject var state = SolverState(type: BallisticSolver.self)
    
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        VStack {
            Toggle("Is Demo Input?", isOn: $state.isDemoInput)
            Toggle("Is Part Two?", isOn: $state.isPartTwo)
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
            Button("Solve") {
                state.solve()
            }.disabled(state.isSolving)
        }
        .frame(minWidth: 200)
    }
}

struct Challenge17_Previews: PreviewProvider {
    static var previews: some View {
        Challenge17()
    }
}
