//: [Previous](@previous)

import Foundation

struct Position: Equatable {
    var horizontal = 0
    var depth = 0
    var aim = 0
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

func partOneFinalPosition(after commands: [Command]) -> Position {
    let position =
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

let demoCommands = parseInput(string: demoInput)
let demoResult = partOneFinalPosition(after: demoCommands)
assert(demoResult == demoOutput)

// MARK: - Part 1
let file = Bundle.main.url(forResource: "02", withExtension: "txt")!
var inputData = try! Data(contentsOf: file)
let inputString = String(data: inputData, encoding: .utf8)!

let commands = parseInput(string: inputString)
let part1Result = partOneFinalPosition(after: commands)

print("Part 1: \(part1Result.horizontal * part1Result.depth)")

// MARK: - Part 2

func partTwoFinalPosition(after commands: [Command]) -> Position {
    let position =
    commands.reduce(Position(horizontal: 0, depth: 0)) { partialResult, command in
        var horizontal = partialResult.horizontal
        var depth = partialResult.depth
        var aim = partialResult.aim
        switch command.direction {
        case .forward:
            horizontal += command.distance
            depth += aim * command.distance
        case .down:
            aim += command.distance
        case .up:
            aim -= command.distance
        }
        return Position(horizontal: horizontal, depth: depth, aim: aim)
    }
    return position
}

let partTwoDemoResult = partTwoFinalPosition(after: demoCommands)
assert(partTwoDemoResult.horizontal == 15)
assert(partTwoDemoResult.depth == 60)

let partTwoResult = partTwoFinalPosition(after: commands)
print("Part 2: \(partTwoResult.horizontal * partTwoResult.depth)")

//: [Next](@next)
