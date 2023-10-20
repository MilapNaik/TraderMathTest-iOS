//
//  Info.swift
//  TraderMathTest
//
//  Created by Milap Naik on 5/23/16.
//  Copyright (c) 2016 Gamelap Studios LLC. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class InfoVC: BaseVC, MFMailComposeViewControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var InfoText: UITextView!
    @IBOutlet weak var versionLbl: UILabel!
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        InfoText.text = "This app is meant to help practice for the math portion of interviews with finance firms. Pick your difficulty setting and amount of questions for quick, randomized practice sessions; or go for the full test and see how you do. Enjoy!"
        versionLbl.text = "v " + (appVersion ?? "")
    }
    
    @IBAction func backClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendFeedbackClicked() {
        if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["admin@gamelapstudios.com"])
                present(mail, animated: true)
            } else {
                // show failure alert
            }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
