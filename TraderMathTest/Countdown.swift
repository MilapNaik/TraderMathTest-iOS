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
    
    var timer:NSTimer?
    var count = 3

    
    let preferences = NSUserDefaults.standardUserDefaults()
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
        testType = testType.capitalizedString
        difficulty = difficulty.capitalizedString
        
        Test.text = "\(testType) \(PoT)"
        Leaderboard.text = "\(questionNum) \(difficulty) Questions"
        
        dispatch_async(dispatch_get_main_queue()) {
            self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(CountdownController.update), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    
    func update() {
        if(count > 0) {
            countDownLabel.text = String(count)
            count-=1
        }
        else {
            timer!.invalidate()
        self.performSegueWithIdentifier("goestoMathTest", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Read user defaults. If none exist, they are set to Easy and 5 questions
    func readUserDefaults(){
        testType = preferences.stringForKey(testtypeKey)! ?? "MATH"
        difficulty = preferences.stringForKey(difficultyKey)! ?? "EASY"
        PoT = preferences.stringForKey(PoTKey)! ?? "Practice"
        if PoT == "Test"{
            if testType == "SEQ"{
                questionNum = 50
            }
            else{
                questionNum = 80
            }
        }
        else{
            questionNum = preferences.integerForKey(questionnumKey) ?? 5
        }
        
    }
    
}
