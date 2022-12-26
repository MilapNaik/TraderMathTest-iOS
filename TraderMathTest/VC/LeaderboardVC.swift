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
    private let db = SQLiteDB.shared
    private let maxResults = 5
    private var bestScore: [String] = []
    private var bestTime: [String] = []
    
    var level: Test.Level = Test.Level.easy {
        didSet {
            loadhighscores()
        }
    }
    
    var questionNum: Test.Count = Test.Count.five {
        didSet {
            loadhighscores()
        }
    }
    
//    var PoT: Test.TType = Test.TType.practice {
//        didSet {
//            loadhighscores()
//        }
//    }
    
    var testType: Test.Category = Test.Category.math {
        didSet {
            loadhighscores()
        }
    }
    
    @IBOutlet weak var testTypeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreTypeControl: TMTSegmentedControl!
    @IBOutlet weak var testTypeControl: TMTSegmentedControl!
    @IBOutlet weak var levelTypeControl: TMTSegmentedControl!
    @IBOutlet weak var questionsControl: TMTSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        _ = db.open()
        loadSQL()
        setupTableView()
        loadhighscores()
        setupSegmentedControl()
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: "HighScoreCell", bundle: nil), forCellReuseIdentifier: "HighScoreCell")
    }
    
    fileprivate func setupSegmentedControl() {
        scoreTypeControl.setButtonTitles(buttonTitles: Test.ScoreType.allCases.map { $0.rawValue.uppercased() })
        scoreTypeControl.delegate = self
        testTypeControl.setButtonTitles(buttonTitles: Test.Category.allCases.map { $0.rawValue.uppercased() })
        testTypeControl.delegate = self
        levelTypeControl.setButtonTitles(buttonTitles: Test.Level.allCases.map { $0.rawValue.uppercased() })
        levelTypeControl.delegate = self
        questionsControl.setButtonTitles(buttonTitles: Test.Count.allCases.map { "\($0.rawValue)" })
        questionsControl.delegate = self
    }
}

//MARK: UITableView Delegate
extension LeaderboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxResults;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath) as! HighScoreCell
        
        cell.rankLbl.text = "\(indexPath.row + 1)"
        cell.scoreDetailsLbl.text = "Score: \(self.bestScore[indexPath.row]) Time: \(self.bestTime[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

//MARK: DB
extension LeaderboardVC {
    
    func loadhighscores() {
        bestScore = ["-----", "-----", "-----", "-----", "-----"]
        bestTime = ["-----", "-----", "-----", "-----", "-----"]
        
        let result = db.query(sql: "SELECT * from \(level.rawValue)_\(testType.rawValue)_\(questionNum.rawValue) ORDER BY Score DESC, Time ASC LIMIT \(maxResults)", parameters: nil)
                
        for (index,row) in result.enumerated() {
            bestScore[index] = String(describing: row["Score"]!)
            bestTime[index] = String(describing: row["Time"]!)
        }
        tableView.reloadData()
    }
    
    func loadSQL() {
        let result = db.query(sql: "SELECT * FROM \(level.rawValue)_\(testType.rawValue)_\(questionNum.rawValue)")
        print(result.debugDescription)
    }
}

extension LeaderboardVC: TMTSegmentedControlDelegate {
    func change(control: TMTSegmentedControl, to index: Int) {
        switch control {
        case levelTypeControl:
            if let level = Test.Level(rawValue: control.selectedVal.lowercased()) {
                self.level = level
            }
        case testTypeControl:
            if let testType = Test.Category(rawValue: control.selectedVal.lowercased()) {
                self.testType = testType
            }
        case questionsControl:
            if let questionNum = Test.Count(rawValue: Int(control.selectedVal) ?? Test.Count.five.rawValue) {
                self.questionNum = questionNum
            }
        default:
            print("functionality")
        }
    }
}
