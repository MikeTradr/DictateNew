//
//  SettingsFriendsTableViewCell.swift
//  Dictate
//
//  Created by Mike Derr on 9/6/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit

class SettingsFriendsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var imagePicture: UIImageView!
    
    @IBOutlet weak var constraintEmailTop: NSLayoutConstraint!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
