//
//  MazeLocation.swift
//  BFS-Showcase
//
//  Created by Mixalis Dobekidis on 24/1/21.
//

import Foundation

enum Cell: Int {
    case Empty = 1
    case Blocked = 0
    case Key = 5
    case Goal = 2
    case NotFound = -1
}


struct MazeLocation: Hashable {
    let row: Int
    let col: Int
    func hash(into hasher: inout Hasher) {
        hasher.combine(row.hashValue ^ col.hashValue)
    }
    var hashValue: Int { return row.hashValue ^ col.hashValue }
}
