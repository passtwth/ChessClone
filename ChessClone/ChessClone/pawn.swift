//
//  pawn.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit

class Pawn: UIChessPiece {
    var triesToadvanceBy2: Bool = false
    init(frame: CGRect, color: UIColor, vc: ViewController) {
        super.init(frame: frame)
        
        if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            self.text = "♟"
        }
        if color == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
            self.text = "♙"
        }
        self.isOpaque = false
        self.textColor = color
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.font = self.font.withSize(36)
        
        vc.chessPiece.append(self)
        vc.view.addSubview(self)
        
        
        
    }
    
    func doesMoveSeemFine(sourceIndex: BoardIndex, destIndex: BoardIndex) -> Bool{
        
        if sourceIndex.col == destIndex.col {
            if (sourceIndex.row == 1 && destIndex.row == 3 && color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) || (sourceIndex.row == 6 && destIndex.row == 4 && color == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) {
                triesToadvanceBy2 = true
                return true
            }
        }
        
        triesToadvanceBy2 = false
        // check advance by 1
        var moveForward = 0
        if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            moveForward = 1
        } else {
            moveForward = -1
        }
        
        if destIndex.row == sourceIndex.row + moveForward {
            if (destIndex.col == sourceIndex.col - 1) || (destIndex.col == sourceIndex.col) || (destIndex.col == sourceIndex.col + 1) {
                return true
            }
        }
        
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

