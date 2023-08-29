//
//  ViewExtension.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 10/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(named: "ShadowColor")!.cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 4
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
  
    func roundedBorders(radius: CGFloat = 0.0) {
        layer.cornerRadius = radius > 0 ? radius : bounds.width/2.0
        layer.masksToBounds = true
    }
    
    func border(color: UIColor = .label, width: Float = 1.0) {
        layer.borderColor = color.cgColor
        layer.borderWidth = CGFloat(width)
    }
}
