//
//  FinishTestVC.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 17/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//

import UIKit

class FinishTestVC: BaseVC {

    var highscore: Int = 0
    var finishtime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(highscore) \(finishtime)")
    }
    
}
