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

    
    //var otherButtons : [DLRadioButton] = [button1, button2];
    
    
    
    
    
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
    @IBAction func easyButton(sender: DLRadioButton) {
        preferences.setObject("Easy", forKey: difficultyKey)
        JLToast.makeText("Difficulty: Easy").show()
    }
    
    @IBAction func mediumButton(sender: DLRadioButton) {
        preferences.setObject("Medium", forKey: difficultyKey)
        JLToast.makeText("Difficulty: Medium").show()
    }
    
    @IBAction func hardButton(sender: DLRadioButton) {
        preferences.setObject("Hard", forKey: difficultyKey)
        JLToast.makeText("Difficulty: Hard").show()
    }
    
    @IBAction func fiveButton(sender: UIButton) {
        preferences.setInteger(5, forKey: questionnumKey)
        JLToast.makeText("Set to 5 questions").show()
    }
    @IBAction func tenButton(sender: UIButton) {
        preferences.setInteger(10, forKey: questionnumKey)
        JLToast.makeText("Set to 10 questions").show()
    }
    @IBAction func twentyButton(sender: UIButton) {
        preferences.setInteger(20, forKey: questionnumKey)
        JLToast.makeText("Set to 20 questions").show()
    }

    
    
}