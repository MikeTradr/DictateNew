//
//  SettingsCalendarListTableViewCell.swift
//  Dictate
//
//  Created by Mike Derr on 9/10/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit

class SettingsCalendarListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelNumberItems: UILabel!
    
    @IBOutlet weak var verticalBarView: UIView!
 
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
