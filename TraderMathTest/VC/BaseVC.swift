//
//  BaseVC.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 15/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    fileprivate lazy var leftBarBtnItem: UIBarButtonItem = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: logoImageView.bounds.width, height: logoImageView.bounds.height))
        view.clipsToBounds = false
        view.addSubview(logoImageView)
        return UIBarButtonItem(customView: view)
    }()
    
    fileprivate lazy var logoImageView : UIImageView = {
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 140, height: 50))
        logoImageView.image = .mainLogo
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    fileprivate lazy var rightBarBtnItem: UIBarButtonItem? = {
        return hidesRightBarBtnItem ? nil : UIBarButtonItem(image: isLeaderboardVC() ? .leaderboardIconSelected : .leaderboardIcon, style: .done, target: self, action: #selector(BaseVC.showLearboardView))
    }()
    
    fileprivate lazy var rightBarBtnItemSelected: UIBarButtonItem = {
        return UIBarButtonItem(image: .leaderboardIconSelected, style: .done, target: self, action: nil)
    }()
    
    public var hidesRightBarBtnItem : Bool = false {
        didSet {
            self.navigationItem.rightBarButtonItem = hidesRightBarBtnItem ? nil : rightBarBtnItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavbar()
    }
    
    fileprivate func setupNavbar() {
        if let nav = self.navigationController {
            //basic settings for navigation controller
            nav.isNavigationBarHidden = false
            nav.navigationItem.hidesBackButton = true
            
            self.navigationItem.leftBarButtonItem = leftBarBtnItem
            self.navigationItem.rightBarButtonItem = rightBarBtnItem
        }
    }
    
    @objc fileprivate func showLearboardView() {
        if !isLeaderboardVC() {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LEADERBOARD_VC") as? LeaderboardVC {
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func isLeaderboardVC() -> Bool {
        if let _ = self.navigationController, let _ = self.navigationController?.topViewController as? LeaderboardVC {
            return true
        }
        return false
    }
    
}
