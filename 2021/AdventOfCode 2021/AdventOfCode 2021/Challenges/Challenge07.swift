//
//  Challenge07.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/7/21.
//

import SwiftUI

class CrabSubFormations: ObservableObject {
    @Published var output = ""
    
    func solve() {
        output = "test"
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
