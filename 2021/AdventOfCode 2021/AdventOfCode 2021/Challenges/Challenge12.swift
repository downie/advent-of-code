//
//  Challenge12.swift
//  AdventOfCode 2021
//
//  Created by Chris Downie on 12/12/21.
//

import SwiftUI

private let demoInput1 = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end

"""

private let demoInput2 = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc

"""

private let demoInput3 = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW

"""
private let demos = [
    demoInput1,
    demoInput2,
    demoInput3
]

struct GraphEdge: Equatable, Hashable {
    let from: String
    let to: String
    
    // These are bidirectional, but I'm storing from as alphabetically lower than to.
    init(from: String, to: String) {
        if from < to {
            self.from = from
            self.to = to
        } else {
            self.from = to
            self.to = from
        }
    }
    
    func opposite(node: String) -> String? {
        if node == from {
            return to
        } else if node == to {
            return from
        }
        return nil
    }
}

class CaveMapper: ObservableObject {
    @Published var output = ""
    private let demo: Int? = nil
    private let isPartTwo = true
    
    private let edges: Set<GraphEdge>
    
    init() {
        let input: String
        if let demoIndex = demo {
            let demoInput = demos[demoIndex]
            input = demoInput
        } else {
            let inputData = NSDataAsset(name: "12")!.data
            input = String(data: inputData, encoding: .utf8)!
        }
        let edges = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .map { line -> GraphEdge in
                let nodes = line.components(separatedBy: "-")
                let edge = GraphEdge(from: nodes[0], to: nodes[1])
                return edge
            }
        
        self.edges = Set(edges)
    }
    
    func solve() {
        let pathCount = recursiveDFS(from: "start", remainingEdges: edges)
        output = "\(pathCount)"
    }
    
    private func recursiveDFS(from node: String, remainingEdges: Set<GraphEdge>, doubledSmallNode: String? = nil, path: [String] = []) -> Int {
        // Our end of the recursion
        if node == "end" {
            guard isPartTwo else {
                return 1
            }
            guard let doubledSmallNode = doubledSmallNode else {
                if demo != nil {
                    print(path.joined(separator: ","))
                }
                return 1
            }
            // Only count doubled paths if we used the small node twice. Otherwise, we'll double-count it.
            if path.filter({ $0 == doubledSmallNode}).count == 2 {
                if demo != nil {
                    print(path.joined(separator: ","))
                }
                return 1
            }

            return 0
        }
        
        let edgeOptions = remainingEdges.filter { edge in
            edge.from == node || edge.to == node
        }
        if edgeOptions.isEmpty {
            return 0
        }
        
        // Tracing for debugging
        var updatedPath = path
        updatedPath.append(node)
        
        // Remove edges from the remaining edges set
        var oneFewerEdges = remainingEdges
        let isSmallCave = (node.uppercased() != node)
        var pathCount = [Int]()
        if isSmallCave {
            // Never visit 'node' again
            oneFewerEdges = oneFewerEdges.filter { edge in
                edge.from != node && edge.to != node
            }
            if isPartTwo && doubledSmallNode == nil && node != "start" {
                let whatIfWeVisitedThisNodeTwiceCount = edgeOptions.map { takingPath -> Int in
                    guard let destination = takingPath.opposite(node: node) else {
                        return 0
                    }
                    
                    return recursiveDFS(from: destination, remainingEdges: remainingEdges, doubledSmallNode: node, path: updatedPath)
                }
                pathCount.append(contentsOf: whatIfWeVisitedThisNodeTwiceCount)
            }
        }
        let whatIfWeNeverCameBackHere = edgeOptions.map { takingPath -> Int in
            guard let destination = takingPath.opposite(node: node) else {
                return 0
            }
            
            return recursiveDFS(from: destination, remainingEdges: oneFewerEdges, doubledSmallNode: doubledSmallNode, path: updatedPath)
        }
        pathCount.append(contentsOf: whatIfWeNeverCameBackHere)

        return pathCount.reduce(0, +)
    }
}
struct Challenge12: View {
    @StateObject var state = CaveMapper()
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

struct Challenge12_Previews: PreviewProvider {
    static var previews: some View {
        Challenge12()
    }
}
