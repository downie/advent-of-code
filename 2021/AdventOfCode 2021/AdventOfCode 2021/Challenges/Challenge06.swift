//
//  Challenge06.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/6/21.
//

import SwiftUI

private let demoInput = "3,4,3,1,2"

class LanternfishSim: ObservableObject {
    @Published var fish: [Int]
    private var day = 0
    
    init(isDemo: Bool = false) {
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

class FastLanternfishSim: ObservableObject {
    @Published var fishCount = 0
    private var day = 0
    // How many more fish will be born in `index` days
    // This could be a Deque
    private var spawnHorizon = Array(repeating: 0, count: 9)
    
    init(isDemo: Bool = false) {
        let input: String
        if !isDemo {
            let inputData = NSDataAsset(name: "06")!.data
            input = String(data: inputData, encoding: .utf8)!
        } else {
            input = demoInput
        }
        
        let fish = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .compactMap(Int.init)
        
        fishCount = fish.count
        
        fish.forEach { daysUntilSpawn in
            spawnHorizon[daysUntilSpawn] += 1
        }
    }
    
    func advanceFor(days: Int) {
        (0..<days).forEach { _ in
            incrementDay()
        }
    }
    
    private func incrementDay() {
        let newFishCount = spawnHorizon.first!
        var newHorizon = Array(spawnHorizon.dropFirst())
        // Babies go at index 8, at the end of the lsit
        newHorizon.append(newFishCount)
        fishCount += newFishCount
        // Adults go back to position 6
        newHorizon[6] += newFishCount
        
        spawnHorizon = newHorizon
        day += 1
    }
}

struct Challenge06: View {
    let simulationDurationInDays = 256
    @StateObject var simulation = FastLanternfishSim()
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        VStack {
            Text("After \(simulationDurationInDays), there are \(simulation.fishCount) fish.")
                .frame(minWidth: 200)
                .onAppear {
                    simulation.advanceFor(days: simulationDurationInDays)
                }
            Button {
                pasteboard.prepareForNewContents()
                let result = pasteboard.setString("\(simulation.fishCount)", forType: .string)
                print("copied? \(result)")
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }

        }
    }
}

struct Challenge06_Previews: PreviewProvider {
    static var previews: some View {
        Challenge06()
    }
}
