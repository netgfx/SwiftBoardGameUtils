//
//  Grid.swift
//  BFS-Showcase
//
//  Created by Mixalis Dobekidis on 24/1/21.
//

import Foundation

class Grid {
    var width:Int = 0
    var height:Int = 0
    var matrix:Array<Array<GridNode>> = []
    var map2D = [
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 0, 0, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1],
        [1, 0, 0, 0, 1, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 2]
    ]
    
    init(width:Int, height:Int) {
        self.width = width
        self.height = height
        
        self.matrix = self.createMatrix()
    }
    
    func createMatrix() ->Array<Array<GridNode>> {
        var finalResult:Array<Array<GridNode>> = []
        
        let maze = self.map2D
        
        for index in 0..<maze.count {
            finalResult.append([])
            for innerIndex in 0..<maze[index].count {
                let type = self.getVectorTypeBy(point: MazeLocation(row: index, col: innerIndex))
                finalResult[index].append(GridNode(x: index, y: innerIndex, type: type))
            }
        }
        
        return finalResult
    }
    
    func getVectorTypeBy(point:MazeLocation) -> Cell {
        
        let maxRow = 7
        let maxCol = 7
        
        if point.row < 0 {
            return Cell.NotFound
        }
        
        if point.col < 0 {
            return Cell.NotFound
        }
        
        if point.row > maxRow || point.col > maxCol {
            return Cell.NotFound
        }
        
        if map2D[point.row][point.col] == 0 {
            return Cell.Blocked
        }
        else if map2D[point.row][point.col] == 1 {
            return Cell.Empty
        }
        else if map2D[point.row][point.col] == 2 {
            return Cell.Goal
        }
        else if map2D[point.row][point.col] == 5 {
            return Cell.Key
        }
        else {
            return Cell.NotFound
        }
    }
    
    func isWalkableAt(x:Int, y:Int) -> Bool {
        return self.isInside(x: x, y: y) && self.matrix[x][y].getType() != .Blocked;
    }
    
    func isInside(x:Int, y:Int) -> Bool {
        return (x >= 0 && x < self.width) && (y >= 0 && y < self.height)
    }
    
    func getNodeAt(x:Int, y:Int) -> GridNode {
        return matrix[x][y]
    }
    
    func getNeighbors(node:GridNode) -> Array<GridNode> {
        let x = node.getX()
        let y = node.getY()
        var neighbors:Array<GridNode> = []
        
        // ↑
        if (self.isWalkableAt(x: x-1, y: y)) {
            neighbors.append(matrix[x-1][y]);
        }
        // →
        if (self.isWalkableAt(x:x, y:y+1)) {
            neighbors.append(matrix[x][y + 1]);
        }
        // ↓
        if (self.isWalkableAt(x:x+1, y:y)) {
            neighbors.append(matrix[x+1][y]);
            
        }
        // ←
        if (self.isWalkableAt(x: x, y:y-1)) {
            neighbors.append(matrix[x][y - 1]);
        }
        
        return neighbors
    }
}
