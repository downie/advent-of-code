//
//  Challenge06.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/6/21.
//

import SwiftUI

class LanternfishSim: ObservableObject {
    @Published var fish: [Int]
    private let demoInput = "3,4,3,1,2"
    private var day = 0
    
    init(isDemo: Bool = false, isPartTwo: Bool = false) {
        let input: String
        if !isDemo {
            let inputData = NSDataAsset(name: "06")!.data
            input = String(data: inputData, encoding: .utf8)!
        } else {
            input = demoInput
        }
        
        fish = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .compactMap(Int.init)
    }
    
    func advanceFor(days: Int) {
        (0..<days).forEach { _ in
            incrementDay()
        }
    }
    
    private func incrementDay() {
        let newFishCount = fish.filter { $0 == 0 }.count
        var newFish = fish.map { daysTilBirth -> Int in
            if daysTilBirth == 0 {
                return 6
            }
            return daysTilBirth - 1
        }
        newFish.append(contentsOf: Array(repeating: 8, count: newFishCount))
        
        fish = newFish
        day += 1
    }
}

struct Challenge06: View {
    let simulationDurationInDays = 80
    @StateObject var simulation = LanternfishSim()
    
    var body: some View {
        Text("After \(simulationDurationInDays), there are \(simulation.fish.count) fish.")
            .frame(minWidth: 200)
            .onAppear {
                simulation.advanceFor(days: simulationDurationInDays)
            }
    }
}

struct Challenge06_Previews: PreviewProvider {
    static var previews: some View {
        Challenge06()
    }
}
