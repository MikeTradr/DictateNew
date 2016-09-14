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
    
    let version: String = "1.2.7"
        
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelVersion: UILabel!
    
    @IBAction func buttonThatSoftLogo(_ sender: AnyObject) {
        if let url = URL(string: "http://www.ThatSoft.com") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func buttonThatSoftURL(_ sender: AnyObject) {
        if let url = URL(string: "http://www.ThatSoft.com") {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func buttonMailUs(_ sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let toRecipents = ["support@thatsoft.com"]
            let emailTitle = "📩 from Dictate..."
            let messageBody = "Enter Your message here:\n"
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(emailTitle)
            mail.setMessageBody(messageBody, isHTML: false)
            mail.setToRecipients(toRecipents)

            present(mail, animated: true, completion: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


    
    
    
}
