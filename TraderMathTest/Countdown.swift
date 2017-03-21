//
//  Countdown.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/24/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit

class CountdownController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var Test: UILabel!
    @IBOutlet weak var Leaderboard: UILabel!
    
    var timer:Timer?
    var count = 3

    
    let preferences = UserDefaults.standard
    let difficultyKey = "Difficulty"
    let questionnumKey = "QuestionNum"
    let PoTKey = "PoT"
    let testtypeKey = "TestType"
    var difficulty: String = "EASY"
    var questionNum: Int = 5
    var PoT:String = "Practice"
    var testType:String = "MATH"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readUserDefaults()
        testType = testType.capitalized
        difficulty = difficulty.capitalized
        
        countDownLabel.textAlignment = .center
        Test.text = "\(testType) \(PoT)"
        Leaderboard.text = "\(questionNum) \(difficulty) Questions"
        
        DispatchQueue.main.async {
            self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(CountdownController.update), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    
    func update() {
        if(count > 0) {
            countDownLabel.text = String(count)
            count-=1
        }
        else {
            timer!.invalidate()
        self.performSegue(withIdentifier: "goestoMathTest", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Read user defaults. If none exist, they are set to Easy and 5 questions
    func readUserDefaults(){
        if preferences.string(forKey: testtypeKey) != nil{
            testType = preferences.string(forKey: testtypeKey)!
        }

        if preferences.string(forKey: difficultyKey) != nil{
            difficulty = preferences.string(forKey: difficultyKey)!
        }
        
        if preferences.string(forKey: PoTKey) != nil{
            PoT = preferences.string(forKey: PoTKey)!
        }
        
        if PoT == "Test"{
            if testType == "SEQ"{
                questionNum = 50
            }
            else{
                questionNum = 80
            }
        }
        else{
            if preferences.integer(forKey: questionnumKey) == 0{
                questionNum = 5
            }
            else {
                questionNum = preferences.integer(forKey: questionnumKey)
            }
        }
        
    }
    
}
