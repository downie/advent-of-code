//: [Previous](@previous)

import Foundation

struct BingoCard {
    var hasWon = false
    
    var sumOfUnmarkedNumbers: Int {
        var sum = 0
        for row in 0..<grid.count {
            for column in 0..<grid.count {
                if !marks[row][column] {
                    sum += grid[row][column]
                }
            }
        }
        return sum
    }
    private let grid: [[Int]]
    private var marks: [[Bool]]
    
    init(numberGrid: String) {
        print(numberGrid)
        grid = numberGrid
            .components(separatedBy: .newlines)
            .map { row in
                row
                    .components(separatedBy: .whitespaces)
                    .compactMap(Int.init)
            }

        let size = grid.count
        marks = Array(repeating: Array(repeating: false, count: size), count: size)
    }
    
    mutating func mark(number: Int) {
        for row in 0..<grid.count {
            for column in 0..<grid.count {
                if grid[row][column] == number {
                    marks[row][column] = true
                    // check for win condition.
                    return
                }
            }
        }
    }
}

let demoInput = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

func parseInput(string: String) -> ([BingoCard], [Int]) {
    let sections = string.components(separatedBy: "\n\n")
    let numbers = sections[0].components(separatedBy: ",").compactMap(Int.init)
    let cards = sections[1...].map(BingoCard.init(numberGrid:))
    return (cards, numbers)
}

parseInput(string: demoInput)

// Testing calculations
var winningCard = BingoCard(numberGrid: """
14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
""")
[14, 21, 17, 24, 4, 9, 23, 11, 5, 2, 0, 7].forEach { winningCard.mark(number: $0) }
assert(winningCard.sumOfUnmarkedNumbers == 188)

//: [Next](@next)
