//
//  DetailsTableViewCell.swift
//  Dictate
//
//  Created by Mike Derr on 1/31/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit


protocol DetailsTableViewCellDateSelectionDelegate{     //Anil added 022416
    func didSelectDate(_ date:Date, inCell cell:DetailsTableViewCell)
}

class DetailsTableViewCell: UITableViewCell {
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

   
    @IBOutlet weak var label: UILabel!

    //@IBOutlet weak var resultsTextField: UITextField!
    
    @IBOutlet weak var resultsTextField: UITextView!
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var labelTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var disclosureLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!    //Anil added
    var delegate:DetailsTableViewCellDateSelectionDelegate?    
    
    @IBOutlet weak var calendarPicker: UIPickerView!
    var calDelegate: DetailsTableViewCellDateSelectionDelegate?
    
    
    
    @IBAction func dateChanged(_ sender: AnyObject) {
        // updates ur label in the cell above
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "M-dd-yyyy h:mm a"
        let dateString = dateFormatter.string(from: datePicker.date)
        resultsLabel.text = dateString
        
        delegate?.didSelectDate(datePicker.date, inCell: self)
        
    }
    
}
