//
//  MailComposer.swift
//  Dictate
//
//  Created by Mike Derr on 7/1/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import MessageUI

class MailComposer: UIViewController, MFMailComposeViewControllerDelegate {
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var allReminderLists:[EKCalendar] = []
    var allReminders: Array<EKReminder> = []
    var numberOfItems:Int = 0
    var newOutput:String = ""
    var messageBody:String = ""
    
    var allEvents: Array<EKEvent> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendEmailButtonTapped(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
           // showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()

        if MFMailComposeViewController.canSendMail() {
           // let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
            
            //TODO fix the forced downcast below
            let mainType:String    = defaults.string(forKey: "mainType")!
            let output:String    = defaults.string(forKey: "output")!
            let toPhone:String    = defaults.string(forKey: "toPhone")!
            
            var toRecipents:[String] = []
            toRecipents.append(toPhone)
            
            newOutput = "\(output) \n\n\n Sent from Dictate™ App"
            let messageBody = newOutput
            
            
            mailComposerVC.setToRecipients(toRecipents)
            mailComposerVC.setSubject("📩 Dictate App e-mail...")
            mailComposerVC.setMessageBody(newOutput, isHTML: false)
            
            // self.presentViewController(mailComposerVC, animated: true, completion: nil)
            return mailComposerVC

        } else {
            // give feedback to the user
            //TODO Anil Mike Add Error Alert Dialog?
            
            //add call Utility- alert dialog
            print("p66 Error can not send mail now")
        }
        
        return mailComposerVC
    }
    
    
    func mailList() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        //TODO fix the forced downcast below
        let mainType:String    = defaults.string(forKey: "mainType")!
        let output:String    = defaults.string(forKey: "output")!
        let toPhone:String    = defaults.string(forKey: "toPhone")!
        var reminderList:String = defaults.string(forKey: "reminderList")!
        
        //  var firstAlarm:EKAlarm
        
        var toRecipents:[String] = []
        toRecipents.append(toPhone)
        
        mailComposerVC.setToRecipients(toRecipents)
        mailComposerVC.setSubject("✔︎ Reminder List: \(reminderList)...")
        
        //load and step through reminderList
        allReminderLists = ReminderManager.sharedInstance.eventStore.calendars(for: EKEntityType.reminder)
        
        reminderList = reminderList.capitalized   //Capitalize first letter
        print("p86 reminderList: \(reminderList)")
        
        if allReminderLists != [] {
            for (index, title) in allReminderLists.enumerated() {
                // print("---------------------------------------------------")
                // print("p82 index, title: \(index), \(title)")
                
                let reminderListTitle = allReminderLists[index]
                // print("p86 reminderListTitle: \(reminderListTitle)")
                
                if reminderListTitle.title == reminderList {
                    
                    if reminderListTitle != "" {   //TODO Mike TODO Anil trying Checking if Reminder List has items!
                        
                        ReminderManager.sharedInstance.fetchCalendarReminders(reminderListTitle) { (reminders) -> Void in
                            print(reminders)
                            
                            self.allReminders = reminders as [EKReminder]
                            self.numberOfItems = self.allReminders.count
                            
                            var body:String = ""
                            var alarmString = ""
                            //  var firstAlarm:EKAlarm
                            
                            
                            body = "<html><body>"
                            body = "\(body)<font size=\"6\" color=\"red\"><b>\(reminderListTitle.title)</b></font><br><hr> "
                            
                            for (index, title) in self.allReminders.enumerated() {
                                print("---------------------------------------------------")
                                print("p103 index, title: \(index), \(title)")
                                
                                let item = self.allReminders[index]
                                print("p106 item.title: \(item.title)")
                                
                                let title = item.title
                                //TODO Mike TODO Anil how do we get location from a Reminder? This worked forevent see func below!
                                let location = item.location!
                                
                                let alarms = item.alarms
                                let firstAlarm = alarms?[0]
                                
                                if item.alarms != nil {
                                    if !alarms!.isEmpty{
                                        //you have atleast one alarm in that array
                                        let firstAlarm = alarms![0]
                                        print("p130 firstAlarm: \(firstAlarm)")
                                    }
                                }
                                
                                print("p133 location: \(location)")
                                
                                if location != "" {
                                    
                                    body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br><font color=\"gray\">Location:<br><i>\(location)</i></font><p>"
                                    
                                } else if firstAlarm != nil {
                                    
                                    body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;🕑 \(firstAlarm)<p>"
                                    
                                } else {
                                    
                                    body = "\(body)<font size=\"5\"><b>❑ \(title)</b></font><br><p>"
                                    
                                }
                                
                                
                            }       // end If loop through items...
                            
                            body = body + "<br><hr><br>📩 Sent from Dictate™ App 😀</body></html>"
                            mailComposerVC.setMessageBody(body, isHTML: true)
                            
                        }       // end closure
                        
                    }       //end If trying to check if list has items
                    
                }       // end IF reminderListTitle.title == reminderList
            }
        }       // end allReminderLists != []
        
