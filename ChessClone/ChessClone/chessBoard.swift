//
//  chessBoard.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit

class ChessBoard: NSObject {
    var board: [[Piece]]!
    var vc: ViewController!
    let ROWS = 8
    let COLS = 8
    var whiteKing: King!
    var BlackKing: King!
    
    func getOfIndex(chessPieceToFind: UIChessPiece) -> BoardIndex? {
        for row in 0..<ROWS {
            for col in 0..<COLS {
                
                if chessPieceToFind == board[row][col] as? UIChessPiece {
                    return BoardIndex(row: row, col: col)
                    
                }
            }
        }
        return nil
    }
    
    func remove(piece: Piece) {
        if let chessPiece = piece as? UIChessPiece {
            let indexOnBoard = ChessBoard.getOfIndex(origin: chessPiece.frame.origin)
            board[indexOnBoard.row][indexOnBoard.col] = Dummy(frame: chessPiece.frame)
            
            if let indexInChessPieceArray = vc.chessPiece.index(of: chessPiece) {
                vc.chessPiece.remove(at: indexInChessPieceArray)
            }
            chessPiece.removeFromSuperview()
        }
        
    }
    func place(chessPiece: UIChessPiece, toIndex destIndex: BoardIndex, toOrigin destOrigin: CGPoint) {
        chessPiece.frame.origin = destOrigin
        board[destIndex.row][destIndex.col] = chessPiece
    }
    
    
    static func getFrame(forRow row: Int, forCol col: Int) -> CGRect {
        let x = CGFloat(ViewController.SPACE_FROM_LEFT_EDGE + col * ViewController.TILE_SIZE)
        let y = CGFloat(ViewController.SPACE_FROM_TOP_EDGE + row * ViewController.TILE_SIZE)
        let origin = CGPoint(x: x, y: y)
        let size = CGSize(width: ViewController.TILE_SIZE, height: ViewController.TILE_SIZE)
        return CGRect(origin: origin, size: size)
    }
    
    static func getOfIndex(origin: CGPoint) -> BoardIndex {
        let col = (Int(origin.x) - ViewController.SPACE_FROM_LEFT_EDGE) / ViewController.TILE_SIZE
        let row = (Int(origin.y) - ViewController.SPACE_FROM_TOP_EDGE) / ViewController.TILE_SIZE
        
        return BoardIndex(row: row, col: col)
    }
    
    
    init(viewcontroller: ViewController) {
        
        
        vc = viewcontroller
        
        let oneRowOfBoard = Array(repeating: Dummy(), count: COLS)
        board = Array(repeating: oneRowOfBoard, count: ROWS)
        
        
        for row in 0..<ROWS {
            for col in 0..<COLS {
                switch row {
                case 0:
                    switch col {
                    case 0:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 1:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 2:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 3:
                        board[row][col] = Queen(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 4:
                        BlackKing = King(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                        board[row][col] = BlackKing
                        
                    case 5:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 6:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    case 7:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                    default:
                        break
                    }
                case 1:
                    board[row][col] = Pawn(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), vc: vc)
                case 6:
                    board[row][col] = Pawn(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                case 7:
                    switch col {
                    case 0:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 1:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 2:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 3:
                        board[row][col] = Queen(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                        
                    case 4:
                        whiteKing = King(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                        board[row][col] = whiteKing
                    case 5:
                        board[row][col] = Bishop(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 6:
                        board[row][col] = Knight(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    case 7:
                        board[row][col] = Rook(frame: ChessBoard.getFrame(forRow: row, forCol: col), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), vc: vc)
                    default:
                        break
                    }
                default:
                    break
                }
            }
        }
    }
}
