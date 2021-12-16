//
//  ContentView.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/5/21.
//

import SwiftUI

class DummyChallenge: ObservableObject {
    @Published var output = ""
    private let isDemo = true
    private let isPartTwo = false
    
    init() {
        let input: String
        if isDemo {
            input = "demoInput"
        } else {
            let inputData = NSDataAsset(name: "15")!.data
            input = String(data: inputData, encoding: .utf8)!
        }
        print(input)
    }
    
    func solve() {
        output = "Fake"
    }
}

struct ContentView: View {
    var body: some View {
        Challenge15()
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