        return mailComposerVC
    }       //end func MailList
    
    
    func mailEvents() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        //TODO fix the forced downcast below
        let mainType:String    = defaults.string(forKey: "mainType")!
        let output:String    = defaults.string(forKey: "output")!
        let toPhone:String    = defaults.string(forKey: "toPhone")!
        var reminderList:String = defaults.string(forKey: "reminderList")!
        
        var toRecipents:[String] = []
        toRecipents.append(toPhone)
        
        let dateHelper = JTDateHelper()
        let startDate =  Date()
        // let endDate = dateHelper.addToDate(startDate, days: 1)
        
        let today = Date()
        let tomorrow:Date = (Calendar.current as NSCalendar).date(
            byAdding: .day,
            value: 1,
            to: today,
            options: NSCalendar.Options(rawValue: 0))!
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let endDate = cal.startOfDay(for: tomorrow)   // this is midnight today really or 0:00 tomorrow = 12 am = midnight
        
        print("p178 startDate: \(startDate)")
        print("p179 endDate: \(endDate)")
        
        mailComposerVC.setToRecipients(toRecipents)
        mailComposerVC.setSubject("📧Your Events for Today...")
        
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            self.allEvents = events
            print("p216 self.allEvents.count: \(self.allEvents.count)")
            
            var displayDate:String = ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, MMM d"
            
            displayDate = dateFormatter.string(from: startDate)
            
            var body:String = ""
            body = "<html><body>"
            body = "\(body)<font size=\"6\" color=\"red\"><b>\(displayDate)</b></font><br><hr> "
            
            if self.allEvents != [] {
                
                for (index, title) in self.allEvents.enumerated() {
                    print("---------------------------------------------------")
                    print("p171 index, title: \(index), \(title)")
                    let item = self.allEvents[index]
                    print("p173 item.title: \(item.title)")
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    
                    let startTimeA = dateFormatter.string(from: item.startDate)
                    var startTime = startTimeA.replacingOccurrences(of: ":00", with: "")
                    NSLog("%@ w137", startTime)
                    
                    let endTimeA = dateFormatter.string(from: item.endDate)
                    let endTime = endTimeA.replacingOccurrences(of: ":00", with: "")
                    
                    var endTimeDash = "- \(endTime)"
                    
                    if item.startDate == item.endDate {     //for same start & end time event
                        endTimeDash = ""
                    }
                    
                    let title = item.title
                    let location:String = item.location!
                    let time = "\(startTime) \(endTimeDash)"
                    
                    if location != "" {
                        
                        body = "\(body)<font size=\"5\"><b>• \(title)</b></font><br>&nbsp;&nbsp;&nbsp;&nbsp;🕑 \(time)<br><font color=\"gray\">Location:<br><i>\(location)</i></font><p>"
                        
                        // self.newOutput = "\(self.newOutput)\n ❍ \(title)\n    🕑 \(time)\nLocation:\n\(location)\n"
                        //print("p176 self.newOutput: \(self.newOutput)")
                        
                        
                    } else {
                        
                        body = "\(body)<font size=\"5\"><b>• \(title)</b></font><br>&nbsp;&nbsp;&nbsp;&nbsp;🕑 \(time)<p>"
                        
                        // tried 1 line format. body = "\(body)• \(time)&nbsp;&nbsp;&nbsp;&nbsp;<font size=\"5\"><b>\(title)</b></font><p>"
                        
                        //self.newOutput = "\(self.newOutput)\n ❍ \(title)\n    🕑 \(time)"
                        // print("p176 self.newOutput: \(self.newOutput)")
                    }
                    
                    
                }   // end If loop through items...
                
                body = body + "<br><hr><br>📩 Sent from Dictate™ App 😀</body></html>"
                mailComposerVC.setMessageBody(body, isHTML: true)
                
                self.present(mailComposerVC, animated: true, completion: nil)
                
                
                // self.messageBody = "\(self.newOutput)\n\n\n📩 Sent from Dictate™ App 😀"
                
                
                
                print("p136 self.messageBody: \(self.messageBody)")
                
                //   mailComposerVC.setMessageBody(self.messageBody, isHTML: false)
                
                // self.presentViewController(mailComposerVC, animated: true, completion: nil)
                
            }   //end if self.allEvents != []
            
            
            
        })  // end closure
        
        
        return mailComposerVC
        
    }   //end func mailEvents
    
    
    
    func showSendMailErrorAlert() {
        //TODO fix line below
        
        let alertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
        
    }
    
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(error?.localizedDescription)")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
/*
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

*/
    
}

