//
//  Challenge17.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

class BallisticSolver: Solver {
    
}

class SolverState: ObservableObject {
    @Published var isDemoInput = true {
        didSet {
            restartSolver()
            Task { await solve() }
        }
    }
    @Published var isPartTwo = false {
        didSet {
            restartSolver()
            Task { await solve() }
        }
    }
    @Published var output = ""
    
    var solver: Solver?
    let solverType: Solver.Type
    
    init(type: Solver.Type) {
        solverType = type
        restartSolver()
    }
    
    func restartSolver() {
        solver?.cancel()
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
    
    @MainActor
    func solve() async {
        guard let solver = solver else {
            output = "No solver present."
            return
        }

        do {
            output = try await solver.solve()
        } catch {
            output = "Error: \(error.localizedDescription)"
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
                    solveChallenge()
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
    
    func solveChallenge() {
        Task {
            await state.solve()
        }
    }
}

struct Challenge17_Previews: PreviewProvider {
    static var previews: some View {
        Challenge17()
    }
}
