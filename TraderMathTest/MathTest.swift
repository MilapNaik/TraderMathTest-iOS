//
//  mathTest.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/24/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit

class MathTestController: UIViewController {

    // MARK: Properties
    var data:String?
    var i:Int = 0
    var questionNumber:Int = 1
    
    
    var correctAnswer: String?
    var answer: String?
    var correctAnswerDouble: Double = 0.0
    var answerDouble: Double? = 0.0
    
    var highscore:Int = 0
    
    var finishtime:String = "0"
    var timer = NSTimer()
    var time: Double = 0
    var startTime: NSTimeInterval = 0.0
    

    
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var qnumLabel: UILabel!
    
    let preferences = NSUserDefaults.standardUserDefaults()
    let difficultyKey = "Difficulty"
    let questionnumKey = "QuestionNum"
    let PoTKey = "PoT"
    let testtypeKey = "TestType"
    var difficulty: String = "EASY"
    var questionNum: Int = 5
    var PoT:String = "Practice"
    var testType:String = "MATH"
    var filepath:String = "easymath"
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        readUserDefaults()
        readFile()
        qnumLabel.text = "\(questionNumber)/\(questionNum)"
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Read user defaults. If none exist, they are set to Easy and 5 questions
    func readUserDefaults(){
        
        testType = preferences.stringForKey(testtypeKey) ?? "MATH"
        difficulty = preferences.stringForKey(difficultyKey) ?? "EASY"
        PoT = preferences.stringForKey(PoTKey) ?? "Practice"
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
    
    // Read selected file
    func readFile(){
        if testType == "Seq"{
            if difficulty == "HARD"{
                filepath = "hardseq.txt"
            }
                
            else if difficulty == "MEDIUM"{
                filepath = "mediumseq.txt"
            }
                
            else{
                filepath = "easyseq.txt"
            }
        }
        else{
            if difficulty == "HARD"{
                filepath = "hardmath.txt"
            }
        
            else if difficulty == "MEDIUM"{
                filepath = "mediummath.txt"
            }
            
            else{
                filepath = "easymath.txt"
            }
        }
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(filepath)
            do{
                data = try NSString(contentsOfURL: path, encoding: NSUTF8StringEncoding)
            } catch {
                
            }
            
            if let content = data {
                let myStrings = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                
                
                let randomIndex = Int(arc4random_uniform(UInt32(myStrings.count/2))) * 2
                questionLabel.text = myStrings[randomIndex]
                correctAnswer = myStrings[randomIndex + 1]
            }
        }
        
    }

    // MARK: Actions
    @IBAction func n1Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "1"
    }
    @IBAction func n2Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "2"
    }
    @IBAction func n3Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "3"
    }
    @IBAction func n4Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "4"
    }
    @IBAction func n5Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "5"
    }
    @IBAction func n6Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "6"
    }
    @IBAction func n7Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "7"
    }
    @IBAction func n8Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "8"
    }
    @IBAction func n9Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "9"
    }
    @IBAction func n0Button(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "0"
    }
    @IBAction func ndotButton(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "."
    }
    @IBAction func ndashButton(sender: UIButton) {
        answerLabel.text = answerLabel.text! + "-"
    }

    
    
    
    
    @IBAction func clearButton(sender: UIButton) {
        answerLabel.text = ""
    }
    @IBAction func enterButton(sender: UIButton) {
        answer = answerLabel.text
        questionNumber += 1
        
        //Convert answer and correct answer so all forms are accepted (i.e. .67=0.67=000.67000
        answerDouble = (answer! as NSString).doubleValue
        correctAnswerDouble = (correctAnswer! as NSString).doubleValue
        
        if questionNumber > questionNum{
            time = NSDate.timeIntervalSinceReferenceDate() - startTime
            self.performSegueWithIdentifier("goestoFinishTest", sender: highscore)
        }
        else {
            if correctAnswerDouble == answerDouble{
                JLToast.makeText("Correct!").show()
                highscore += 1
            }
            else{
                JLToast.makeText("Incorrect: \(correctAnswer!)").show()
            }
            readFile()
        }
        
        qnumLabel.text = "\(questionNumber)/\(questionNum)"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        time = Double(round(1000*time)/1000)
        let minutes = UInt8(time/60.0)
        let seconds = UInt8(time) - (minutes*60)
        let milliseconds = Int((time*1000) % 1000)
        finishtime = String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
        
        if (segue.identifier == "goestoFinishTest") {
            let secondViewController = segue.destinationViewController as! FinishTestController
            let highscore = sender as! Int
            secondViewController.highscore = highscore
            secondViewController.finishtime = "\(finishtime)"

        }
    }
    
}

