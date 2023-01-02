//
//  LeaderboardVC.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 20/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//

import UIKit
import BarChartKit
class LeaderboardVC: BaseVC {

    // MARK: Properties
    private let db = SQLiteDB.shared
    private let maxResults = 5
    private var bestScore: [String] = []
    private var bestTime: [String] = []
        
    @IBOutlet weak var barChartContainerView: UIView!
    @IBOutlet weak var barChartStackView: UIStackView!
    @IBOutlet weak var testTypeView: UIView!
    @IBOutlet weak var tableView: UITableView!
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
        tableView.register(UINib(nibName: "HighScoreCell", bundle: nil), forCellReuseIdentifier: "HighScoreCell")
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
    
    fileprivate func loadBarChartView() {
        
        let mockBarChartDataSet: BarChartView.DataSet? = BarChartView.DataSet(elements: [
            BarChartView.DataSet.DataElement(date: nil, xLabel: "Jan", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor.green), BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor.blue)]),
            BarChartView.DataSet.DataElement(date: nil, xLabel: "Feb", bars: [BarChartView.DataSet.DataElement.Bar(value: 0, color: UIColor.green)]),
            BarChartView.DataSet.DataElement(date: nil, xLabel: "Mar", bars: [BarChartView.DataSet.DataElement.Bar(value: 10000, color: UIColor.green), BarChartView.DataSet.DataElement.Bar(value: 5000, color: UIColor.blue)]),
            BarChartView.DataSet.DataElement(date: nil, xLabel: "Apr", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor.green), BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor.blue)]),
            BarChartView.DataSet.DataElement(date: nil, xLabel: "May", bars: [BarChartView.DataSet.DataElement.Bar(value: 32000, color: UIColor.green), BarChartView.DataSet.DataElement.Bar(value: 15000, color: UIColor.blue)]),
            BarChartView.DataSet.DataElement(date: nil, xLabel: "Jun", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor.green)]),
            BarChartView.DataSet.DataElement(date: nil, xLabel: "Jul", bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor.green), BarChartView.DataSet.DataElement.Bar(value: 0.5555, color: UIColor.blue)])
            ], selectionColor: UIColor.yellow)


        let barChart = BarChartView()
        barChart.dataSet = mockBarChartDataSet

        barChartContainerView.addSubview(barChart)
        barChart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barChart.leadingAnchor.constraint(equalTo: barChartContainerView.leadingAnchor),
            barChart.trailingAnchor.constraint(equalTo: barChartContainerView.trailingAnchor),
            barChart.topAnchor.constraint(equalTo: barChartContainerView.topAnchor),
            barChart.bottomAnchor.constraint(equalTo: barChartContainerView.bottomAnchor)
        ])
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
        
        if scoreType == .global {
            barChartStackView.isHidden = false
            loadBarChartView()
            return
        }
        barChartStackView.isHidden = true
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
        case scoreTypeControl:
            if let scoreType = Test.ScoreType(rawValue: control.selectedVal.lowercased()) {
                self.scoreType = scoreType
            }
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
