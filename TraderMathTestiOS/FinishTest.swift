//
//  FinishTest.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/26/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit


class FinishTestController: UIViewController {
    // MARK: Properties
    var highscore:Int?
    var finishtime:String?


    @IBOutlet weak var correctAnswers: UILabel!
    @IBOutlet weak var Time: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        correctAnswers.text = "Score: \(highscore!)"
        Time.text = "Time: \(finishtime!)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: UITextFieldDelegate
    
    
    
    
    // MARK: Actions
    @IBAction func Menu(sender: UIButton) {
        self.performSegueWithIdentifier("goestoMenu", sender: self)
    }
    
    
    
}
    
