//
//  DatePopupViewController.swift
//  Dictate
//
//  Created by Mike Derr on 2/22/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit

class DatePopupViewController: ViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(_ sender: UITextField) {
        
        // updates ur label in the cell above
        print("p19 datePicker.date: \(datePicker.date)")
        dateLabel.text = "\(datePicker.date)"
        
    }
    
    
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        let startDT     = defaults.object(forKey: "startDT")! as! Date      //Start
        
        
        
        print("p32 startDT: \(startDT)")
        datePicker.date = startDT
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "M-dd-yyyy h:mm a"
        fullDT = formatter3.string(from: startDT)
       // fullDTEnd = formatter3.stringFromDate(endDT)
        
        dateLabel.text = fullDT 
        print("p43  dateLabel.text: \( dateLabel.text)")
        
   
    }
    

    
    
    
}
