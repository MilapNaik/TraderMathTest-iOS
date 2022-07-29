//
//  Info.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/23/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit

class InfoController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var InfoText: UITextView!
    @IBOutlet weak var TraderTest: UITextView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        InfoText.text = "This app is meant to help practice for the math portion of interviews with finance firms. Pick your difficulty setting and amount of questions for quick, randomized practice sessions; or go for the full test and see how you do. Enjoy!"
        InfoText.textAlignment = .center
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
