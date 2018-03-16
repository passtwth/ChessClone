//
//  extensionUIChessPiece.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit
typealias  UIChessPiece = UILabel

extension UIChessPiece: Piece {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    var color: UIColor {
        get {
            return self.textColor
        }
    }
}
