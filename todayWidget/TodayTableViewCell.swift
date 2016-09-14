//
//  TodayTableViewCell.swift
//  Dictate
//
//  Created by Mike Derr on 8/31/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    @IBOutlet var labelOutput: UILabel!

    @IBOutlet var labelStartTime: UILabel!
    @IBOutlet var labelEndTime: UILabel!
    @IBOutlet var labelTimeUntil: UILabel!
    
    @IBOutlet var labelSecondLine: UILabel!
    
    @IBOutlet var verticalBarView: UIView!
    
    @IBOutlet var constraintTimeUntilTop: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
