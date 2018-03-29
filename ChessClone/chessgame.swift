//
//  chessgame.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit

class ChessGame: NSObject {
    var theChessBoard: ChessBoard!
    var isWhiteTurn = true
    var winner: String?
    init(viewController: ViewController) {
        theChessBoard = ChessBoard.init(viewcontroller: viewController)
    }
    func getArrayOfmove(piece: UIChessPiece) -> [BoardIndex]{
        var arrayOfmove = [BoardIndex]()
        let source = theChessBoard.getOfIndex(chessPieceToFind: piece)!
        for row in 0..<theChessBoard.ROWS{
            for col in 0..<theChessBoard.COLS{
                let dest = BoardIndex(row: row, col: col)
                if isMoveValid(piece: piece, fromIndex: source, toIndex: dest) {
                    arrayOfmove.append(dest)
                }
                
            }
        }
        return arrayOfmove
    }
    func makeAIMove() {
        // get the white king, if possible
        if getPlayerCheckmated() == "White" {
            for achessPiece in theChessBoard.vc.chessPiece {
                if achessPiece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
                    guard let source = theChessBoard.getOfIndex(chessPieceToFind: achessPiece) else {
                        continue
                    }
                    
                    guard let dest = theChessBoard.getOfIndex(chessPieceToFind: theChessBoard.whiteKing) else {
                        continue
                    }
                    
                    if isMoveValid(piece: achessPiece, fromIndex: source, toIndex: dest) {
                        move(piece: achessPiece, fromIndex: source, toIndex: dest, toOrigin: achessPiece.frame.origin)
                        return
                    }
                }
            }
        }
        // other ways
        //attack undefended white piece, if there's no check on the black king
        if getPlayerCheckmated() == nil {
            if didAttackUndefendedPiece() {
                return
            }
        }
        
        var moveFound = false
        var numberOfTriesToEscapeCheck = 0
        
        searchForMoves: while moveFound == false {
            // get random piece
            let randomChessPieceArrayIndex = Int(arc4random_uniform(UInt32(theChessBoard.vc.chessPiece.count)))
            let chessPieceToMove = theChessBoard.vc.chessPiece[randomChessPieceArrayIndex]
            guard chessPieceToMove.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) else {
                continue searchForMoves
            }
            let movesArray: [BoardIndex] = getArrayOfmove(piece: chessPieceToMove)
            guard movesArray.isEmpty == false else {
                continue searchForMoves
            }
            let randomMovesArrayIndex = Int(arc4random_uniform(UInt32(movesArray.count)))
            let randomDestIndex = movesArray[randomMovesArrayIndex]
            let destOrigin = ChessBoard.getFrame(forRow: randomDestIndex.row, forCol: randomDestIndex.col).origin
            guard let sourceIndex = theChessBoard.getOfIndex(chessPieceToFind: chessPieceToMove) else {
                continue searchForMoves
            }
            // similate the move on board matrix
            let pieceTaken = theChessBoard.board[randomDestIndex.row][randomDestIndex.col]
            theChessBoard.board[randomDestIndex.row][randomDestIndex.col] = theChessBoard.board[sourceIndex.row][sourceIndex.col]
            theChessBoard.board[sourceIndex.row][sourceIndex.col] = Dummy()
            
