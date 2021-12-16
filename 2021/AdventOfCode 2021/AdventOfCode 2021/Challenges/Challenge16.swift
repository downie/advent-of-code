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


struct BitStream {
    struct Cursor {
        let chunkIndex: Int
        let bitIndex: Int
        
        func distance(from otherCursor: Cursor) -> Int {
            abs((BitStream.chunkSize * chunkIndex + bitIndex) - (BitStream.chunkSize * otherCursor.chunkIndex + otherCursor.bitIndex))
        }
    }
    
    private let allBits: [UInt64]
    private static let chunkSize = 64 // bits
    var chunkIndex = 0
    var bitIndex = 0
    
    init(bits: [UInt64]) {
        allBits = bits
    }
    
    var cursor: Cursor {
        Cursor(chunkIndex: chunkIndex, bitIndex: bitIndex)
    }
    
    mutating func read(bits: Int) -> Int {
        precondition(bits < 64)
        var result: UInt64 = 0
        var bitsRead = 0
        while bitsRead < bits {
            let shiftAmount = (Self.chunkSize - 1 - bitIndex)
            let mask: UInt64 = 0x01 << shiftAmount
            let nextBit: UInt64
            if chunkIndex < allBits.count {
                nextBit = (allBits[chunkIndex] & mask) >> shiftAmount
            } else {
                // Read past the end? All you get are 0s.
                nextBit = 0
            }
            result = result << 1
            result = result | nextBit
            
            bitsRead += 1
            
            bitIndex += 1
            if bitIndex >= Self.chunkSize {
                bitIndex = 0
                chunkIndex += 1
            }
        }
        
        return Int(result)
    }
}

class PacketDecoder {
    enum Error: Swift.Error {
        case notImplemented
    }
    func decode(hexadecimalString: String) throws -> Packet {
        var bitStream = BitStream(bits: bits(from: hexadecimalString))
        return try decodeNextPacket(from: &bitStream)
    }
    func decodeNextPacket(from bitStream: inout BitStream) throws -> Packet {
        let version = bitStream.read(bits: 3)
        let typeValue = bitStream.read(bits: 3)
        switch typeValue {
        case 4: // literal value
            var value: Int = 0
            var lastFiveBits = 0
            repeat {
                lastFiveBits = bitStream.read(bits: 5)
                value = value << 4
                value = value | (lastFiveBits & 0xF)
            } while (lastFiveBits & 0x10) == 0x10
            return Packet(version: version, type: .literal(value: value))
        default:
            let subPackets: [Packet]
            let isPacketBitLengthBased = bitStream.read(bits: 1) == 0
            if isPacketBitLengthBased {
                var packetsSoFar = [Packet]()
                let targetBitCount = bitStream.read(bits: 15)
                let startingCursor = bitStream.cursor
                while bitStream.cursor.distance(from: startingCursor) < targetBitCount {
                    packetsSoFar.append(try decodeNextPacket(from: &bitStream))
                }

                subPackets = packetsSoFar
            } else {
                let numberOfSubPackets = bitStream.read(bits: 11)
                subPackets = try (0..<numberOfSubPackets).map { _ in
                    try decodeNextPacket(from: &bitStream)
                }
            }
            return Packet(version: version, type: .operatorWith(packets: subPackets))
        }
    }
    
    func bits(from hexadecimalString: String) -> [UInt64] {
        let chunkSize = 64 / 4 // 64 bits, with 4 bits per character

        let strings = stride(from: 0, to: hexadecimalString.count, by: chunkSize).map { offset -> Substring in
            let startIndex = hexadecimalString.index(hexadecimalString.startIndex, offsetBy: offset)
            let endIndex = hexadecimalString.index(startIndex, offsetBy: chunkSize, limitedBy: hexadecimalString.endIndex) ?? hexadecimalString.endIndex
            return hexadecimalString[startIndex..<endIndex]
        }
        let bitArray = strings.map { string -> UInt64 in
            var result: UInt64 = 0
            for bit in 0..<chunkSize {
                let smallInt: UInt64
                
                if let index = string.index(string.startIndex, offsetBy: bit, limitedBy: string.index(before: string.endIndex)) {
                    let char = string[index...index]
                    smallInt = UInt64(char, radix: 16)!
                } else {
                    smallInt = 0
                }
                result = result << 4
                result = result | smallInt
            }
            return result
        }
        return bitArray
    }
}

class PacketAnalyzer {
    func sumVersions(of packet: Packet) -> Int {
        switch packet.type {
        case .literal:
            return packet.version
        case .operatorWith(let packets):
            return packets.map(sumVersions(of:)).reduce(packet.version, +)
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
