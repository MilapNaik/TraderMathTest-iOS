//
//  ViewController.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/17/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {
    
    // MARK: Properties
    let preferences = UserDefaults.standard
    let testtypeKey = "TestType"
    var testType:String?

    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var Info: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "goestoPoTMath") {
            testType = "math"
        }
        
        if (segue.identifier == "goestoPoTSeq") {
            testType = "sequence"
        }
        preferences.set(testType, forKey: testtypeKey)
    }
}

