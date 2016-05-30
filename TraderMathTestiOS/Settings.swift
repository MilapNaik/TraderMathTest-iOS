//
//  Settings.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/23/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    // MARK: Properties

    
    
    
    // Preferences for difficulty level of questions
    let preferences = NSUserDefaults.standardUserDefaults()
    let difficultyKey = "Difficulty"
    let questionnumKey = "QuestionNum"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    
    
    
    // MARK: Actions
    @IBAction func easyButton(sender: UIButton) {
        preferences.setObject("Easy", forKey: difficultyKey)
    }

    @IBAction func mediumButton(sender: UIButton) {
        preferences.setObject("Medium", forKey: difficultyKey)
    }
    @IBAction func hardButton(sender: UIButton) {
        preferences.setObject("Hard", forKey: difficultyKey)
    }
    @IBAction func fiveButton(sender: UIButton) {
        preferences.setInteger(5, forKey: questionnumKey)
    }
    @IBAction func tenButton(sender: UIButton) {
        preferences.setInteger(10, forKey: questionnumKey)
    }
    @IBAction func twentyButton(sender: UIButton) {
        preferences.setInteger(20, forKey: questionnumKey)
    }

    
    
}