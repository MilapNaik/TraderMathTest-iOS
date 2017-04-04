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
    var difficulty: String = "easy"

    
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
        if difficulty == "hard"{
            Hard.isSelected = true
        }
        else if difficulty == "medium"{
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
        preferences.set("easy", forKey: difficultyKey)
        let easyToast = Toast(text: "Difficulty: Easy", duration: Delay.long)
        easyToast.show()
    }
    
    @IBAction func mediumButton(_ sender: DLRadioButton) {
        preferences.set("medium", forKey: difficultyKey)
        let mediumToast = Toast(text: "Difficulty: Medium", duration: Delay.long)
        mediumToast.show()
    }
    
    @IBAction func hardButton(_ sender: DLRadioButton) {
        preferences.set("hard", forKey: difficultyKey)
        let hardToast = Toast(text: "Difficulty: Hard", duration: Delay.long)
        hardToast.show()
    }
    
    @IBAction func fiveButton(_ sender: UIButton) {
        preferences.set(5, forKey: questionnumKey)
        let fiveToast = Toast(text: "Set to 5 questions", duration: Delay.long)
        fiveToast.show()
    }
    @IBAction func tenButton(_ sender: UIButton) {
        preferences.set(10, forKey: questionnumKey)
        let tenToast = Toast(text: "Set to 10 questions", duration: Delay.long)
        tenToast.show()
    }
    @IBAction func twentyButton(_ sender: UIButton) {
        preferences.set(20, forKey: questionnumKey)
        let twentyToast = Toast(text: "Set to 20 questions", duration: Delay.long)
        twentyToast.show()
    }
}
