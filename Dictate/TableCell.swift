//
//  SimpleTableCell.swift
//  WatchInput
//
//  Created by Mike Derr on 6/19/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet weak var labelCalendar: UILabel!
    @IBOutlet weak var labelStart: UILabel!
    @IBOutlet weak var labelEnd: UILabel!
    
    @IBOutlet weak var labelVertical: UILabel!
    
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var calendarNameLabel: UILabel!
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
