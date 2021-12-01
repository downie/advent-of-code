import Cocoa

// Input parsing
let file = Bundle.main.url(forResource: "01", withExtension: "txt")!
var inputData = try! Data(contentsOf: file)
let inputString = String(data: inputData, encoding: .utf8)!

let input = inputString
    .components(separatedBy: .newlines)
    .compactMap(Int.init)

// Problem solving
let demoInput = [
    199,
    200,
    208,
    210,
    200,
    207,
    240,
    269,
    260,
    263
]
let demoOutput = 7

// MARK: - Part 1

func numberOfIncreases(in series: [Int]) -> Int {
    var increases = 0
    for index in series.startIndex.advanced(by: 1) ..< series.endIndex {
        let newValue = series[index]
        let oldValue = series[index.advanced(by: -1)]
        if newValue > oldValue {
            increases += 1
        }
    }
    return increases
}

assert(numberOfIncreases(in: demoInput) == demoOutput)


var result = numberOfIncreases(in: input)
print("Part 1: \(result)")


func numberOfIncreases(in series: [Int], windowSize: Int) -> Int {
    let size = max(windowSize, 1)
    var increases = 0
    for index in series.startIndex.advanced(by: size) ..< series.endIndex {
        let newSum = series[index.advanced(by: 1 - size)...index]
            .reduce(0, +)
        let oldSum = series[index.advanced(by: -size)...index.advanced(by: -1)]
            .reduce(0, +)
        if newSum > oldSum {
            increases += 1
        }
    }
    return increases
}
assert(numberOfIncreases(in: demoInput, windowSize: 3) == 5)

result = numberOfIncreases(in: input, windowSize: 3)
print("Part 2: \(result)")

