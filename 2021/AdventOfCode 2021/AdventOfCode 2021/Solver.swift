//
//  Solver.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/26/21.
//

import Foundation
import os

private let solverQueue = OperationQueue()

public class Solver {
    private let backgroundQueue = solverQueue
    private let logger: Logger
    private let isPartTwo: Bool
    private var task: Task<String, Error>?
    private let input: String
    
    required public init(input: String, isPartTwo: Bool, logger: Logger = Logger()) {
        self.input = input
        self.isPartTwo = isPartTwo
        self.logger = logger
    }
    
    /// Runs the solver on a background thread. The completion handler is called when a result is reached.
    /// - Parameter completion: Called when this solver has completed its work.
    public final func solve(completion: @escaping (Result<String, Error>) -> Void) {
        let operation = BlockOperation { [weak self] in
            guard let self = self else {
                return
            }
            
            do {
                let result = try self.solveOrThrow()
                OperationQueue.main.addOperation {
                    completion(.success(result))
                }
            } catch {
                OperationQueue.main.addOperation {
                    completion(.failure(error))
                }
            }
        }
        backgroundQueue.addOperation(operation)
    }
    
    // Override these
    func solveOrThrow() throws -> String {
        """
        Part \(isPartTwo ? 2 : 1): Not Implemented
        Input: \(input)
        """
    }
}

// Async/Await interface
extension Solver {
    public func solve() async throws -> String {
        let task = Task(priority: .userInitiated, operation: {
            try solveOrThrow()
        })
        self.task = task
        return try await task.value
    }
//    Dropping cancellation support for now.
    public func cancel() {
        task?.cancel()
        task = nil
    }
}
