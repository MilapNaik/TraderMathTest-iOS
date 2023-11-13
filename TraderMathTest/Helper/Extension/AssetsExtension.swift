//
//  ColorExtension.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 12/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//

import UIKit

extension UIColor {
    class var primary: UIColor { UIColor(named: "PrimaryColor")! }
    class var lightPrimary: UIColor { UIColor(named: "LightPrimary")! }
    class var accent: UIColor { UIColor(named: "AccentColor")! }
    class var appBackground: UIColor {
        UIColor(named: "BackgroundColor")!
    }
}

extension UIImage {
    class var mainLogo: UIImage { UIImage(named: "LogoImage")! }
    class var leaderboardIcon: UIImage { UIImage(named: "leaderboard_icon")! }
    class var leaderboardIconSelected: UIImage { UIImage(named: "leaderboard_icon_selected")! }
}
