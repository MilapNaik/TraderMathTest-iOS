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

class ViewController: UIViewController {
    
    // MARK: Properties
    let preferences = UserDefaults.standard
    let testtypeKey = "TestType"
    var testType:String?

    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var Info: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestIDFA()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
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
    
    func requestIDFA() {
        if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        // Tracking authorization dialog was shown
                        // and we are authorized
                        print("Authorized")
                        // Now that we are authorized we can get the IDFA
//                        print(ASIdentifierManager.shared().advertisingIdentifier)
                    case .denied:
                        // Tracking authorization dialog was
                        // shown and permission is denied
                        print("Denied")
                    case .notDetermined:
                        // Tracking authorization dialog has not been shown
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                }
        }
    }
}
