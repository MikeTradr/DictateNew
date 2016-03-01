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
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    let calendarList = ReminderManager.sharedInstance.getCalendars(EKEntityType.Event)
    
    var selectedCalendar:String = ""    
    
    var calendarArray: [String] = []
    
   // var calendarName = defaults.stringForKey("calendarName")            //Cal.
    
    var pickerDataSource = ["White", "Red", "Green", "Blue"];
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        //make Calendar's List Array
        //TODO remove when in full app after testing
        EventManager.sharedInstance.createCalendarArray()
        
        calendarArray = defaults.stringArrayForKey("calendarArray")!

        print("p38 calendarArray: \(calendarArray)")
        print("p39 calendarList: \(calendarList)")


        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       // return pickerDataSource.count;
        return calendarArray.count;

        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
       // return pickerDataSource[row]
        return calendarArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(row == 0)
        {
            self.view.backgroundColor = UIColor.whiteColor();
        }
        else if(row == 1)
        {
            self.view.backgroundColor = UIColor.redColor();
        }
        else if(row == 2)
        {
            self.view.backgroundColor =  UIColor.greenColor();
        }
        else
        {
            self.view.backgroundColor = UIColor.blueColor();
        }
    }
    
    
}

