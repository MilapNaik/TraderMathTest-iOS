//
//  FinishTestVC.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 17/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//
import Foundation
import UIKit
import GoogleMobileAds
import FirebaseAnalytics
import FirebaseDatabase
import AppTrackingTransparency
import AdSupport

class FinishTestVC: BaseVC {
    
    private let HIGH_SCORE_CELL = "HighScoreCell"
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLbl: UILabel!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var correctAnswersView: UIView!
    @IBOutlet weak var correctAnswersLbl: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var leaderboardLabel: UILabel!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var highscore: Int = 0
    var finishtime: String = ""
    
    // MARK: Properties
    let db = SQLiteDB.shared
    var bestRank: [String] = ["1", "2", "3", "4", "5"]
    var bestScore: [String] = ["-----", "-----", "-----", "-----", "-----"]
    var bestTime: [String] = ["-----", "-----", "-----", "-----", "-----"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = db.open()
        
        tableView.register(UINib(nibName: HIGH_SCORE_CELL, bundle: nil), forCellReuseIdentifier: HIGH_SCORE_CELL)
        //        requestIDFA()
        addhighscore()
        loadhighscores()
        //        Test.text = "\(testType) \(PoT)"
        //        Leaderboard.text = "\(questionNum) \(difficulty) Questions"
//        print("\(highscore) \(finishtime)")
    }
    
    override func viewWillLayoutSubviews() {
        scoreView.roundedBorders()
        timeView.roundedBorders()
        correctAnswersView.border(color: .black)
        correctAnswersView.roundedBorders()
        
        //        scoreView.dropShadow()
        //        timeView.dropShadow()
        //        correctAnswersView.dropShadow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        correctAnswersLbl.text = String(highscore)
        scoreLbl.text = String(highscore)
        timeLbl.text = String(finishtime)
        logToAnalytics()
    }
    
    // MARK: Actions
    @IBAction func tryAgainClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: UITableView Delegate
extension FinishTestVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestRank.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIGH_SCORE_CELL, for: indexPath) as! HighScoreCell
        
        cell.rankLbl.text = self.bestRank[indexPath.row]
        cell.scoreDetailsLbl.text = "Score: \(self.bestScore[indexPath.row]) Time: \(self.bestTime[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

//MARK: DB
extension FinishTestVC {
    
    func addhighscore() {
        // _ is set to avoid warning
        _ = db.execute(sql: "INSERT INTO \(difficulty.rawValue)_\(testType.rawValue)_\(questionNum.rawValue) (Score, Time) Values ('\(highscore)', '\(finishtime)'); ", parameters:nil)
        
        //don't sync the practice scores
        if PoT == .test {
            let ref = Database.database().reference()
            ref.child("leaderboard")
                .childByAutoId()
                .setValue (
                [ "date" : Date().description,
                  "score" : highscore,
                  "difficulty" : difficulty.rawValue,
                  "test_type" : testType.rawValue,
                  "total_questions" : questionNum.rawValue,
                  "time" : finishtime ] )
        }
    }
    
    func loadhighscores() {
        let result = db.query(sql: "SELECT * from \(difficulty.rawValue)_\(testType.rawValue)_\(questionNum.rawValue) ORDER BY Score DESC, Time ASC LIMIT 5", parameters: nil)
        
        for (index,row) in result.enumerated() {
            bestScore[index] = String(describing: row["Score"]!)
            bestTime[index] = String(describing: row["Time"]!)
        }
    }
    
}

//MARK: User Defaults
extension FinishTestVC {
    /// Read user defaults. If none exist, they are set to Easy and 5 questions
    ///
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

}

//MARK: Ads
extension FinishTestVC {
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    self.loadAds()
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        } else {
            // Fallback on earlier versions
            self.loadAds()
        }
    }
    
    func loadAds() {
        bannerView.adUnitID = "ca-app-pub-3095210410543033/2188670103" //Real Ad unit: ca-app-pub-3095210410543033/2188670103
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

//MARK: Analytics
extension FinishTestVC {
    func logToAnalytics() {
        
        //Analytics
        Analytics.logEvent("kFIREventTestFinished", parameters: [
            AnalyticsParameterItemID: "id-test_finished" as NSObject,
            "kFIRParameterTestType": testType.rawValue as NSObject, //Default: Math
            "kFIRParameterTestDifficulty": difficulty.rawValue as NSObject, //Default: easy
            "kFIRParameterTestLength": questionNum.rawValue as NSObject, //Default: 5
            "kFIRParameterTestPoT": PoT.rawValue as NSObject, //Default: Practice
            "kFIRParameterQuestionsCorrect": highscore as NSObject
        ])
        
    }
}
