//
//  FloodFill.swift
//  BFS-Showcase
//
//  Created by Mixalis Dobekidis on 24/1/21.
//

import Foundation

class FloodFill {
    
    var visited:Array<Array<Int>> = [
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
    ]
    
    var map2D = [
        [1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 0, 0, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1],
        [1, 0, 0, 0, 1, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1]
    ]
    
    var stepCounter:Int = 0
    
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
        print("checking: ", row, col)
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
        print("Distance: ", distance)
        if(distance == step){
            
            print("adding one for step counter: ", stepCounter)
            //Current node is marked as visited.
            // check if path contains valid number of steps, we use DFS for this
            
            visited[row][col] = 2;
            
            stepCounter = 0
            
            print("same as step this is the solution: ",row, col)
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
