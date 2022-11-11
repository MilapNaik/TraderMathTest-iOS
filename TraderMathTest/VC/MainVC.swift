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

enum Test {
    
    enum Level: String {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
    }
    enum Count: Int {
        case five = 5
        case ten = 10
        case fifteen = 15
    }
    enum TType: String {
        case practice = "Practice"
        case test = "test"
    }
}
class MainVC: UIViewController {
    
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
        guard let intVal = Int(sender.titleLabel!.text!) else { return }
        let qCount = Test.Count(rawValue: intVal)
        preferences.set(qCount!.rawValue, forKey: questionnumKey)
    }
    
    @IBAction func levelDifficultyClicked(_ sender: DLRadioButton) {
        guard let senderString = sender.titleLabel?.text?.lowercased() else { return }
        let level = Test.Level(rawValue: senderString)
        preferences.set(level!.rawValue, forKey: difficultyKey)
    }
    
    @IBAction func startClicked() {
        print("Start Test")
    }
    
    // MARK: View
    func viewSetup() {
        self.addGestureToViews()
    }
    
    func showBottomSelectionView() {
        bottomSelectionView.isHidden = false
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
        showBottomSelectionView()
    }
    
    @objc func mathTestClicked() {
        showBottomSelectionView()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "goestoPoTMath") {
            testType = "math"
        } else if (segue.identifier == "goestoPoTSeq") {
            testType = "sequence"
        } else{
            testType = "percent"
        }
        preferences.set(testType, forKey: testtypeKey)
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
