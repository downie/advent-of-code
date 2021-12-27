//
//  SolverState.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/27/21.
//

import Foundation

/// The UI state for running a Solver
class SolverState: ObservableObject {
    /// Should the solver ask for Demo input?
    @Published var isDemoInput = true {
        didSet {
            resetSolver()
        }
    }
    
    /// Is the solver attempting part two of the challenge?
    @Published var isPartTwo = false {
        didSet {
            resetSolver()
        }
    }
    
    /// The result of the solver attempting to solve the challenge
    @Published var output = ""
    
    /// True while the solver is running. False otherwise
    @Published var isSolving = false
    
    private var solver: Solver!
    private let solverType: Solver.Type
    private let generateInput: (Bool) -> String
    
    /// Create a SolverState that runs the given type of `Solver`
    /// - Parameters:
    ///   - type: The type of a `Solver` subclass to be run
    ///   - getInput: A method to fetch input for the `Solver`. It takes a single argument: a boolean that's true when the user is asking for demo input.
    init(type: Solver.Type, getInput: @escaping (Bool) -> String) {
        solverType = type
        generateInput = getInput
        resetSolver()
    }
    
    /// Re-create the solver given the new solver state. This is useful when switching inputs.
    func resetSolver() {
        let input = generateInput(isDemoInput)
        solver = solverType.init(input: input, isPartTwo: isPartTwo)
    }
    
    /// Tell the solver to start solving the challenge.
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
