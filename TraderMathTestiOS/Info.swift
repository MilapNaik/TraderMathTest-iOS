//
//  Info.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/23/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit

class InfoController: UIViewController {
    
    // MARK: Properties
    let difficultyKey = "Difficulty"
    var i:Int = 0
    
    @IBOutlet weak var difficultylevel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    
    
    
    // MARK: Actions
    


    @IBAction func difficultybutton(sender: UIButton) {

        difficultylevel.text = "0"
        
    }
    
}
