//
//  Challenge16.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/15/21.
//

import SwiftUI

class BitTwiddler: ObservableObject {
    @Published var output = ""
    private let isDemo = true
    private let isPartTwo = false
    
    init() {
        let input: String
        if isDemo {
            input = "demoInput"
        } else {
            let inputData = NSDataAsset(name: "16")!.data
            input = String(data: inputData, encoding: .utf8)!
        }
        print(input)
    }
    
    func solve() {
        output = "Fake"
    }
}

struct Packet: Equatable, Hashable {
    enum PacketType: Equatable, Hashable {
        case literal(value: Int)
        case operatorWith(packets: [Packet])
    }
    let version: Int
    let type: PacketType
}

class PacketDecoder {
    enum Error: Swift.Error {
        case notImplemented
    }
    
    func decode(hexadecimalString: String) throws -> Packet {
        throw Error.notImplemented
    }
}

class PacketAnalyzer {
    func sumVersions(of packet: Packet) -> Int {
        switch packet.type {
        case .literal:
            return packet.version
        case .operatorWith(let packets):
            return packets.map(sumVersions(of:)).reduce(0, +) + packet.version
        }
    }
}

struct Challenge16: View {
    @StateObject var state = BitTwiddler()
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

struct Challenge16_Previews: PreviewProvider {
    static var previews: some View {
        Challenge16()
    }
}
