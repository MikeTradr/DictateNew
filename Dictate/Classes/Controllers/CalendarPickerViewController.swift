//
//  CalendarPickerViewController.swift
//  Dictate
//
//  Created by Mike Derr on 2/29/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit

class CalendarPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
    
{
   // @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var buttonSetNew: UIButton!
    
    let calendarList = ReminderManager.sharedInstance.getCalendars(EKEntityType.event)
    
    var selectedCalendar:String = ""
    var calendarArray: [String] = []
    var newCalendarName: String = ""        //string to hold new string from picker.
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    
   // var calendarName = defaults.stringForKey("calendarName")            //Cal.
    
    @IBAction func buttonSetNew(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "returnFromModal", sender: self)
        defaults.set(newCalendarName, forKey: "calendarName")
    }
    
    @IBAction func buttonCancel(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "returnFromModal", sender: self)
    }
    
    @IBAction func barButtonCancel(_ sender: AnyObject) {
         self.performSegue(withIdentifier: "returnFromModal", sender: self)
    }
    
    
    @IBAction func barButtonDone(_ sender: AnyObject) {
         defaults.set(newCalendarName, forKey: "calendarName")
         self.performSegue(withIdentifier: "returnFromModal", sender: self)
    }
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
        
        let calendarName = defaults.string(forKey: "calendarName")
        print("p59 calendarName: \(calendarName)")

        
        resultLabel.text = calendarName
        
        //make Calendar's List Array
        EventManager.sharedInstance.createCalendarArray()
        
        calendarArray = defaults.object(forKey: "calendarArray")! as! [String]
        
        print("p66 calendarArray: \(calendarArray)")

        
      //below works, but guy in slackchat room suggested map routine!
        var defaultRowIndex = calendarArray.index(of: calendarName!)
        if(defaultRowIndex == nil) { defaultRowIndex = 0 }
     //   pickerView.selectRow(defaultRowIndex!, inComponent: 0, animated: false)

        //TODO this works in sim, bombs on phone!  above works!
        //     let defaultRowIndex = calendarName.map { calendarArray.indexOf($0) } ?? 0
        print("p69 defaultRowIndex!: \(defaultRowIndex!)")
        
        pickerView.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return calendarArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
     //   title.backgroundColor = UIColor.blackColor()
     //  .textColor = UIColor.whiteColor()
        
        return calendarArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("p103 row: \(row)")
        print("p110 calendarArray: \(calendarArray)")

        resultLabel.text = calendarArray[row]
        newCalendarName = calendarArray[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = calendarArray[row]
        let myTitle = NSAttributedString(
                string: titleData,
                attributes: [NSFontAttributeName:UIFont(
                name: "Helvetica-Bold",
                size: 22.0)!,
                NSForegroundColorAttributeName:UIColor.white])
        
        pickerLabel.attributedText = myTitle
        
        //color  and center the label's background
     //   let hue = CGFloat(row)/CGFloat(calendarArray.count)
       // pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
        pickerLabel.textAlignment = .center
        
        return pickerLabel
    }

/*
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = calendarArray[row]
    
        var myTitle = NSMutableAttributedString(
            string: titleData,
            attributes: [NSFontAttributeName:UIFont(
                name: "Georgia-Bold",
                size: 24.0)!,
                NSForegroundColorAttributeName:UIColor.whiteColor()])
        //Add more attributes here
        
        return myTitle
    }
    
*/

    
    
    

    
}

