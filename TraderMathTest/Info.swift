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
        
        InfoText.editable = false
        TraderTest.editable = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
