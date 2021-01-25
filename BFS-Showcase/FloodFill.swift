//
//  FloodFill.swift
//  BFS-Showcase
//
//  Created by Mixalis Dobekidis on 24/1/21.
//

import Foundation

class FloodFill {
    
    var stepCounter:Int = 0
    var map:Array<Int> = []
    var map2D:Array<Array<Int>> = []
    var visited:Array<Array<Int>> = []
    
    convenience init(map:Array<Int>, map2D:Array<Array<Int>>) {
        self.init()
        self.map = map
        self.map2D = map2D
        
        self.visited = self.map2D.map({row in
            return row.map({ _ in
                return 0
            })
        })
    }
    
    func resetVisited() {
        // also the step counter
        self.stepCounter = 0
        
        var counter = 0
        var innerCounter = 0
        for item in visited {
            for _ in item {
                visited[counter][innerCounter] = 0
                innerCounter += 1
            }
            counter += 1
            innerCounter = 0
        }
    }
    
    func getVisited() -> Array<Array<Int>> {
        return visited
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
    
    func isValidBlock(row:Int, col:Int) -> Bool {
        let maxRow = 7
        let maxCol = 7
        let type = self.getVectorTypeBy(point: MazeLocation(row: row, col: col))
        
        if(row<0 || row>maxRow || col<0 || col>maxCol){
            return false
        }
        else{
            print(type)
            if type == Cell.Blocked || type == Cell.NotFound {
                return false
            }
            else {
                // finally
                return true
            }
        }
    }
    
    func floodFill(row:Int, col:Int, step:Int, teamPosition:MazeLocation){
       
        if(isValidBlock(row: row, col: col) == false){     //Base case
            return
        }
        
        // we already visited that
        if visited[row][col] == 1 || visited[row][col] == 2 {
            return
        }
        
        // moving in the right direction
        //if stepCounter < step {
        stepCounter += 1
        visited[row][col] = 1;
        //}
        
        let distance = PointManhattanDistance(from: MazeLocation(row: row, col: col), to: teamPosition)
        
        if(distance == step){
            //Current node is marked as visited.
            // check if path contains valid number of steps, we use DFS for this
            visited[row][col] = 2;
            stepCounter = 0
        }
        
        floodFill(row: row-1, col: col, step: step, teamPosition: teamPosition);
        floodFill(row: row+1, col: col, step: step, teamPosition: teamPosition);
        floodFill(row: row, col: col-1, step: step, teamPosition: teamPosition);
        floodFill(row: row, col: col+1, step: step, teamPosition: teamPosition);
        
        // no diagonal checking
        //floodFill(i-1,j-1,idxValue);
        //floodFill(i-1,j+1,idxValue);
        //floodFill(i+1,j-1,idxValue);
        //floodFill(i+1,j+1,idxValue);
    }
    
    func PointManhattanDistance(from: MazeLocation, to: MazeLocation) -> Int {
        return (abs(from.row - to.row) + abs(from.col - to.col))
    }
    
}
