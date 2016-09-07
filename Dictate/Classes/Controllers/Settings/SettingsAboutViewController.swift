//
//  SettingsAboutViewController.swift
//  Dictate
//
//  Created by Mike Derr on 3/6/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit
import MessageUI

class SettingsAboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let version: String = "1.2.2"
        
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelVersion: UILabel!
    
    @IBAction func buttonThatSoftLogo(sender: AnyObject) {
        if let url = NSURL(string: "http://www.ThatSoft.com") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func buttonThatSoftURL(sender: AnyObject) {
        if let url = NSURL(string: "http://www.ThatSoft.com") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    @IBAction func buttonMailUs(sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let toRecipents = ["support@thatsoft.com"]
            let emailTitle = "📩 from Dictate..."
            let messageBody = "Enter Your message here:\n"
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(emailTitle)
            mail.setMessageBody(messageBody, isHTML: false)
            mail.setToRecipients(toRecipents)

            presentViewController(mail, animated: true, completion: nil)
        } else {
            // give feedback to the user
            //TODO Anil Mike Add Error Alert Dialog?
            
            //add call Utility- alert dialog
            print("p61 Error can not send mail now")
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          labelVersion.text = "v \(version)"
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Saved")
        case MFMailComposeResultSent.rawValue:
            print("Sent")
        case MFMailComposeResultFailed.rawValue:
            print("Error: \(error?.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }


    
    
    
}
