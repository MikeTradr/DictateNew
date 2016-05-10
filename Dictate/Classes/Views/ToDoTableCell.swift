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
    @IBOutlet weak var checkBox: BFPaperCheckbox!
    weak var reminder:EKReminder!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.checkBox.rippleFromTapLocation = false
//        self.checkBox.tapCirclePositiveColor = UIColor.paperColorAmber() // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
//        self.checkBox.tapCircleNegativeColor = UIColor.paperColorRed()  // We could use [UIColor colorWithAlphaComponent] here to make a better tap-circle.
        self.checkBox.checkmarkColor = UIColor.paperColorLightBlue()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func checkBoxTapped(sender: AnyObject) {
       
        
    }
}
