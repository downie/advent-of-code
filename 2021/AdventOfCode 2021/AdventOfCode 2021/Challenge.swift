//
//  Challenge.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/26/21.
//

import Foundation

private let sharedChallengeBackgroundQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "background"
    return queue
}()

class Challenge {
    enum Error: Swift.Error {
        case notImplemented
    }
    private let queue: OperationQueue
    
    init(input: String, queue: OperationQueue = sharedChallengeBackgroundQueue) {
        self.queue = queue
    }
    
    func solve(completion: @escaping (Result<String, Swift.Error>) -> Void) {
        OperationQueue.main.addOperation {
            completion(.failure(Error.notImplemented))
        }
    }
    
    func solve() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            solve { result in
                continuation.resume(with: result)
            }
        }
    }
}
