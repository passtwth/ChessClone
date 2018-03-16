//
//  ViewController.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var boardScreenOutlet: UIStackView!
    
    @IBOutlet weak var displayTurnOutlet: UILabel!
    
    @IBOutlet weak var displayCheckOutlet: UILabel!
    
    @IBOutlet var panGestureOUTLET: UIPanGestureRecognizer!
    
    var LEFTEDGE: CGFloat!
    var TOPEDGE: CGFloat!

    var pieceChessDragged: UIChessPiece!
    var sourceOrigin: CGPoint!
    var destinateOrigin: CGPoint!
    static var SPACE_FROM_LEFT_EDGE: Int = 35
    static var SPACE_FROM_TOP_EDGE: Int = 181
    static var TILE_SIZE: Int = 38
    var myChessGame: ChessGame!
    var chessPiece: [UIChessPiece]!
    var daggedFixLocation: CGPoint!
    var isAgainstAI: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialScreenInterval()
        
        chessPiece = []
        myChessGame = ChessGame.init(viewController: self)

    }
    func initialScreenInterval() {
        let screenSizeX = UIScreen.main.bounds.maxX
        let boardScreenOutletSizeX = boardScreenOutlet.bounds.maxX
        let screenSizeY = UIScreen.main.bounds.maxY
        let boardScreenOutletSizeY = boardScreenOutlet.bounds.maxY
        LEFTEDGE = (screenSizeX - boardScreenOutletSizeX) / 2
        TOPEDGE = (screenSizeY - boardScreenOutletSizeY) / 2
        ViewController.SPACE_FROM_LEFT_EDGE = Int(LEFTEDGE)
        ViewController.SPACE_FROM_TOP_EDGE = Int(TOPEDGE)
    }
    
    func dragPiece (piece: UIChessPiece,usingPan panGesture: UIPanGestureRecognizer) {
        
//        let translation = panGesture.translation(in: view)
//        
//        piece.center = CGPoint(x: translation.x + piece.center.x , y: translation.y + piece.center.y)
//        
//        panGesture.setTranslation(CGPoint.zero, in: view)
//        
        
    }
    
    
    @IBAction func draggedFix(_ sender: UIPanGestureRecognizer) {
        
        daggedFixLocation = sender.location(in: view)
        if pieceChessDragged != nil {
            pieceChessDragged.center = daggedFixLocation
        }
        if sender.state == .ended {
            
            if pieceChessDragged != nil {
                
                let location = sender.location(in: view)
                
                var x = Int(location.x)
                var y = Int(location.y)
                
                x -= ViewController.SPACE_FROM_LEFT_EDGE
                y -= ViewController.SPACE_FROM_TOP_EDGE
                
                x = ( x / ViewController.TILE_SIZE) * ViewController.TILE_SIZE
                y = ( y / ViewController.TILE_SIZE) * ViewController.TILE_SIZE
                
                x += ViewController.SPACE_FROM_LEFT_EDGE
                y += ViewController.SPACE_FROM_TOP_EDGE
                
                destinateOrigin = CGPoint(x: x, y: y)
                
                let sourceIndex = ChessBoard.getOfIndex(origin: sourceOrigin)
                let destIndex = ChessBoard.getOfIndex(origin: destinateOrigin)
                print(sourceIndex)
                print(destIndex)
                if myChessGame.isMoveValid(piece: pieceChessDragged, fromIndex: sourceIndex, toIndex: destIndex) {
                    myChessGame.move(piece: pieceChessDragged, fromIndex: sourceIndex, toIndex: destIndex, toOrigin: destinateOrigin)
                    checkIfPlayerIsCheckmated()
                    checkIfWinnerAppear()
                    
                    if shouldPromotePawn() {
                        promptForPawnPromotion()
                    } else {
                        resumeGame()
                    }
                    
                    
                    
                    
                } else {
                    pieceChessDragged.frame.origin = sourceOrigin
                }
            }
        }
    }
    func resumeGame() {
        myChessGame.nextTurn()
        updateFromScreen()
        if isAgainstAI == true && !myChessGame.isWhiteTurn {
            myChessGame.makeAIMove()
            checkIfPlayerIsCheckmated()
            checkIfWinnerAppear()
            if shouldPromotePawn() {
                promote(pawn: myChessGame.getPawnToBePromoted()!, into: "Queen")
            }
            updateFromScreen()
            myChessGame.nextTurn()
            
        }
    }
    func promote(pawn pawnToBePromoted: Pawn, into pieceName: String) {
        let pawnColor = pawnToBePromoted.color
        let pawnFrame = pawnToBePromoted.frame
        let pawnIndex = ChessBoard.getOfIndex(origin: pawnToBePromoted.frame.origin)
        
        myChessGame.theChessBoard.remove(piece: pawnToBePromoted)
        
        switch pieceName {
        case "Queen":
            myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Queen(frame: pawnFrame, color: pawnColor, vc: self)
        case "Knight":
            myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Knight(frame: pawnFrame, color: pawnColor, vc: self)
        case "Bishop":
            myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Bishop(frame: pawnFrame, color: pawnColor, vc: self)
        case "Rook":
            myChessGame.theChessBoard.board[pawnIndex.row][pawnIndex.col] = Rook(frame: pawnFrame, color: pawnColor, vc: self)
        default:
            break
        }
    }
    
    func promptForPawnPromotion() {
        if let pawnPromotion = myChessGame.getPawnToBePromoted() {
            let alertOptionPromotion = UIAlertController(title: "Pawn Promotion", message: "choose piece", preferredStyle: .alert)
            alertOptionPromotion.addAction(UIAlertAction(title: "Queen", style: .default, handler: { (action) in
                self.promote(pawn: pawnPromotion, into: "Queen")
                self.resumeGame()
            }))
            alertOptionPromotion.addAction(UIAlertAction(title: "Knight", style: .default, handler: { (action) in
                self.promote(pawn: pawnPromotion, into: "Knight")
                self.resumeGame()
            }))
            alertOptionPromotion.addAction(UIAlertAction(title: "Rook", style: .default, handler: { (action) in
                self.promote(pawn: pawnPromotion, into: "Rook")
                self.resumeGame()
            }))
            alertOptionPromotion.addAction(UIAlertAction(title: "Bishop", style: .default, handler: { (action) in
                self.promote(pawn: pawnPromotion, into: "Bishop")
                self.resumeGame()
            }))
            present(alertOptionPromotion, animated: true, completion: nil)
            
        }
        
    }
    func shouldPromotePawn() -> Bool {
        return (myChessGame.getPawnToBePromoted() != nil)
    }
    func checkIfPlayerIsCheckmated() {
        let somePlayerCheckmated = myChessGame.getPlayerCheckmated()
        
        if somePlayerCheckmated != nil {
            displayCheckOutlet.text = somePlayerCheckmated! + " have been Checkmated!"
            displayCheckOutlet.textColor = .red
        } else {
            displayCheckOutlet.text = nil
        }
    }
    func checkIfWinnerAppear() {
        if myChessGame.someBodyWin(){
            let alerWinner = UIAlertController(title: "Winner", message: myChessGame.winner, preferredStyle: UIAlertControllerStyle.alert)
            
            alerWinner.addAction(UIAlertAction(title: "Back to Manu", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "BackToManu", sender: self)
                
            }))
            
            self.present(alerWinner, animated: true, completion: nil)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pieceChessDragged = touches.first?.view as? UIChessPiece
        
        if pieceChessDragged != nil {
            sourceOrigin = pieceChessDragged.frame.origin
        }
        
        
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if pieceChessDragged != nil {
//           dragPiece(piece: pieceChessDragged, usingPan: panGestureOUTLET)
//        }
        
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch End")
            }
    func updateFromScreen() {
        displayTurnOutlet.text = myChessGame.isWhiteTurn ? "White's turn" : "Black's turn"
        displayTurnOutlet.textColor = myChessGame.isWhiteTurn ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

