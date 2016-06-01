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
    var highscore:Int?
    var finishtime:String?
    let db = SQLiteDB.sharedInstance()
    
    let swiftBlogs = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips"]


    @IBOutlet weak var correctAnswers: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Highscores: UITableView!
    
    @IBOutlet weak var FirstScore: UILabel!
    @IBOutlet weak var FirstTime: UILabel!
    @IBOutlet weak var SecondScore: UILabel!
    @IBOutlet weak var SecondTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addhighscore()
        loadhighscores()
    }
    
    func addhighscore(){
        db.execute("INSERT INTO EASY_MATH5 (Score, Time) Values ('\(highscore!)', '\(finishtime!)'); ", parameters:nil)
    }
    
    func loadhighscores(){
        var result = db.query("SELECT * from EASY_MATH5 ORDER BY Score DESC, Time ASC LIMIT 5", parameters: nil)
        println("===============================")
        for row in result
        {
            FirstScore.text = row["Score"]!.asString()
            FirstTime.text = row["Time"]!.asString()
            print(row["Rank"]!.asString())
            print(" ")
            print(row["Score"]!.asString())
            print(" ")
            println(row["Time"]!.asString())
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        correctAnswers.text = "Score: \(highscore!)"
        Time.text = "Time: \(finishtime!)"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    // MARK: Actions
    @IBAction func Menu(sender: UIButton) {
        self.performSegueWithIdentifier("goestoMenu", sender: self)
    }
    
    
    
}
    
