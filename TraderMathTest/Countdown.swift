//
//  Countdown.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 5/24/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit

class CountdownController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var countDownLabel: UILabel!
    
    var timer:NSTimer?
    var count = 3
    var testType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(CountdownController.update), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    
    func update() {
        if(count > 0) {
            countDownLabel.text = String(count)
            count-=1
        }
        else {
            timer!.invalidate()
        self.performSegueWithIdentifier("goestoMathTest", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: Actions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "goestoMathTest") {
            let secondViewController = segue.destinationViewController as! MathTestController
            //let testType = sender as String
            secondViewController.testType = testType!
            
            
        }
    }
    
    
}
