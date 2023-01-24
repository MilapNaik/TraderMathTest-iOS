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
import FirebaseDatabase

class MainVC: BaseVC {
    
    // MARK: Constants
    private let preferences = UserDefaults.standard
    
    // MARK: Properties
    private var testType: Test.TType = .practice
    
    //MARK: IBOutlets
    @IBOutlet weak var sequenceLbl: UILabel!
    @IBOutlet weak var mathTestLbl: UILabel!
    @IBOutlet weak var sequenceTestView: UIView!
    @IBOutlet weak var mathTestView: UIView!
    @IBOutlet weak var bottomSelectionView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var practiceQuestionsStackView: UIView!
    
    //Bottom Selection View
    @IBOutlet weak var practiceBtn: UIButton!
    @IBOutlet weak var testBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    //Settings Screen
    @IBOutlet weak var fiveQuestionsBtn: UIButton!
    @IBOutlet weak var tenQuestionsBtn: UIButton!
    @IBOutlet weak var fifteenQuestionsBtn: UIButton!
    @IBOutlet weak var easyLevelBtn: UIButton!
    @IBOutlet weak var mediumLevelBtn: UIButton!
    @IBOutlet weak var hardLevelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mock Data for testing purposes
//        let ref = Database.database().reference()
//        for _ in 1...20 {
//            ref.child("leaderboard").childByAutoId().setValue(
//                [ "date" : Date().description,
//                  "score" : Int.random(in: 10..<50),
//                  "difficulty" : Test.Level.hard.rawValue,
//                  "test_type" : Test.Category.sequence.rawValue,
//                  "total_questions" : 50,
//                  "time" : "00:54.280"] )
//        }
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
        resetAllViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestIDFA()
    }
    
    // MARK: IBActions
    @IBAction func practiceClicked() {
        testType = .practice
        preferences.set(testType.rawValue, forKey: Test.Key.POT_KEY.val)
        showSettingsView()
    }
    
    @IBAction func testClicked() {
        testType = .test
        preferences.set(testType.rawValue, forKey: Test.Key.POT_KEY.val)
        showSettingsView()
    }
    
    @IBAction func questionsCountClicked(_ sender: DLRadioButton) {
        
        guard let intVal = Int(sender.titleLabel!.text!),
              let count = Test.Count(rawValue: intVal) else { return }
        
        preferences.set(count.rawValue, forKey: Test.Key.POT_KEY.val)
    }
    
    @IBAction func levelDifficultyClicked(_ sender: DLRadioButton) {
        
        guard let senderString = sender.titleLabel?.text?.lowercased(),
              let level = Test.Level(rawValue: senderString) else { return }
        preferences.set(level.rawValue, forKey: Test.Key.DIFFICULTY_KEY.val)
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
        updateSettingsView()
    }
    
    func updateSettingsView() {
        let _ = practiceQuestionsStackView.subviews.map { $0.isHidden = testType != .practice }
    }
    
    func resetAllViews() {
        bottomSelectionView.isHidden = true
        settingsView.isHidden = true
        mathTestView.backgroundColor = .systemBackground
        sequenceTestView.backgroundColor = .systemBackground
        settingsView.backgroundColor = .systemBackground
    }
    
    // MARK: Gesture
    func addGestureToViews() {
        let tapGestureForSequence = UITapGestureRecognizer(target: self, action: #selector(MainVC.sequenceClicked))
        sequenceTestView.addGestureRecognizer(tapGestureForSequence)
        
        let tapGestureForMathTest = UITapGestureRecognizer(target: self, action: #selector(MainVC.mathTestClicked))
        mathTestView.addGestureRecognizer(tapGestureForMathTest)
    }
    
    @objc func sequenceClicked() {
        
        sequenceLbl.textColor = .systemBackground
        mathTestLbl.textColor = .label
        sequenceTestView.backgroundColor = .lightPrimary
        mathTestView.backgroundColor = .systemBackground
        
        //Save preferences
        preferences.set(
            Test.Category.sequence.rawValue,
            forKey: Test.Key.TEST_TYPE_KEY.val)
        
        showBottomSelectionView()
    }
    
    @objc func mathTestClicked() {
        
        sequenceLbl.textColor = .label
        mathTestLbl.textColor = .systemBackground
        sequenceTestView.backgroundColor = .systemBackground
        mathTestView.backgroundColor = .lightPrimary
        //Save preferences
        preferences.set(
            Test.Category.math.rawValue,
            forKey: Test.Key.TEST_TYPE_KEY.val)
        
        showBottomSelectionView()
    }
    
    //MARK: User Defaults
    func readUserDefaults() {
        //Default settings not saved - first run of the app
        if !preferences.bool(forKey: Test.Key.SETTINGS_SAVED_KEY.val) {
            saveDefaultValues()
        }
        else {
            readQuestionCountDefaults()
            readDifficultyUserDefaults()
        }
    }
    
    fileprivate func readDifficultyUserDefaults() {
        if let difficultyString = preferences.object(forKey: Test.Key.DIFFICULTY_KEY.val) as? String,
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
        let savedQuestionsCount = preferences.integer(forKey: Test.Key.QUESTNUM_KEY.val)
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
        preferences.set(Test.Count.five.rawValue, forKey: Test.Key.QUESTNUM_KEY.val)
        preferences.set(Test.Level.easy.rawValue, forKey: Test.Key.DIFFICULTY_KEY.val)
        preferences.set(true, forKey: Test.Key.SETTINGS_SAVED_KEY.val)
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
