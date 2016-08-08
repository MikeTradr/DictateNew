//
//  MessageCode.swift
//  Dictate
//
//  Created by Mike Derr on 6/30/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
// from:   http://www.reddit.com/r/swift/comments/2j5xjs/how_can_i_send_sms_in_ios_with_swift/

import UIKit
import MessageUI

//class SendMessage: UIViewController, MFMessageComposeViewControllerDelegate {
    
class SendMessage: UIViewController, MFMessageComposeViewControllerDelegate {

    
    func sendText() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController();
            controller.body = "Text Message Body Here";
            controller.recipients = ["(415) 555-4387"]
            controller.messageComposeDelegate = self;
            self.presentViewController(controller, animated: true, completion: nil);
        }
    }
    
    // this function will be called after the user presses the cancel button or sends the text
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}