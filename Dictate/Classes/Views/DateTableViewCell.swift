//
//  DateTableViewCell.swift
//  Dictate
//
//  Created by Anil Varghese on 06/09/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit

@objc protocol DateCellDelegate{
    func alarmStateChanged(_ state:Bool,cell:DateTableViewCell)
    
}

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    weak var delegate:DateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func alarmSwitchValueChanged(_ sender: UISwitch) {
        self.delegate?.alarmStateChanged(sender.isOn, cell: self)
    }
}
