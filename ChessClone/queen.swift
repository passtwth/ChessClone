//
//  queen.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit

class Queen: UIChessPiece {
    init(frame: CGRect, color: UIColor, vc: ViewController) {
        super.init(frame: frame)
        
        if color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            self.text = "♛"
        }
        if color == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
            self.text = "♕"
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
        
        if destIndex.row == sourceIndex.row || destIndex.col == sourceIndex.col {
            return true
        }
        
        if abs(destIndex.row - sourceIndex.row) == abs(destIndex.col - sourceIndex.col) {
            return true
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
