//
//  LeaderboardVC.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 20/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//

import UIKit 
import FirebaseDatabase
import Charts
import Toaster

class LeaderboardVC: BaseVC {
    
    // MARK: Properties
    private let HIGH_SCORE_CELL = "HighScoreCell"
    private let db = SQLiteDB.shared
    private let maxResults = 5
    private var bestScore: [String] = ["-----", "-----", "-----", "-----", "-----"]
    private var bestTime: [String] = ["-----", "-----", "-----", "-----", "-----"]
    private var barChartView:BarChartView?
    
    //MARK: IBOutlets
    @IBOutlet weak var barChartContainerView: UIView!
    @IBOutlet weak var barChartStackView: UIStackView!
    @IBOutlet weak var testTypeView: UIView!
    @IBOutlet weak var questionCountView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreTypeControl: TMTSegmentedControl!
    @IBOutlet weak var testTypeControl: TMTSegmentedControl!
    @IBOutlet weak var levelTypeControl: TMTSegmentedControl!
    @IBOutlet weak var questionsControl: TMTSegmentedControl!
    
    //Property Observers
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
    
    var scoreType: Test.ScoreType = Test.ScoreType.local {
        didSet {
            loadhighscores()
        }
    }
    
    var testType: Test.Category = Test.Category.math {
        didSet {
            loadhighscores()
        }
    }
    
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
        tableView.register(UINib(nibName: HIGH_SCORE_CELL, bundle: nil), forCellReuseIdentifier: HIGH_SCORE_CELL)
    }
    
    fileprivate func setupSegmentedControl() {
        
        //Setup data for segment control buttons
        scoreTypeControl.setButtonTitles(buttonTitles: Test.ScoreType.allCases.map { $0.rawValue.uppercased() })
        testTypeControl.setButtonTitles(buttonTitles: Test.Category.allCases.map { $0.rawValue.uppercased() })
        levelTypeControl.setButtonTitles(buttonTitles: Test.Level.allCases.map { $0.rawValue.uppercased() })
        questionsControl.setButtonTitles(buttonTitles: Test.Count.allCases.map { "\($0.rawValue)" })
        
        //Set delegate for segmented control
        questionsControl.delegate = self
        levelTypeControl.delegate = self
        testTypeControl.delegate = self
        scoreTypeControl.delegate = self
    }
    
    fileprivate func loadBarChartView(scores: [Int]) {
        
        if barChartView == nil {
            barChartView = BarChartView()
            barChartView?.rightAxis.enabled = false
            barChartView?.xAxis.labelPosition = .bottom
            barChartView?.drawValueAboveBarEnabled = false
            barChartContainerView.addSubview(barChartView!)
            barChartView!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                barChartView!.leadingAnchor.constraint(equalTo: barChartContainerView.leadingAnchor, constant: 16),
                barChartView!.trailingAnchor.constraint(equalTo: barChartContainerView.trailingAnchor, constant: -16),
                barChartView!.topAnchor.constraint(equalTo: barChartContainerView.topAnchor),
                barChartView!.bottomAnchor.constraint(equalTo: barChartContainerView.bottomAnchor)
            ])
        }
        
        let dataEntry1: [BarChartDataEntry] = scores.enumerated().map { BarChartDataEntry(x: Double($0), y: Double($1)) }
        
        let dataSet1 = BarChartDataSet(entries: dataEntry1, label: "Other's Scores")
        dataSet1.drawValuesEnabled = false
        dataSet1.colors = [NSUIColor.black]
        
        var dataSets: [BarChartDataSet] = [dataSet1]
        
        if let localBestScore = Double(bestScore.first!) {
            let dataSet2 = BarChartDataSet(entries: [BarChartDataEntry(x: Double(scores.count), y: localBestScore)], label: "Your Score")
            dataSet2.drawValuesEnabled = false
            dataSet2.colors = [.red]
            dataSets.append(dataSet2)
        }
        
        barChartView?.data = BarChartData(dataSets: dataSets)
    }
}

//MARK: UITableView Delegate
extension LeaderboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxResults;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIGH_SCORE_CELL, for: indexPath) as! HighScoreCell
        
        cell.rankLbl.text = "\(indexPath.row + 1)"
        cell.scoreDetailsLbl.text = "Score: \(self.bestScore[indexPath.row]) Time: \(self.bestTime[indexPath.row])"
        cell.setRow(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//MARK: DB
extension LeaderboardVC {
    
    func loadhighscores() {
        
        barChartStackView.isHidden = scoreType == .local
        questionCountView.isHidden = scoreType == .global
        
        bestScore = ["-----", "-----", "-----", "-----", "-----"]
        bestTime = ["-----", "-----", "-----", "-----", "-----"]
        
        let result = db.query(sql: "SELECT * from \(level.rawValue)_\(testType.rawValue)_\(questionNum.rawValue) ORDER BY Score DESC, Time ASC LIMIT \(maxResults)", parameters: nil)
        
        for (index,row) in result.enumerated() {
            bestScore[index] = String(describing: row["Score"]!)
            bestTime[index] = String(describing: row["Time"]!)
        }
        tableView.reloadData()
        if scoreType == .global {
            loadScoresFromFirebase()
        }
    }
    
    func loadScoresFromFirebase() {
        self.loadingIndicator.startAnimating()
        let ref = Database.database().reference()
        ref.child("leaderboard")
            .observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    DispatchQueue.main.async {
                        var scores: [Int] = []
                        for child in snapshot.children {
                            if let snap = child as? DataSnapshot,
                               let val = snap.value as? [String: Any] {
                                if let testCategory = val["test_type"] as? String,
                                   let difficulty = val["difficulty"] as? String,
                                   let score = val["score"] as? Int,
                                   difficulty == self.level.rawValue,
                                   testCategory == self.testType.rawValue {
                                    scores.append(score)
                                }
                            }
                        }
                        self.loadingIndicator.stopAnimating()
                        if scores.count > 0 {
                            self.loadBarChartView(scores: scores)
                        }
                        else {
                            Toast(text: "No Data Found").show()
                        }
                    }
                }
                else {
                    self.loadingIndicator.stopAnimating()
                }
            }
    }
    
    func loadSQL() {
        let result = db.query(sql: "SELECT * FROM \(level.rawValue)_\(testType.rawValue)_\(questionNum.rawValue)")
        print(result.debugDescription)
    }
}

extension LeaderboardVC: TMTSegmentedControlDelegate {
    func change(control: TMTSegmentedControl, to index: Int) {
        switch control {
        case scoreTypeControl:
            if let scoreType = Test.ScoreType(rawValue: control.selectedVal.lowercased()) {
                self.scoreType = scoreType
            }
            if scoreType == .global {
                questionNum = testType == .math ? .eighty : .fifty
            }
        case levelTypeControl:
            if let level = Test.Level(rawValue: control.selectedVal.lowercased()) {
                self.level = level
            }
        case testTypeControl:
            if let testType = Test.Category(rawValue: control.selectedVal.lowercased()) {
                self.testType = testType
            }
            if scoreType == .global {
                questionNum = testType == .math ? .eighty : .fifty
            }
        case questionsControl:
            if let questionNum = Test.Count(rawValue: Int(control.selectedVal) ?? Test.Count.five.rawValue) {
                self.questionNum = questionNum
            }
        default:
            print("Unknown")
        }
    }
}
