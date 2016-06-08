//
//  PracticeOrTest.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/24/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit

class PoTController: UIViewController {
    
    // MARK: Properties
    var testType:String?
    var PoT:String?
    
    // Preferences for Practice or Test
    let preferences = NSUserDefaults.standardUserDefaults()
    let PoTKey = "PoT"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

// MARK: UITextFieldDelegate

    @IBAction func PracticeButton(sender: UIButton) {
        preferences.setObject("Practice", forKey: PoTKey)
    }
    @IBAction func TestButton(sender: UIButton) {
        preferences.setObject("Test", forKey: PoTKey)
    }




// MARK: Actions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "goestoCountdownPractice") {
            let secondViewController = segue.destinationViewController as! CountdownController
            //let testType = sender as! String
            secondViewController.testType = testType
        }
        
        if (segue.identifier == "goestoCountdownTest") {
            let secondViewController = segue.destinationViewController as! CountdownController
            //let testType = sender as! String
            secondViewController.testType = testType
        }
    }


}

