//
//  ViewController.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/17/16.
//  Copyright (c) 2016 Gamelap Studios LLC. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class MainVC: UIViewController {
    
    // MARK: Properties
    let preferences = UserDefaults.standard
    let testtypeKey = "TestType"
    var testType:String?
    
    //MARK: IBOutlets
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var Info: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestIDFA()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "goestoPoTMath") {
            testType = "math"
        } else if (segue.identifier == "goestoPoTSeq") {
            testType = "sequence"
        } else{
            testType = "percent"
        }
        preferences.set(testType, forKey: testtypeKey)
    }
    
    //MARK: IDFA
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    #if DEBUG
                    print("Authorized")
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                    #endif
                default:
                    print("Unknown")
                }
            }
        }
    }
}
