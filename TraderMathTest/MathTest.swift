//
//  mathTest.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/24/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics

class MathTestController: UIViewController {

    // MARK: Properties
    //var data:String?
    var i:Int = 0
    var questionNumber:Int = 1
    
    var myQuestions = [String]()
    var correctAnswer: String?
    var answer: String?
    var correctAnswerDouble: Double = 0.0
    var answerDouble: Double? = 0.0
    var answerCorrect: Bool?
    
    var highscore:Int = 0
    
    var finishtime:String = "0"
    var timer = Timer()
    var time: Double = 0
    var startTime: TimeInterval = 0.0
    

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var qnumLabel: UILabel!
    
    let preferences = UserDefaults.standard
    let difficultyKey = "Difficulty"
    let questionnumKey = "QuestionNum"
    let PoTKey = "PoT"
    let testtypeKey = "TestType"
    var difficulty: String = "easy"
    var questionNum: Int = 5
    var PoT:String = "Practice"
    var testType:String = "math"
    var filename:String = "easymath"
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        readUserDefaults()
        readFile()
        qnumLabel.text = "\(questionNumber)/\(questionNum)"
        startTime = Date.timeIntervalSinceReferenceDate

        FIRAnalytics.logEvent( withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-test_started" as NSObject,
            kFIRParameterTestType: testType as NSObject, //Default: Math
            kFIRParameterTestDifficulty: difficulty as NSObject, //Default: easy
            kFIRParameterTestLength: questionNum as NSObject, //Default: 5
            kFIRParameterTestPoT: PoT as NSObject //Default: Practice
        ])
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
            if testType == "sequence"{
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
    
    // Read selected file
    func readFile(){
        filename = difficulty.lowercased() + testType.lowercased()

            
        if let path = Bundle.main.path(forResource: filename, ofType: "txt"){
            do {
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                myQuestions = data.components(separatedBy: CharacterSet.newlines)
                
                newQuestion()
                
            } catch{
                print("Error: \(error)")
            }
        }
    }
    
    func newQuestion(){
        let randomIndex = Int(arc4random_uniform(UInt32(myQuestions.count/2))) * 2
        questionLabel.text = myQuestions[randomIndex]
        correctAnswer = myQuestions[randomIndex + 1]
        
        qnumLabel.text = "\(questionNumber)/\(questionNum)"
        answerLabel.text = ""
    }
    

    // MARK: Actions
    @IBAction func n1Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "1"
    }
    @IBAction func n2Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "2"
    }
    @IBAction func n3Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "3"
    }
    @IBAction func n4Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "4"
    }
    @IBAction func n5Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "5"
    }
    @IBAction func n6Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "6"
    }
    @IBAction func n7Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "7"
    }
    @IBAction func n8Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "8"
    }
    @IBAction func n9Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "9"
    }
    @IBAction func n0Button(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "0"
    }
    @IBAction func ndotButton(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "."
    }
    @IBAction func ndashButton(_ sender: UIButton) {
        answerLabel.text = answerLabel.text! + "-"
    }

    
    
    
    @IBAction func clearButton(_ sender: UIButton) {
        answerLabel.text = ""
    }
    
    @IBAction func enterButton(_ sender: UIButton) {
        answer = answerLabel.text
        questionNumber += 1
        
        //Convert answer and correct answer so all forms are accepted (i.e. .67=0.67=000.67000
        answerDouble = (answer! as NSString).doubleValue
        correctAnswerDouble = (correctAnswer! as NSString).doubleValue
        
        if questionNumber <= questionNum{
            if correctAnswerDouble == answerDouble{
                let correctToast = Toast(text: "Correct!", duration: Delay.short)
                correctToast.show()
                highscore += 1
                answerCorrect = true
            }
            else{
                let incorrectToast = Toast(text: "Incorrect: \(correctAnswer!)", duration: Delay.short)
                incorrectToast.show()
                answerCorrect = false
            }
            newQuestion()
            
            //Analytics answerCorrect
            FIRAnalytics.logEvent( withName: kFIREventQuestionAnswered, parameters: [
                kFIRParameterItemID: "id-question_answered" as NSObject,
                kFIRParameterTestType: testType as NSObject, //Default: Math
                kFIRParameterTestDifficulty: difficulty as NSObject, //Default: easy
                kFIRParameterAnswerCorrect: answerCorrect! as NSObject
                ])
        }
        else {
            time = Date.timeIntervalSinceReferenceDate - startTime
            self.performSegue(withIdentifier: "goestoFinishTest", sender: highscore)
        }
    }
    
    //Calculate total time took during test and transition to end of test screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        time = Double(round(1000*time)/1000)
        let minutes = UInt8(time/60.0)
        let seconds = UInt8(time) - (minutes*60)
        let milliseconds = Int((time*1000).truncatingRemainder(dividingBy: 1000))
        finishtime = String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
        
        if (segue.identifier == "goestoFinishTest") {
            let secondViewController = segue.destination as! FinishTestController
            let highscore = sender as! Int
            secondViewController.highscore = highscore
            secondViewController.finishtime = "\(finishtime)"
        }
    }
}

