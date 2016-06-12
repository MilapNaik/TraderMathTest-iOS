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
    var difficulty: String = "EASY"

    
    @IBOutlet weak var Easy: DLRadioButton!
    @IBOutlet weak var Medium: DLRadioButton!
    @IBOutlet weak var Hard: DLRadioButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readUserDefaults()
        setDifficulty()
        
    }
    
    func readUserDefaults(){
        difficulty = preferences.stringForKey(difficultyKey) ?? "EASY"
        
    }
    
    func setDifficulty(){
        if difficulty == "HARD"{
            Hard.selected = true
        }
        else if difficulty == "MEDIUM"{
            Medium.selected = true
        }
        else{
            Easy.selected = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    @IBAction func easyButton(sender: DLRadioButton) {
        preferences.setObject("EASY", forKey: difficultyKey)
        JLToast.makeText("Difficulty: Easy").show()
    }
    
    @IBAction func mediumButton(sender: DLRadioButton) {
        preferences.setObject("MEDIUM", forKey: difficultyKey)
        JLToast.makeText("Difficulty: Medium").show()
    }
    
    @IBAction func hardButton(sender: DLRadioButton) {
        preferences.setObject("HARD", forKey: difficultyKey)
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