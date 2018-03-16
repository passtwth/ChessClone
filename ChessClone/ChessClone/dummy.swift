//
//  dummy.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit

class Dummy: Piece {
    
    private var xStorage: CGFloat!
    private var yStorage: CGFloat!
    
    var x: CGFloat {
        get {
            return self.xStorage
        }
        set {
            self.xStorage = newValue
        }
    }
    var y: CGFloat {
        get {
            return self.yStorage
        }
        set {
            self.yStorage = newValue
        }
    }
    
    init(frame: CGRect) {
        self.xStorage = frame.origin.x
        self.yStorage = frame.origin.y
    }
    
    init() {
        
    }
}
