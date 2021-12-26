//
//  Challenge17.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

class BallisticSolver: Solver {
//    override func solveOrThrow() throws -> String {
//        let input = self.input.dropFirst("target area: ".count)
//        let parts = input.components(separatedBy: ", ")
//        let xRange = parts.first!.dropFirst("x=".count)
//        let yRange = parts.last!.dropFirst("y=".count)
//        let xParts = xRange.components(separatedBy: "..").compactMap(Int.init)
//        let yParts = yRange.components(separatedBy: "..").compactMap(Int.init)
//        let topLeft = Point(x: xParts.first!, y: yParts.first!)
//        let bottomRight = Point(x: xParts.last!, y: yParts.last!)
//
//        return "\(topLeft), \(bottomRight)"
//    }
}

class SolverState: ObservableObject {
    @Published var isDemoInput = true {
        didSet {
            restartSolver()
        }
    }
    
    @Published var isPartTwo = false {
        didSet {
            restartSolver()
        }
    }
    
    @Published var output = ""
    
    var solver: Solver!
    let solverType: Solver.Type
    
    init(type: Solver.Type) {
        solverType = type
        restartSolver()
    }
    
    func restartSolver() {
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
        solver.solve { result in
            switch result {
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            case .success(let result):
                print("Solved with result: \(result)")
            }
        }
    }
    
//    @MainActor
//    func solve() async {
//        guard let solver = solver else {
//            output = "No solver present."
//            return
//        }
//
//        do {
//            output = try await solver.solve()
//        } catch {
//            output = "Error: \(error.localizedDescription)"
//        }
//    }
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
            }.disabled(true)
        }
        .frame(minWidth: 200)
    }
}

struct Challenge17_Previews: PreviewProvider {
    static var previews: some View {
        Challenge17()
    }
}
