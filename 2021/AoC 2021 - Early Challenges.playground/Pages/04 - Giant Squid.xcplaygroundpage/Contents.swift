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
                    
                    if marks[row].allSatisfy({ $0 }) {
                        hasWon = true
                    } else if marks.map({ $0[column] }).allSatisfy({ $0 }) {
                        hasWon = true
                    }
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
        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    let numbers = sections[0].components(separatedBy: ",").compactMap(Int.init)
    let cards = sections[1...]
        .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .map(BingoCard.init(numberGrid:))
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
assert(winningCard.hasWon)


// MARK: - Part 1
func finalScoreFromWinningCard(_ input: String) -> Int {
    let (cards, numbers) = parseInput(string: input)
    var bingoCards = cards
    
    var winningCard: BingoCard?
    var lastNumber: Int?
    for number in numbers {
        for index in 0..<bingoCards.count {
            bingoCards[index].mark(number: number)
            if bingoCards[index].hasWon {
                winningCard = bingoCards[index]
                lastNumber = number
            }
        }
        
        if winningCard != nil {
            break
        }
    }
    
    guard let card = winningCard,
          let number = lastNumber else {
              return -1
          }
    return card.sumOfUnmarkedNumbers * number
}

assert(finalScoreFromWinningCard(demoInput) == 4512)

let file = Bundle.main.url(forResource: "04", withExtension: "txt")!
var inputData = try! Data(contentsOf: file)
let inputString = String(data: inputData, encoding: .utf8)!

let part1 = finalScoreFromWinningCard(inputString)
print("Part 1: \(part1)")

// MARK: - Part 2

func finalScoreFromLeastWinningestCard(_ input: String) -> Int {
    let (cards, numbers) = parseInput(string: input)
    var bingoCards = cards
    
    var mostRecentWinningCard: BingoCard?
    var lastNumber: Int?
    for number in numbers {
        for index in 0..<bingoCards.count {
            bingoCards[index].mark(number: number)
            if bingoCards[index].hasWon {
                mostRecentWinningCard = bingoCards[index]
                lastNumber = number
            }
        }
        
        if bingoCards.allSatisfy({ $0.hasWon }) {
            break
        }
    }
    
    guard let card = mostRecentWinningCard,
          let number = lastNumber else {
              return -1
          }
    return card.sumOfUnmarkedNumbers * number
}

let demoResult = finalScoreFromLeastWinningestCard(demoInput)
if demoResult == 1924 {
    print("hooray")
} else {
    print("boo: \(demoResult)")
}

let part2 = finalScoreFromLeastWinningestCard(inputString)
print("Part 2: \(part2)")
//: [Next](@next)
