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
    @State var selectedChallenge: Int? = 15

    var body: some View {
        NavigationView {
            ForEach(5..<26) { number in
                NavigationLink("\(number)", tag: number, selection: $selectedChallenge) {
                    challengeView(for: number)
                }
            }
            Text("Nothing Selected")
        }
        .padding()
    }
    
    func challengeView(for number: Int) -> AnyView {
        let view: AnyView
        switch number {
        case 05: view = AnyView(Challenge05())
        case 06: view = AnyView(Challenge06())
        case 07: view = AnyView(Challenge07())
        case 08: view = AnyView(Challenge08())
        case 09: view = AnyView(Challenge09())
        case 10: view = AnyView(Challenge10())
        case 11: view = AnyView(Challenge11())
        case 12: view = AnyView(Challenge12())
        case 13: view = AnyView(Challenge13())
        case 14: view = AnyView(Challenge14())
        case 15: view = AnyView(Challenge15())
        case 16: view = AnyView(Challenge16())
        case 17: view = AnyView(Challenge17())
        case 18: view = AnyView(Challenge18())
        case 19: view = AnyView(Challenge19())
        case 20: view = AnyView(Challenge20())
        case 21: view = AnyView(Challenge21())
        case 22: view = AnyView(Challenge22())
        case 23: view = AnyView(Challenge23())
        case 24: view = AnyView(Challenge24())
        case 25: view = AnyView(Challenge25())
        default: view = AnyView(EmptyView())
        }
        return view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
