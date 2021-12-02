//: [Previous](@previous)

import Foundation

struct Position: Equatable {
    var horizontal: Int
    var depth: Int
}

enum Direction: String {
    case forward, down, up
}

struct Command {
    let direction: Direction
    let distance: Int
}

// MARK: - Puzzle methods
func parseInput(string: String) -> [Command] {
    let lines = string.components(separatedBy: .newlines)
    return lines.compactMap { line in
        let parts = line.components(separatedBy: " ")
        guard parts.count == 2 else {
            return nil
        }
        let direction = Direction(rawValue: parts[0])!
        let distance = Int(parts[1])!
        return Command(direction: direction, distance: distance)
    }
}

func finalPosition(after commands: [Command]) -> Position {
    var position =
    commands.reduce(Position(horizontal: 0, depth: 0)) { partialResult, command in
        var horizontal = partialResult.horizontal
        var depth = partialResult.depth
        switch command.direction {
        case .forward:
            horizontal += command.distance
        case .down:
            depth += command.distance
        case .up:
            depth -= command.distance
        }
        return Position(horizontal: horizontal, depth: depth)
    }
    return position
}

// MARK: - Demo Input
var demoInput = """
forward 5
down 5
forward 8
up 3
down 8
forward 2
"""
var demoOutput = Position(horizontal: 15, depth: 10)

var commands = parseInput(string: demoInput)
let demoResult = finalPosition(after: commands)
assert(demoResult == demoOutput)

// MARK: - Part 1
let file = Bundle.main.url(forResource: "02", withExtension: "txt")!
var inputData = try! Data(contentsOf: file)
let inputString = String(data: inputData, encoding: .utf8)!

commands = parseInput(string: inputString)
let part1Result = finalPosition(after: commands)

print(part1Result.horizontal * part1Result.depth)
//: [Next](@next)