            if numberOfTriesToEscapeCheck < 1000 {
                guard getPlayerCheckmated() != "Black" else {
                    //undo move
                    theChessBoard.board[sourceIndex.row][sourceIndex.col] = theChessBoard.board[randomDestIndex.row][randomDestIndex.col]
                    theChessBoard.board[randomDestIndex.row][randomDestIndex.col] = pieceTaken
                    numberOfTriesToEscapeCheck += 1
                    continue searchForMoves
                }
            }
            //undo move
            theChessBoard.board[sourceIndex.row][sourceIndex.col] = theChessBoard.board[randomDestIndex.row][randomDestIndex.col]
            theChessBoard.board[randomDestIndex.row][randomDestIndex.col] = pieceTaken
            //try best move, if any good one
            if didBestMoveForAI(forScoreOver: 2) {
                return
            }
            move(piece: chessPieceToMove, fromIndex: sourceIndex, toIndex: randomDestIndex, toOrigin: destOrigin)
            moveFound = true
        }
        
    }
    func didBestMoveForAI(forScoreOver limit: Int) -> Bool {
        
        return false
    }
    func didAttackUndefendedPiece() -> Bool{
        loopThatreversesChessPiece: for attackingChessPiece in theChessBoard.vc.chessPiece {
            guard  attackingChessPiece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) else {
                continue loopThatreversesChessPiece
            }
            guard let source = theChessBoard.getOfIndex(chessPieceToFind: attackingChessPiece) else {
                continue loopThatreversesChessPiece
            }
            let possibleDestination = getArrayOfmove(piece: attackingChessPiece)
            searchForUndefendedWhitePieces: for attackedIndex in possibleDestination {
                guard let attackedChessPiece = theChessBoard.board[attackedIndex.row][attackedIndex.col] as? UIChessPiece else {
                    continue searchForUndefendedWhitePieces
                }
                for row in 0..<theChessBoard.ROWS{
                    for col in 0..<theChessBoard.COLS {
                        guard let defendingChessPiece = theChessBoard.board[row][col] as? UIChessPiece, defendingChessPiece.color == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) else {
                            continue
                        }
                        let defendingIndex = BoardIndex(row: row, col: col)
                        if isMoveValid(piece: defendingChessPiece, fromIndex: defendingIndex, toIndex: attackedIndex) {
                            continue searchForUndefendedWhitePieces
                        }
                    }
                }
            }
        }
        return false
    }
    
    func getPawnToBePromoted() -> Pawn?{
        for chesspiece in theChessBoard.vc.chessPiece {
            if let pawnPromotedPiece = chesspiece as? Pawn {
                let pawnIndex = ChessBoard.getOfIndex(origin: pawnPromotedPiece.frame.origin)
                if pawnIndex.row == 0 || pawnIndex.row == 7 {
                    return pawnPromotedPiece
                }
            }
        }
        return nil
    }
    
    func getPlayerCheckmated() -> String? {
        guard let whiteKingIndex = theChessBoard.getOfIndex(chessPieceToFind: theChessBoard.whiteKing) else {
            return nil
        }
        guard let blackKingIndex = theChessBoard.getOfIndex(chessPieceToFind: theChessBoard.BlackKing) else {
            return nil
        }
        
        
        for row in 0..<theChessBoard.ROWS {
            for col in 0..<theChessBoard.COLS {
                if let chessPiece = theChessBoard.board[row][col] as? UIChessPiece{
                    
                    let chessPieceIndex = BoardIndex(row: row, col: col)
                    
                    if chessPiece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
                        if !isWhiteTurn {
                            if isMoveValid(piece: chessPiece, fromIndex: chessPieceIndex, toIndex: whiteKingIndex) {
                                return "White"
                            }
                        }
                        
                    } else {
                        if isWhiteTurn {
                            if isMoveValid(piece: chessPiece, fromIndex: chessPieceIndex, toIndex: blackKingIndex) {
                                return "Black"
                            }
                        }
                        
                    }
                }
            }
        }
        
        return nil
    }
    
    
    func someBodyWin() -> Bool{
        if !(theChessBoard.vc.chessPiece.contains(theChessBoard.whiteKing)) {
            winner = "✭~Black~✭"
            return true
        }
        if !(theChessBoard.vc.chessPiece.contains(theChessBoard.BlackKing)) {
            winner = "✩~White~✩"
            return true
        }
        
        return false
    }
    
    func isMoveValid(piece: UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex) -> Bool {
        guard isMoveOnBoard(piece: piece, sourceIndex: sourceIndex, destIndex: destIndex) else {
            print("Moved Not on Board")
            return false
        }
        guard isColorTurn(sameAsPiece: piece) else {
            print("Wrong turn")
            return false
        }
        guard isNormalMoveValid(piece: piece, source: sourceIndex, dest: destIndex) else {
            
            return false
        }
        
        switch piece {
        case is Pawn:
            return isMoveValid(forPawn: piece as! Pawn, sourceIndex: sourceIndex, destIndex: destIndex)
        case is Rook,is Bishop, is Queen:
            return isMoveValid(forRookOrBishopOrQueen: piece,sourceIndex: sourceIndex ,destIndex: destIndex)
        case is Knight:
            return (piece as! Knight).doesMoveSeemFine(sourceIndex: sourceIndex, destIndex: destIndex)
        case is King:
            return isMoveValid(forKing: piece as! King,source: sourceIndex, dest: destIndex)
        default:
            break
        }
        print("moveValid")
        return false
    }
    
    func isMoveValid(forKing king: King, source: BoardIndex, dest: BoardIndex) -> Bool {
        if king.doesMoveSeemFine(sourceIndex: source, destIndex: dest) {
            if kingIntervalForOne(king: king , dest: dest) {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    func kingIntervalForOne(king: King, dest: BoardIndex) -> Bool {
        var opponentKing: King!
        var indexOfOpponentKing: BoardIndex!
        
        if king == theChessBoard.BlackKing {
            opponentKing = theChessBoard.whiteKing
        } else {
            opponentKing = theChessBoard.BlackKing
        }
        
        
        for row in 0..<theChessBoard.ROWS {
            for col in 0..<theChessBoard.COLS {
                if let aking = theChessBoard.board[row][col] as? King, aking == opponentKing {
                    indexOfOpponentKing = BoardIndex(row: row, col: col)
                }
            }
        }
        
        let intervalRow = abs(dest.row - indexOfOpponentKing.row)
        let intervalCol = abs(dest.col - indexOfOpponentKing.col)
        
        if case 0...1 = intervalRow {
            if case 0...1 = intervalCol {
                return true
            }
        }
        return false
    }
    
    func isMoveValid(forPawn pawn: Pawn, sourceIndex: BoardIndex, destIndex: BoardIndex) -> Bool {
        if !(pawn.doesMoveSeemFine(sourceIndex: sourceIndex, destIndex: destIndex)) {
            return false
        }
        // Not attack
        if sourceIndex.col == destIndex.col {
            //advance by 2
            if pawn.triesToadvanceBy2 {
                var moveForward = 0
                if pawn.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
                    moveForward = 1
                } else {
                    moveForward = -1
                }
                if theChessBoard.board[destIndex.row][destIndex.col] is Dummy && theChessBoard.board[destIndex.row - moveForward][destIndex.col] is Dummy {
                    return true
                } else {
                    return false
                }
            }
            //advance by 1
            if theChessBoard.board[destIndex.row][destIndex.col] is Dummy {
                return true
            }
            
        }
            // attack some piece
        else {
            if !(theChessBoard.board[destIndex.row][destIndex.col] is Dummy) {
                return true
            }
        }
        
        
        return false
    }
    func isMoveValid(forRookOrBishopOrQueen piece: UIChessPiece, sourceIndex: BoardIndex, destIndex: BoardIndex) -> Bool {
        
        switch piece {
        case is Rook:
            if !(piece as! Rook).doesMoveSeemFine(sourceIndex: sourceIndex, destIndex: destIndex) {
                return false
            }
        case is Bishop:
            if !(piece as! Bishop).doesMoveSeemFine(sourceIndex: sourceIndex, destIndex: destIndex) {
                return false
            }
        case is Queen:
            if !(piece as! Queen).doesMoveSeemFine(sourceIndex: sourceIndex, destIndex: destIndex) {
                return false
            }
        default:
            break
        }
        var increaseRow = 0
        if destIndex.row - sourceIndex.row != 0 {
            increaseRow = (destIndex.row - sourceIndex.row) / abs(destIndex.row - sourceIndex.row)
        }
        var increaseCol = 0
        if destIndex.col - sourceIndex.col != 0 {
            increaseCol = (destIndex.col - sourceIndex.col) / abs(destIndex.col - sourceIndex.col)
        }
        
        var nextRow = sourceIndex.row + increaseRow
        var nextCol = sourceIndex.col + increaseCol
        
        while nextRow != destIndex.row || nextCol != destIndex.col {
            if !(theChessBoard.board[nextRow][nextCol] is Dummy) {
                return false
            }
            nextRow += increaseRow
            nextCol += increaseCol
        }
        
        return true
    }
    
    func isNormalMoveValid(piece: UIChessPiece, source: BoardIndex, dest: BoardIndex) -> Bool{
        guard source != dest else {
            print("Moved on the same place")
            return false
        }
        guard !isAttackingAlliedPiece(sourcePiece: piece, destIndex: dest) else {
            print("AttackingAllied")
            return false
        }
        
        return true
    }
    
    func isAttackingAlliedPiece(sourcePiece: UIChessPiece, destIndex: BoardIndex) -> Bool {
        
        let destPiece: Piece = theChessBoard.board[destIndex.row][destIndex.col]
        guard !(destPiece is Dummy) else {
            return false
        }
        let destChessPiece = destPiece as! UIChessPiece
        
        return (sourcePiece.color == destChessPiece.color)
    }
    
    func move(piece chessPieceToMove: UIChessPiece, fromIndex sourceIndex: BoardIndex, toIndex destIndex: BoardIndex, toOrigin destOrigin: CGPoint) {
        let initialChessPieceFrame = chessPieceToMove.frame
        // remove place at destination
        let pieceToRemove = theChessBoard.board[destIndex.row][destIndex.col]
        theChessBoard.remove(piece: pieceToRemove)
        
        //place the piece at destination
        theChessBoard.place(chessPiece: chessPieceToMove, toIndex: destIndex, toOrigin: destOrigin)
        
        theChessBoard.board[sourceIndex.row][sourceIndex.col] = Dummy(frame: initialChessPieceFrame)
    }
    
    func nextTurn() {
        isWhiteTurn = !isWhiteTurn
    }
    
    func isColorTurn (sameAsPiece piece: UIChessPiece) -> Bool {
        
        
        if piece.color == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            if !isWhiteTurn {
                return true
            }
        } else {
            if isWhiteTurn {
                return true
            }
        }
        
        return false
    }
    
    func isMoveOnBoard(piece: UIChessPiece, sourceIndex: BoardIndex, destIndex: BoardIndex) -> Bool{
        if case 0..<theChessBoard.ROWS = sourceIndex.row {
            if case 0..<theChessBoard.ROWS = sourceIndex.col {
                if case 0..<theChessBoard.COLS = destIndex.row {
                    if case 0..<theChessBoard.COLS = destIndex.col {
                        return true
                    }
                }
            }
        }
        return false
    }
}
