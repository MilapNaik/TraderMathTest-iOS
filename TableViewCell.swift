//
//  TableViewCell.swift
//  TraderMathTestiOS
//
//  Created by Milap Naik on 6/3/16.
//  Copyright (c) 2016 Gamelap Studios. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var column1: UILabel!
    @IBOutlet weak var column2: UILabel!
    @IBOutlet weak var column3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
