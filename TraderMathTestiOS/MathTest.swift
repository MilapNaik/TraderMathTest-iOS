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
    var i:Int = 0
    var questionNumber:Int = 1
    var correctAnswer: String?
    var highscore:Int = 2
    var finishtime:String?
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var qnumLabel: UILabel!
    
    let preferences = NSUserDefaults.standardUserDefaults()
    let difficultyKey = "Difficulty"
    let questionnumKey = "QuestionNum"
    var difficulty: String = "Easy"
    var testLength: Int = 5
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        readFile()
        readUserDefaults()
        qnumLabel.text = "\(questionNumber)/\(testLength)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Read selected file
    func readFile(){
        
        if difficulty == "Hard"{
        if let path = NSBundle.mainBundle().pathForResource("hardmath", ofType: "txt"){
            var data = String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)
            
            if let content = data {
                let myStrings = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                
                
                let randomIndex = Int(arc4random_uniform(UInt32(myStrings.count/2))) * 2
                questionLabel.text = myStrings[randomIndex]
                //answerLabel.text = myStrings[randomIndex + 1]
                correctAnswer = myStrings[randomIndex + 1]
            }
        }
        }
        
        else if difficulty == "Medium"{
            if let path = NSBundle.mainBundle().pathForResource("mediummath", ofType: "txt"){
                var data = String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)
                
                if let content = data {
                    let myStrings = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                    
                    
                    let randomIndex = Int(arc4random_uniform(UInt32(myStrings.count/2))) * 2
                    questionLabel.text = myStrings[randomIndex]
                    //answerLabel.text = myStrings[randomIndex + 1]
                    correctAnswer = myStrings[randomIndex + 1]
                }
            }
        }
            
        else{
            if let path = NSBundle.mainBundle().pathForResource("easymath", ofType: "txt"){
                var data = String(contentsOfFile:path, encoding: NSUTF8StringEncoding, error: nil)
                
                if let content = data {
                    let myStrings = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
                    
                    
                    let randomIndex = Int(arc4random_uniform(UInt32(myStrings.count/2))) * 2
                    questionLabel.text = myStrings[randomIndex]
                    //answerLabel.text = myStrings[randomIndex + 1]
                    correctAnswer = myStrings[randomIndex + 1]
                }
            }
            
        }
    }
    
    // Read user defaults. If none exist, they are set to Easy and 5 questions
    func readUserDefaults(){
        
        let difficulty = preferences.stringForKey(difficultyKey)
        let testLength = preferences.integerForKey(questionnumKey)
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
        let answer = answerLabel.text
        if correctAnswer == answer{
            answerLabel.text = "correct"
            questionNumber++
            highscore++
            readFile()
        }
        else{
            questionNumber++
            readFile()
        }
        
        qnumLabel.text = "\(questionNumber)/\(testLength)"
        if questionNumber == testLength{
            self.performSegueWithIdentifier("goestoFinishTest", sender: highscore)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goestoFinishTest") {
            let secondViewController = segue.destinationViewController as! FinishTestController
            let highscore = sender as! Int
            secondViewController.highscore = highscore
        }
    }
    
}

