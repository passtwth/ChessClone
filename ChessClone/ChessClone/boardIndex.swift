//
//  boardIndex.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import Foundation

struct BoardIndex: Equatable {
    var row: Int
    var col: Int
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    static func == (leftHandSide: BoardIndex, rightHandSide: BoardIndex) -> Bool {
        return (leftHandSide.row == rightHandSide.row && leftHandSide.col == rightHandSide.col)
    }
}
