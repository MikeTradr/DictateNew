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
        
        var newOutput = "\(output) \n\n\n Sent from Dictate™ App"
        let messageBody = newOutput
        
        
        //mailComposerVC.setToRecipients(["mike@derr.ws"])
        
        mailComposerVC.setToRecipients(toRecipents)
        
        mailComposerVC.setSubject("Dictate™ App e-mail...")
        mailComposerVC.setMessageBody(newOutput, isHTML: false)
        
        // self.presentViewController(mailComposerVC, animated: true, completion: nil)
        
        return mailComposerVC
        
        
    }
    
    func showSendMailErrorAlert() {
        //TODO fix line below
        //let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        
        let sendMailErrorAlert = UIAlertController()
        
        sendMailErrorAlert
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
