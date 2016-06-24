//
//  FinishTest.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/26/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit


class FinishTestController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    var i: Int = 0
    var highscore:Int?
    var finishtime:String?
    
    let db = SQLiteDB.sharedInstance()
    var bestRank: [String] = ["1", "2", "3", "4", "5"]
    var bestScore: [String] = ["-----", "-----", "-----", "-----", "-----"]
    var bestTime: [String] = ["-----", "-----", "-----", "-----", "-----"]
    
    let preferences = NSUserDefaults.standardUserDefaults()
    let difficultyKey = "Difficulty"
    let questionnumKey = "QuestionNum"
    let PoTKey = "PoT"
    let testtypeKey = "TestType"
    var difficulty: String = "EASY"
    var questionNum: Int = 5
    var PoT:String = "Practice"
    var testType:String = "MATH"


    @IBOutlet weak var correctAnswers: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    
    @IBOutlet weak var Test: UILabel!
    @IBOutlet weak var Leaderboard: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestRank.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        cell.column1.text = self.bestRank[indexPath.row]
        cell.column2.text = self.bestScore[indexPath.row]
        cell.column3.text = self.bestTime[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readUserDefaults()
        addhighscore()
        loadhighscores()
        
        testType = testType.capitalizedString
        difficulty = difficulty.capitalizedString
        
        Test.text = "\(testType) \(PoT)"
        Leaderboard.text = "\(questionNum) \(difficulty) Questions"
    }
    
    override func viewDidAppear(animated: Bool) {
        correctAnswers.text = "Score: \(highscore!)"
        finishTime.text = "Time: \(finishtime!)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    @IBAction func Menu(sender: UIButton) {
        self.performSegueWithIdentifier("goestoMenu", sender: self)
    }
    
    
    func addhighscore(){
        db.execute("INSERT INTO \(difficulty)_\(testType)_\(questionNum) (Score, Time) Values ('\(highscore!)', '\(finishtime!)'); ", parameters:nil)

    }
    
    func loadhighscores(){
        let result = db.query("SELECT * from \(difficulty)_\(testType)_\(questionNum) ORDER BY Score DESC, Time ASC LIMIT 5", parameters: nil)
                
        for row in result
        {
            bestScore[i] = String(row["Score"]!)
            bestTime[i] = String(row["Time"]!)
                    
            i += 1
        }
    }
    
    // Read user defaults. If none exist, they are set to Easy and 5 questions
    func readUserDefaults(){
        if preferences.stringForKey(testtypeKey) != nil{
            testType = preferences.stringForKey(testtypeKey)!
        }
        
        if preferences.stringForKey(difficultyKey) != nil{
            difficulty = preferences.stringForKey(difficultyKey)!
        }
        
        if preferences.stringForKey(PoTKey) != nil{
            PoT = preferences.stringForKey(PoTKey)!
        }
        
        if PoT == "Test"{
            if testType == "SEQ"{
                questionNum = 50
            }
            else{
                questionNum = 80
            }
        }
        else{
            if preferences.integerForKey(questionnumKey) == 0{
                questionNum = 5
            }
            else {
                questionNum = preferences.integerForKey(questionnumKey)
            }
        }
        
    }
} //EOF
    
