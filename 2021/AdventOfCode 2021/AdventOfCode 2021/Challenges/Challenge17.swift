//
//  Challenge17.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

class BallisticSolver: Solver {
    override class var demoInput: String { "target area: x=20..30, y=-10..-5" }
    
    override func solveOrThrow() throws -> String {
        let input = self.input.dropFirst("target area: ".count)
        let parts = input.components(separatedBy: ", ")
        let xRange = parts.first!.dropFirst("x=".count)
        let yRange = parts.last!.dropFirst("y=".count)
        let xParts = xRange.components(separatedBy: "..").compactMap(Int.init)
        let yParts = yRange.components(separatedBy: "..").compactMap(Int.init)
        let topLeft = Point(x: xParts.reduce(Int.max, min), y: yParts.reduce(Int.min, max))
        let bottomRight = Point(x: xParts.reduce(Int.min, max), y: yParts.reduce(Int.max, min))

        let possibleX = Self.validXVelicities(topLeft: topLeft, bottomRight: bottomRight)
        let possibleY = Self.validYVelocities(topLeft: topLeft, bottomRight: bottomRight)
        print("x: \(possibleX)")
        print("y: \(possibleY)")
        let velocities = possibleX.flatMap { x -> [Point] in
            possibleY.map { Point(x: x, y: $0) }
        }
        
        let trajectories = velocities.map { velocity  -> (Point, [Point], Int) in
            let trajectory = Self.trajectory(from: .zero, initialVelocity: velocity, before: bottomRight)
            let highestPoint = trajectory.map { $0.y }.reduce(Int.min, max)
            return (velocity, trajectory, highestPoint)
        }
        
        let onesThatHitTheTarget = trajectories.filter { triplet -> Bool in
            let (_, trajectory, _) = triplet
            let hit = trajectory.first { point in
                Self.isPoint(point, between: topLeft, and: bottomRight)
            }
            return hit != nil
        }
        
        if isPartTwo {
            let points = """
            23,-10  25,-9   27,-5   29,-6   22,-6   21,-7   9,0     27,-7   24,-5
            25,-7   26,-6   25,-5   6,8     11,-2   20,-5   29,-10  6,3     28,-7
            8,0     30,-6   29,-8   20,-10  6,7     6,4     6,1     14,-4   21,-6
            26,-10  7,-1    7,7     8,-1    21,-9   6,2     20,-7   30,-10  14,-3
            20,-8   13,-2   7,3     28,-8   29,-9   15,-3   22,-5   26,-8   25,-8
            25,-6   15,-4   9,-2    15,-2   12,-2   28,-9   12,-3   24,-6   23,-7
            25,-10  7,8     11,-3   26,-7   7,1     23,-9   6,0     22,-10  27,-6
            8,1     22,-8   13,-4   7,6     28,-6   11,-4   12,-4   26,-9   7,4
            24,-10  23,-8   30,-8   7,0     9,-1    10,-1   26,-5   22,-9   6,5
            7,5     23,-6   28,-10  10,-2   11,-1   20,-9   14,-2   29,-7   13,-3
            23,-5   24,-8   27,-9   30,-7   28,-5   21,-10  7,9     6,6     21,-5
            27,-10  7,2     30,-9   21,-8   22,-7   24,-9   20,-6   6,9     29,-5
            8,-2    27,-8   30,-5   24,-7
            """
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .whitespacesAndNewlines)
                .compactMap { pairString -> Point? in
                    let points = pairString
                        .components(separatedBy: ",")
                        .compactMap(Int.init)
                    guard points.count == 2 else {
                        return nil
                    }
                    return Point(x: points[0], y: points[1])
                }
            print(Set(points).subtracting(Set(onesThatHitTheTarget.map { $0.0 })))
        }
       
        if isPartTwo {
            return "\(onesThatHitTheTarget.count)"
        } else {
            let highestPoint = onesThatHitTheTarget.reduce(onesThatHitTheTarget.first!) { bestSoFar, next in
                if bestSoFar.2 > next.2 {
                    return bestSoFar
                }
                return next
            }
            
            return "\(highestPoint.2)"
        }
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
        Array(bottomRight.y ... -bottomRight.y)
//        let speedToZero = (bottomRight.y...topLeft.y).flatMap { endY -> [Int] in
//            (endY...0).flatMap { startingSpeed -> [Int] in
//                var reverseSpeed = abs(startingSpeed)
//                var position = endY
//                while position < 0 && reverseSpeed >= 0 {
//                    position += reverseSpeed
//                    reverseSpeed -= 1
//                }
//                if reverseSpeed != 0 {
//                    reverseSpeed += 1
//                }
//                if position == 0 {
//                    return [reverseSpeed, -reverseSpeed]
//                }
//                return []
//            }
//        }
//        return Set(speedToZero).sorted()
    }
}
