//
//  Info.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/23/16.
//  Copyright (c) 2016 Gamelap Studios LLC. All rights reserved.
//

import Foundation
import UIKit

class InfoVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var InfoText: UITextView!
    @IBOutlet weak var versionLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        InfoText.text = "This app is meant to help practice for the math portion of interviews with finance firms. Pick your difficulty setting and amount of questions for quick, randomized practice sessions; or go for the full test and see how you do. Enjoy!"
    }
    
    @IBAction func backClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
