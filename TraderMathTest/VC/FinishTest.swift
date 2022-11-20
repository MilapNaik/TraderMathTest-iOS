//
//  FinishTest.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/26/16.
//  Copyright (c) 2016 Gamelap Studios LLC. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import FirebaseAnalytics
import AppTrackingTransparency
import AdSupport

class FinishTestController: UIViewController {
    // MARK: Properties
    var i: Int = 0
    var highscore:Int?
    var finishtime:String?
    
    let db = SQLiteDB.shared
    var bestRank: [String] = ["1", "2", "3", "4", "5"]
    var bestScore: [String] = ["-----", "-----", "-----", "-----", "-----"]
    var bestTime: [String] = ["-----", "-----", "-----", "-----", "-----"]
    
    let preferences = UserDefaults.standard
    let difficultyKey = "Difficulty"
    let questionnumKey = "QuestionNum"
    let PoTKey = "PoT"
    let testtypeKey = "TestType"
    var difficulty: String = "easy"
    var questionNum: Int = 5
    var PoT:String = "Practice"
    var testType:String = "math"

    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var correctAnswers: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    
    @IBOutlet weak var Test: UILabel!
    @IBOutlet weak var Leaderboard: UILabel!
    
    @IBOutlet var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = db.open()
        
        requestIDFA()
        readUserDefaults()
        addhighscore()
        loadhighscores()
        
        testType = testType.capitalized
        difficulty = difficulty.capitalized
        
        Test.text = "\(testType) \(PoT)"
        Leaderboard.text = "\(questionNum) \(difficulty) Questions"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        correctAnswers.text = "Score: \(highscore!)"
        finishTime.text = "Time: \(finishtime!)"
        
        logToAnalytics()
    }
        
    // MARK: Actions
    @IBAction func Menu(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func addhighscore(){
        // _ is set to avoid warning
        _ = db.execute(sql: "INSERT INTO \(difficulty)_\(testType)_\(questionNum) (Score, Time) Values ('\(highscore!)', '\(finishtime!)'); ", parameters:nil)
    }
    
    func loadhighscores(){
        let result = db.query(sql: "SELECT * from \(difficulty)_\(testType)_\(questionNum) ORDER BY Score DESC, Time ASC LIMIT 5", parameters: nil)
                
        for row in result
        {
            bestScore[i] = String(describing: row["Score"]!)
            bestTime[i] = String(describing: row["Time"]!)
                    
            i += 1
        }
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
    
    func logToAnalytics() {
        
        //Analytics
        Analytics.logEvent("kFIREventTestFinished", parameters: [
            AnalyticsParameterItemID: "id-test_finished" as NSObject,
            "kFIRParameterTestType": testType as NSObject, //Default: Math
            "kFIRParameterTestDifficulty": difficulty as NSObject, //Default: easy
            "kFIRParameterTestLength": questionNum as NSObject, //Default: 5
            "kFIRParameterTestPoT": PoT as NSObject, //Default: Practice
            "kFIRParameterQuestionsCorrect": highscore! as NSObject
            ])
        
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension FinishTestController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestRank.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        
//        cell.column1.text = self.bestRank[indexPath.row]
//        cell.column2.text = self.bestScore[indexPath.row]
//        cell.column3.text = self.bestTime[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
