//
//  knight.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit

class Knight: UIChessPiece {
    init(frame: CGRect, color: UIColor, vc: ViewController) {
        super.init(frame: frame)
        
        if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            self.text = "♞"
        }
        if color == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
            self.text = "♘"
        }
        self.isOpaque = false
        self.textColor = color
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.font = self.font.withSize(36)
        
        vc.chessPiece.append(self)
        vc.view.addSubview(self)
        
        
    }
    func doesMoveSeemFine(sourceIndex: BoardIndex, destIndex: BoardIndex) -> Bool {
        
        
        let moveValid = [(sourceIndex.row + 1, sourceIndex.col + 2),
                         (sourceIndex.row + 1, sourceIndex.col - 2),
                         (sourceIndex.row - 1, sourceIndex.col - 2),
                         (sourceIndex.row - 1, sourceIndex.col + 2),
                         (sourceIndex.row + 2, sourceIndex.col + 1),
                         (sourceIndex.row - 2, sourceIndex.col + 1),
                         (sourceIndex.row + 2, sourceIndex.col - 1),
                         (sourceIndex.row - 2, sourceIndex.col - 1)]
        for (row, col) in moveValid {
            if destIndex.row == row && destIndex.col == col {
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
