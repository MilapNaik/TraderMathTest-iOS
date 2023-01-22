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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setRow(index: Int) {
        if index % 2 == 0 {
            containerView.border(color: .primary, width: 1.0)
        }
        else {
            containerView.border(color: .black, width: 1.0)
        }
    }
    
}
