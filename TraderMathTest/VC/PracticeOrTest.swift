//
//  PracticeOrTest.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/24/16.
//  Copyright (c) 2016 Gamelap Studios LLC. All rights reserved.
//

import Foundation
import UIKit

class PoTController: UIViewController {
    
    // MARK: Properties
    var PoT:String?
    
    // Preferences for Practice or Test
    let preferences = UserDefaults.standard
    let PoTKey = "PoT"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func PracticeButton(_ sender: UIButton) {
        preferences.set("Practice", forKey: PoTKey)
    }
    @IBAction func TestButton(_ sender: UIButton) {
        preferences.set("Test", forKey: PoTKey)
    }

}

