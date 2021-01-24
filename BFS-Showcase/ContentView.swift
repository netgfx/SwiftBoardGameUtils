//
//  ContentView.swift
//  BFS-Showcase
//
//  Created by Mixalis Dobekidis on 24/1/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var pathTiles:Array<MazeLocation> = []
    @State var currentPos:MazeLocation = MazeLocation(row: 0, col: 0)
    @State var selectedNumber:Int = 0
    var map:Array<Int> = [
        1, 1, 1, 1, 1, 1, 1, 1,
        1, 0, 0, 0, 1, 0, 0, 1,
        1, 0, 0, 0, 1, 0, 0, 1,
        1, 0, 0, 0, 1, 0, 0, 1,
        1, 0, 0, 0, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 0, 0, 1,
        1, 0, 0, 0, 1, 0, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 2
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
    
    func getNum(index:Int, innerIndex:Int) -> Int{
        let index = index*8+innerIndex
        print(index)
        return map[index]
    }
    
    func getColor(index:Int, innerIndex:Int) -> Color {
        let _index = index*8+innerIndex
        var color:Color = .white
        
        if index%2 == 0 {
            color = _index%2 == 0 ? Color.purple : Color.orange
        }
        else {
            color = _index%2 != 0 ? Color.purple : Color.orange
        }
        if _index == 63 {
            color = Color.red
        }
        if _index == 0 {
            color = Color.green
        }
        
        // check if part of path
        if self.pathTiles.contains(MazeLocation(row: index, col: innerIndex)) == true {
            color = Color.green
        }
        
        return color
    }
    
    func getPath(endPath:MazeLocation) {
        self.pathTiles.removeAll()
        let path = BFS().findPath(start:MazeLocation(row: 0,col:0), end:MazeLocation(row:endPath.row,col:endPath.col))
        self.pathTiles = path
    }
    
    func findLegalMoves(step:Int) {
        let floodFill = FloodFill()
        // reset array of allowed blocks
        self.pathTiles.removeAll()
        
        for index in 0..<map2D.count {
            for innerIndex in 0..<map2D[index].count {
                floodFill.floodFill(row: index, col: innerIndex, step: step, teamPosition: self.currentPos)
            }
        }
        // all allowed moves
        let visited = floodFill.getVisited()
        
        // now check if they are valid
        for index in 0..<visited.count {
            for innerIndex in 0..<visited[index].count {
                if visited[index][innerIndex] == 2 {
                    
                    let path = BFS().findPath(start:MazeLocation(row: self.currentPos.row,col:self.currentPos.col), end:MazeLocation(row:index,col:innerIndex))
                    
                    if path.count-1 == step {
                        self.pathTiles.append(MazeLocation(row: index, col: innerIndex))
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0){
            ForEach(0..<8, id: \.self) { index in
                HStack(spacing: 0){
                    ForEach(0..<8, id: \.self) { innerIndex in
                        if getNum(index: index, innerIndex: innerIndex) == 1 || getNum(index: index, innerIndex: innerIndex) == 2 {
                            ZStack(alignment: .center){
                                
                                RoundedRectangle(cornerRadius: 10).fill(getColor(index:index, innerIndex:innerIndex)).frame(width: 40, height: 40, alignment: .center)
                            }.id(index*innerIndex).onTapGesture {
                                getPath(endPath: MazeLocation(row: index, col: innerIndex))
                            }
                        }
                        
                        else {
                            ZStack(alignment: .center){
                                RoundedRectangle(cornerRadius: 10).fill(Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)).frame(width: 40, height: 40, alignment: .center)
                            }.id(index*innerIndex)
                        }
                    }
                }.id(index)
            }
            
            Picker(selection: $selectedNumber, label: Text("Please choose a number")) {
                ForEach(0 ..< 8) { num in
                    Text(String(num))
                }
            }.onChange(of: selectedNumber, perform: { (value) in
                findLegalMoves(step: value)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
