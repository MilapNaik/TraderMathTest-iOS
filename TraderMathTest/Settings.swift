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
    let preferences = UserDefaults.standard
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
        if preferences.string(forKey: difficultyKey) != nil{
            difficulty = preferences.string(forKey: difficultyKey)!
        }
        
    }
    
    func setDifficulty(){
        if difficulty == "HARD"{
            Hard.isSelected = true
        }
        else if difficulty == "MEDIUM"{
            Medium.isSelected = true
        }
        else{
            Easy.isSelected = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    @IBAction func easyButton(_ sender: DLRadioButton) {
        preferences.set("EASY", forKey: difficultyKey)
        JLToast.makeText("Difficulty: Easy").show()
    }
    
    @IBAction func mediumButton(_ sender: DLRadioButton) {
        preferences.set("MEDIUM", forKey: difficultyKey)
        JLToast.makeText("Difficulty: Medium").show()
    }
    
    @IBAction func hardButton(_ sender: DLRadioButton) {
        preferences.set("HARD", forKey: difficultyKey)
        JLToast.makeText("Difficulty: Hard").show()
    }
    
    @IBAction func fiveButton(_ sender: UIButton) {
        preferences.set(5, forKey: questionnumKey)
        JLToast.makeText("Set to 5 questions").show()
    }
    @IBAction func tenButton(_ sender: UIButton) {
        preferences.set(10, forKey: questionnumKey)
        JLToast.makeText("Set to 10 questions").show()
    }
    @IBAction func twentyButton(_ sender: UIButton) {
        preferences.set(20, forKey: questionnumKey)
        JLToast.makeText("Set to 20 questions").show()
    }

    
    
}
