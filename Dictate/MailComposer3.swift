//
//  MailComposer3.swift
//  Dictate
//
//  Created by Mike Derr on 7/1/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import MessageUI

class MailComposer3: UIViewController, MFMailComposeViewControllerDelegate {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var allReminderLists:[EKCalendar] = []
    var allReminders: Array<EKReminder> = []
    var numberOfItems:Int = 0
    var newOutput:String = ""
    var messageBody:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
                
        //TODO fix the forced downcast below
        let mainType:String    = defaults.stringForKey("mainType")!
        let output:String    = defaults.stringForKey("output")!
        let toPhone:String    = defaults.stringForKey("toPhone")!
        
        var toRecipents:[String] = []
        toRecipents.append(toPhone)
        
        newOutput = "\(output) \n\n\n Sent from Dictate™ App"
        let messageBody = newOutput
        
        
        //mailComposerVC.setToRecipients(["mike@derr.ws"])
        
        mailComposerVC.setToRecipients(toRecipents)
        
        mailComposerVC.setSubject("Dictate™ App e-mail...")
        mailComposerVC.setMessageBody(newOutput, isHTML: false)
        
        // self.presentViewController(mailComposerVC, animated: true, completion: nil)
        
        return mailComposerVC
        
        
    }
    
    
    func mailList() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        //TODO fix the forced downcast below
        let mainType:String    = defaults.stringForKey("mainType")!
        let output:String    = defaults.stringForKey("output")!
        let toPhone:String    = defaults.stringForKey("toPhone")!
        var reminderList:String = defaults.stringForKey("reminderList")!
        
        var toRecipents:[String] = []
        toRecipents.append(toPhone)
        
        //load and step through reminderList
        allReminderLists = ReminderManager.sharedInstance.eventStore.calendarsForEntityType(EKEntityType.Reminder)
        
        reminderList = reminderList.capitalizedString   //Capitalize first letter
        print("p86 reminderList: \(reminderList)")
        
        if allReminderLists != [] {
            for (index, title) in allReminderLists.enumerate() {
               // print("---------------------------------------------------")
               // print("p82 index, title: \(index), \(title)")
                
                let reminderListTitle = allReminderLists[index]
               // print("p86 reminderListTitle: \(reminderListTitle)")
                
                if reminderListTitle.title == reminderList {
                 
                    ReminderManager.sharedInstance.fetchCalendarReminders(reminderListTitle) { (reminders) -> Void in
                        print(reminders)
                        
                        self.allReminders = reminders as [EKReminder]
                        self.numberOfItems = self.allReminders.count
                        
                        for (index, title) in self.allReminders.enumerate() {
                            print("---------------------------------------------------")
                            print("p103 index, title: \(index), \(title)")
                            
                            let item = self.allReminders[index]
                            print("p106 item.title: \(item.title)")
                            print("p106 self.newOutput: \(self.newOutput)")
                            
                            self.newOutput = "❑ \(item.title)\n \(self.newOutput) "
                            
                            print("p111 self.newOutput: \(self.newOutput)")
          
                        }       // end If loop through items...
                        
                        self.messageBody = "\(self.newOutput)\n\n\n Sent from Dictate™ App"
                        
                        mailComposerVC.setToRecipients(toRecipents)
                        
                        mailComposerVC.setSubject("Reminder List: \(reminderList)...")
                        
                        print("p136 self.messageBody: \(self.messageBody)")
                        
                        mailComposerVC.setMessageBody(self.messageBody, isHTML: false)
                        
                        // self.presentViewController(mailComposerVC, animated: true, completion: nil)
        
                    }       // end closure
                    
                }       // end IF reminderListTitle.title == reminderList
            }
        }       // end allReminderLists != []
      
       // let newOutput = "\(output) \n ✔︎ \n ☐ \n ❑ Sent from Dictate™ App"
       // let messageBody = newOutput
        
        return mailComposerVC
      
    }
    
    func showSendMailErrorAlert() {
        //TODO fix line below
        //let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        
        let sendMailErrorAlert = UIAlertController()
        
        sendMailErrorAlert
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
