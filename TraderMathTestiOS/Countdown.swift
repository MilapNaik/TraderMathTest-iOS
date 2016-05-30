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
    var timer = NSTimer()

    
    var count = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update"), userInfo: nil, repeats: true)

    }
    
    
    func update() {
        
        if(count > 0) {
            countDownLabel.text = String(count--)
        }
        else {
            timer.invalidate()
            self.performSegueWithIdentifier("goestoMathTest", sender: self)
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: Actions
    
    
}
