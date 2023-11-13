//
//  HighScoreCell.swift
//  TraderMathTest
//
//  Created by Bhavesh Gupta on 20/11/22.
//  Copyright © 2022 Gamelap Studios LLC. All rights reserved.
//

import UIKit

class HighScoreCell: UITableViewCell {

    @IBOutlet weak var rankLbl: UILabel!
    @IBOutlet weak var scoreDetailsLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var selectorTextColor: UIColor {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            return .primary
        case .dark:
            return .accent
        @unknown default:
            return .primary
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .appBackground
    }
    
    func setRow(index: Int) {
        containerView.border(color: index % 2 == 0 ? selectorTextColor : .label, width: 1.0)
    }
    
}
