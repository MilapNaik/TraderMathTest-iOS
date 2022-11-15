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
    
    fileprivate lazy var rightBarBtnItem: UIBarButtonItem = {
        return UIBarButtonItem(image: .leaderboardIcon, style: .done, target: self, action: #selector(BaseVC.showLearboardView))
    }()
    
    public var hidesRightBarBtnItem : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
    }
    
    fileprivate func setupNavbar() {
        if let nav = self.navigationController {
            //basic settings for navigation controller
            nav.isNavigationBarHidden = false
            nav.navigationItem.hidesBackButton = true
            
            self.navigationItem.leftBarButtonItem = leftBarBtnItem
            if !hidesRightBarBtnItem {
                self.navigationItem.rightBarButtonItem = rightBarBtnItem
            }
        }
    }
    
    @objc fileprivate func showLearboardView() {
        
    }
    
    
}
