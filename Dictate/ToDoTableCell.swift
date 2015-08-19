//
//  ToDoTableCell.swift
//  WatchInput
//
//  Created by Mike Derr on 6/22/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit

class ToDoTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarName: UILabel!
    
    @IBOutlet weak var verticalBarView: UIView!
    @IBOutlet weak var checkBox: CheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
