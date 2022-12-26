//
//  ViewController.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/17/16.
//  Copyright (c) 2016 Gamelap Studios LLC. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import DLRadioButton

enum Test: CaseIterable {
    
    enum ScoreType: String, CaseIterable {
        case local = "local"
        case global = "global"
    }
    enum Level: String, CaseIterable  {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
    }
    
    enum Count: Int, CaseIterable  {
        case five = 5
        case ten = 10
        case fifteen = 15
        case fifty = 50
        case eighty = 80
    }
    
    enum TType: String, CaseIterable  {
        case practice = "practice"
        case test = "test"
    }
    
    enum Category: String, CaseIterable  {
        case math = "math"
        case sequence = "sequence"
    }
}

class MainVC: BaseVC {
    
    // MARK: Constants
    let preferences = UserDefaults.standard
    let difficultyKey = "Difficulty"
    let questionnumKey = "QuestionNum"
    let PoTKey = "PoT"
    
    // MARK: Properties
    private let testtypeKey = "TestType"
    private var testType:String?
    private var difficulty: String = "easy"
    
    //MARK: IBOutlets
    @IBOutlet weak var sequenceTestView: UIView!
    @IBOutlet weak var mathTestView: UIView!
    @IBOutlet weak var practiceBtn: UIButton!
    @IBOutlet weak var testBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var bottomSelectionView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var fiveQuestionsBtn: UIButton!
    @IBOutlet weak var tenQuestionsBtn: UIButton!
    @IBOutlet weak var fifteenQuestionsBtn: UIButton!
    @IBOutlet weak var easyLevelBtn: UIButton!
    @IBOutlet weak var mediumLevelBtn: UIButton!
    @IBOutlet weak var hardLevelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    override func viewWillLayoutSubviews() {
        sequenceTestView.dropShadow()
        mathTestView.dropShadow()
        practiceBtn.roundedBorders(radius: 4)
        testBtn.roundedBorders(radius: 4)
        startBtn.roundedBorders(radius: 4)
        settingsView.dropShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readUserDefaults()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestIDFA()
    }
    
    // MARK: IBActions
    @IBAction func practiceClicked() {
        preferences.set(Test.TType.practice.rawValue, forKey: PoTKey)
        showSettingsView()
    }
    
    @IBAction func testClicked() {
        preferences.set(Test.TType.test.rawValue, forKey: PoTKey)
        showSettingsView()
    }
    
    @IBAction func questionsCountClicked(_ sender: DLRadioButton) {
        guard let intVal = Int(sender.titleLabel!.text!),
        let count = Test.Count(rawValue: intVal) else { return }
        
        preferences.set(count.rawValue, forKey: questionnumKey)
    }
    
    @IBAction func levelDifficultyClicked(_ sender: DLRadioButton) {
        guard let senderString = sender.titleLabel?.text?.lowercased(), let level = Test.Level(rawValue: senderString) else { return }
    
        preferences.set(level.rawValue, forKey: difficultyKey)
    }
    
    @IBAction func startClicked() {
        self.performSegue(withIdentifier: "MathTest", sender: nil)
    }
    
    @IBAction func closeSettingsView() {
        showBottomSelectionView()
    }
    
    // MARK: View
    func viewSetup() {
        self.addGestureToViews()
    }
    
    func showBottomSelectionView() {
        bottomSelectionView.isHidden = false
        settingsView.isHidden = true
    }
    
    func showSettingsView() {
        bottomSelectionView.isHidden = true
        settingsView.isHidden = false
    }
    
    // MARK: Gesture
    func addGestureToViews() {
        let tapGestureForSequence = UITapGestureRecognizer(target: self, action: #selector(MainVC.sequenceClicked))
        sequenceTestView.addGestureRecognizer(tapGestureForSequence)
        
        let tapGestureForMathTest = UITapGestureRecognizer(target: self, action: #selector(MainVC.mathTestClicked))
        mathTestView.addGestureRecognizer(tapGestureForMathTest)
    }
    
    @objc func sequenceClicked() {
        sequenceTestView.backgroundColor = .lightPrimary
        mathTestView.backgroundColor = .white
        preferences.set(Test.Category.sequence.rawValue, forKey: testtypeKey)
        showBottomSelectionView()
    }
    
    @objc func mathTestClicked() {
        sequenceTestView.backgroundColor = .white
        mathTestView.backgroundColor = .lightPrimary
        preferences.set(Test.Category.math.rawValue, forKey: testtypeKey)
        showBottomSelectionView()
    }
    
    //MARK: User Defaults
    func readUserDefaults() {
        //Default settings not saved - first run of the app
        if !preferences.bool(forKey: "SETTINGS_SAVED_KEY") {
            saveDefaultValues()
        }
        else {
            readQuestionCountDefaults()
            readDifficultyUserDefaults()
        }
    }
    
    fileprivate func readDifficultyUserDefaults() {
        if let difficultyString = preferences.object(forKey: difficultyKey) as? String,
           let levelType = Test.Level(rawValue: difficultyString) {
            switch levelType {
            case .easy:
                easyLevelBtn.isSelected = true
            case .medium:
                mediumLevelBtn.isSelected = true
            case .hard:
                hardLevelBtn.isSelected = true
            }
        }
    }
    
    fileprivate func readQuestionCountDefaults() {
        let savedQuestionsCount = preferences.integer(forKey: questionnumKey)
        if savedQuestionsCount > 0, let countType = Test.Count(rawValue: savedQuestionsCount) {
            switch countType {
            case .five:
                fiveQuestionsBtn.isSelected = true
            case .ten:
                tenQuestionsBtn.isSelected = true
            case .fifteen:
                fifteenQuestionsBtn.isSelected = true
            default:
                print("Unknown")
            }
        }
    }
    
    fileprivate func saveDefaultValues() {
        preferences.set(Test.Count.five.rawValue, forKey: questionnumKey)
        preferences.set(Test.Level.easy.rawValue, forKey: difficultyKey)
        preferences.set(true, forKey: "SETTINGS_SAVED_KEY")
    }
    
    //MARK: IDFA
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    #if DEBUG
                    print("Authorized")
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                    #endif
                default:
                    print("Unknown")
                }
            }
        }
    }
}
