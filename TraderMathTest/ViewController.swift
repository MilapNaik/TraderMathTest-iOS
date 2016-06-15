//
//  ViewController.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/17/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    let preferences = NSUserDefaults.standardUserDefaults()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "goestoPoTMath") {
            testType = "MATH"
        }
        
        if (segue.identifier == "goestoPoTSeq") {
            testType = "SEQ"
        }
        preferences.setObject(testType, forKey: testtypeKey)
    }

    
}

