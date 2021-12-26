//
//  Solver.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/26/21.
//

import Foundation
import os

public class Solver {
    private let logger: Logger
    private let isPartTwo: Bool
    private var task: Task<String, Error>?
    private let input: String

    required public init(input: String, isPartTwo: Bool, logger: Logger = Logger()) {
        self.input = input
        self.isPartTwo = isPartTwo
        self.logger = logger
    }
    
    public func solve() async throws -> String {
        let task = Task(priority: .userInitiated, operation: {
            try solveOrThrow()
        })
        self.task = task
        return try await task.value
    }
    
    public func cancel() {
        task?.cancel()
        task = nil
    }
    
    // Override these
    func solveOrThrow() throws -> String {
        """
        Part \(isPartTwo ? 2 : 1): Not Implemented
        Input: \(input)
        """
    }
}
