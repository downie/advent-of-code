//
//  Challenge25.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

struct Challenge25: View {
    @StateObject var state = DummyChallenge()
    let pasteboard = NSPasteboard.general
    
    var body: some View {
        VStack {
            Text(state.output)
                .font(.system(.body, design: .monospaced))
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
        .frame(minWidth: 200)
    }
}

struct Challenge25_Previews: PreviewProvider {
    static var previews: some View {
        Challenge25()
    }
}
