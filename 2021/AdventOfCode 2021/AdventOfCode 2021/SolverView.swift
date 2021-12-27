//
//  SolverView.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/27/21.
//

import SwiftUI

struct SolverView: View {
    @StateObject var state: SolverState
    
    init(solverType: Solver.Type, getInput: @escaping (Bool) -> String) {
        _state = StateObject(wrappedValue: SolverState(type: solverType, getInput: getInput))
    }
    
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        VStack {
            HStack {
                Toggle("Is Demo Input?", isOn: $state.isDemoInput)
                Toggle("Is Part Two?", isOn: $state.isPartTwo)
                Spacer()
                Button("Solve") {
                    state.solve()
                }.disabled(state.isSolving)
            }
            Spacer()
            if state.isSolving {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Text(state.output)
                    .font(.system(.body, design: .monospaced))
            }
            Button {
                pasteboard.prepareForNewContents()
                _ = pasteboard.setString(state.output, forType: .string)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            .disabled(state.isSolving)
            Spacer()
        }
        .padding()
        .frame(minWidth: 200)
        .onAppear {
            state.solve()
        }
    }
}

struct SolverView_Previews: PreviewProvider {
    class DummySolver: Solver {
        override func solveOrThrow() throws -> String {
            "Part \(isPartTwo ? 2 : 1): \(input)"
        }
    }
    static var previews: some View {
        SolverView(solverType: DummySolver.self) { isDemo in
            isDemo ? "demo" : "real input"
        }
    }
}
