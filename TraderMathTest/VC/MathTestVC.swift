//
//  MathTestVC.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 15/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//


import UIKit
import Foundation
import Toaster
import FirebaseAnalytics

class MathTestVC: BaseVC {
    
    //MARK: Constants
    private let preferences = UserDefaults.standard
    
    //MARK: Variables
    private var questionNumber:Int = 1
    private var myQuestions = [String]()
    private var correctAnswer: String?
    private var answer: String?
    private var correctAnswerDouble: Double = 0.0
    private var answerDouble: Double? = 0.0
    private var answerCorrect: Bool?
    private var highscore:Int = 0
    private var finishtime:String = "0"
    private var timer = Timer()
    private var time: Double = 0
    private var startTime: TimeInterval = 0.0
    private var filename:String = "easymath"
    
    //MARK: IBOutlets
    @IBOutlet weak var testTypeLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTf: UITextField!
    @IBOutlet weak var questionViewContainer: UIView!
    @IBOutlet weak var qnumLabel: UILabel!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    //MARK: Computed Properties
    var difficulty: Test.Level {
        if let string = UserDefaults.standard.string(forKey: Test.Key.DIFFICULTY_KEY.val),
           let type = Test.Level(rawValue: string) {
            return type
        }
        return .easy
    }
    
    var questionNum: Test.Count {
        readQuestionNum()
    }
    
    var PoT: Test.TType {
        if let string = UserDefaults.standard.string(forKey: Test.Key.POT_KEY.val),
           let type = Test.TType(rawValue: string) {
            return type
        }
        return .practice
    }
    
    var testType: Test.Category {
        if let string = UserDefaults.standard.string(forKey: Test.Key.TEST_TYPE_KEY.val),
           let type = Test.Category(rawValue: string) {
            return type
        }
        return .math
    }
    
    //MARK: Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRightBarBtnItem()
        registerForKeyboardNotifications()
    }
    
    override func viewWillLayoutSubviews() {
        questionViewContainer.border()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hidesRightBarBtnItem = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        readFile()
        startTime = Date.timeIntervalSinceReferenceDate
        answerTf.becomeFirstResponder()
        answerTf.delegate = self
        
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        calculateTimeAndScore()
        if let vc = segue.destination as? FinishTestVC {
            vc.highscore = highscore
            vc.finishtime = "\(finishtime)"
        }
    }
}

//MARK: Q/A Management
extension MathTestVC {
    
    // read user defaults
    func readQuestionNum() -> Test.Count {
        if PoT == .test {
            return testType == .math ? .eighty : .fifty
        }
        let integer = UserDefaults.standard.integer(forKey: Test.Key.QUESTNUM_KEY.val)
        if let type = Test.Count(rawValue: integer) {
            return type
        }
        return .five
    }
    
    // read selected file
    func readFile() {
        filename = difficulty.rawValue + testType.rawValue
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
    
    //read new question
    func newQuestion() {
        let randomIndex = Int(arc4random_uniform(UInt32(myQuestions.count/2))) * 2
        questionLbl.text = myQuestions[randomIndex]
        correctAnswer = myQuestions[randomIndex + 1]
        
        qnumLabel.text = "\(questionNumber)/\(questionNum.rawValue)"
        answerTf.text = ""
    }
    
    //check answer and update the view accordingly
    func checkAnswer() {
        answer = answerTf.text
        questionNumber += 1
        
        //Convert answer and correct answer so all forms are accepted (i.e. .67=0.67=000.67000
        answerDouble = (answer! as NSString).doubleValue
        correctAnswerDouble = (correctAnswer! as NSString).doubleValue
        
        if questionNumber <= questionNum.rawValue {
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
            Analytics.logEvent("kFIREventQuestionAnswered", parameters: [
                AnalyticsParameterItemID: "id-question_answered" as NSObject,
                "kFIRParameterTestType": testType.rawValue as NSObject, //Default: Math
                "kFIRParameterTestDifficulty": difficulty.rawValue as NSObject, //Default: easy
                "kFIRParameterAnswerCorrect": answerCorrect! as NSObject
            ])
        }
        else {
            time = Date.timeIntervalSinceReferenceDate - startTime
            self.performSegue(withIdentifier: "FinishTest", sender: highscore)
        }
    }
    
    //calculate total time after test
    func calculateTimeAndScore() {
        time = Double(round(1000*time)/1000)
        let minutes = UInt16(time/60.0)
        let seconds = UInt16(time) - (minutes*60)
        let milliseconds = Int((time*1000).truncatingRemainder(dividingBy: 1000))
        finishtime = String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
    }
}

//MARK: Navigation Bar
extension MathTestVC {
    
    func setupRightBarBtnItem() {
        self.customBarBtnItem = UIBarButtonItem(title: "Exit", style: .done, target: self, action: #selector(MathTestVC.finishTestClicked))
    }
    
    @objc func finishTestClicked() {
        let alert = UIAlertController(title: "Exit?", message: "Are you sure you want to end the test, your score won't be saved if you end it now?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "End Test", style: .default) { _ in
            self.goHome()
        })
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
        present(alert, animated: true)
    }
    
    func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
//MARK: Keyboard Management
extension MathTestVC {
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.keyboardHeightConstraint.constant = 0.0
        } else {
            self.keyboardHeightConstraint.constant = endFrame?.size.height ?? 0.0
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
    }
}

//MARK: Textfield delegate
extension MathTestVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty == false {
            self.checkAnswer()
        }
        else {
            Toast(text: "Please type your answer").show()
        }
        return false
    }
}
