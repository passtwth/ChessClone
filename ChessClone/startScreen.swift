//
//  startScreen.swift
//  ChessClone
//
//  Created by HuangMing on 2017/6/28.
//  Copyright © 2017年 Fruit. All rights reserved.
//

import UIKit

class startscreen: UIViewController {
    
    @IBOutlet weak var startGame: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? ViewController
        if segue.identifier == "multiplayer" {
            destVC?.isAgainstAI = false
        }
        if segue.identifier == "singlePlay" {
            destVC?.isAgainstAI = true
        }
    }
    
    @IBAction func unwindController(segue: UIStoryboardSegue) {
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       startGame.layer.cornerRadius = 5
    }
}

