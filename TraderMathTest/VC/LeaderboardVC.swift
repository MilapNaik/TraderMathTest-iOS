//
//  LeaderboardVC.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 20/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//

import UIKit

class LeaderboardVC: BaseVC {

    // MARK: Properties
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
    var PoT:String = "practice"
    var testType:String = "math"
    
    @IBOutlet weak var testTypeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = db.open()
        
        tableView.register(UINib(nibName: "HighScoreCell", bundle: nil), forCellReuseIdentifier: "HighScoreCell")

//        readUserDefaults()
        loadhighscores()
        testTypeView.isHidden = true
        testType = testType.capitalized
        difficulty = difficulty.capitalized
    }
}

//MARK: UITableView Delegate
extension LeaderboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestRank.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath) as! HighScoreCell
        
        cell.rankLbl.text = self.bestRank[indexPath.row]
        cell.scoreDetailsLbl.text = "Score: \(self.bestScore[indexPath.row]) Time: \(self.bestTime[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

//MARK: DB
extension LeaderboardVC {
    
    func loadhighscores(){
        let result = db.query(sql: "SELECT * from \(difficulty)_\(testType)_\(questionNum) ORDER BY Score DESC, Time ASC LIMIT 5", parameters: nil)
                
        for (index,row) in result.enumerated() {
            bestScore[index] = String(describing: row["Score"]!)
            bestTime[index] = String(describing: row["Time"]!)
        }
    }
    
}
