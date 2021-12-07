//
//  Challenge07.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/7/21.
//

import SwiftUI

private let demoInput = "16,1,2,0,4,2,7,1,2,14"

class CrabSubFormations: ObservableObject {
    @Published var output = ""
    private let crabs: [Int]
    private let isDemo = true

    init() {
        let input: String
        if !isDemo {
            let inputData = NSDataAsset(name: "07")!.data
            input = String(data: inputData, encoding: .utf8)!
        } else {
            input = demoInput
        }
        
        crabs = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .compactMap(Int.init)
    }
    
    func solve() {
        let maxPosition = crabs.reduce(0, max)
        let bestPair = (0...maxPosition)
            .map { alignOnPosition -> (position: Int, cost: Int) in
                let cost = crabs
                    .map { abs(alignOnPosition - $0) }
                    .reduce(0, +)
                return (position: alignOnPosition, cost: cost)
            }
            .reduce((position: -1, cost: Int.max)) { bestPair, thisPair in
                if thisPair.cost < bestPair.cost {
                    return thisPair
                } else {
                    return bestPair
                }
            }
        
        output = "\(bestPair.cost)"
    }
}

struct Challenge07: View {
    @StateObject var state = CrabSubFormations()
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        VStack {
            Text(state.output)
                .frame(minWidth: 200)
                .onAppear {
                    state.solve()
                }
            Button {
                pasteboard.prepareForNewContents()
                _ = pasteboard.setString(state.output, forType: .string)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
        }
    }
}

struct Challenge07_Previews: PreviewProvider {
    static var previews: some View {
        Challenge07()
    }
}
