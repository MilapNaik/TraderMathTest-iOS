//
//  ToastHelper.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 30/07/23.
//  Copyright © 2023 Gamelap Studios LLC. All rights reserved.
//
import NotificationBannerSwift
import UIKit

struct ToastHelper {
    
    static func toast(_ text: String, presenter: UIViewController, type: BannerStyle? = .warning) {
        
        let banner = FloatingNotificationBanner(title: "",
                                                subtitle: text,
                                                style: type!)
        
        DispatchQueue.main.async {
            banner.show(queuePosition: .front,
                    bannerPosition: .top,
                    cornerRadius: 10,
                    shadowBlurRadius: 4,
                    shadowEdgeInsets: UIEdgeInsets(top: 5, left: 3, bottom: 0, right: 0))
        }
    }
}
