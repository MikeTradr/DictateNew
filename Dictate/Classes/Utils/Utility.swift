//
//  Utility.swift
//  Dictate
//
//  Created by Mike Derr on 3/2/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    /**
     Show alert, internaly using UIAlertController
     
     - parameter title:             title
     - parameter message:           message
     - parameter cancelButtonTitle: cancel button title
     - parameter onViewController:  If you are showing alert from modal view,you should pass viewController
     */
    class func showAlert(title: String?, message: String?,cancelButtonTitle: String = "OK", onViewController:UIViewController? = nil){
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertVC.addAction(UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil))
        let rootVC = onViewController != nil ? onViewController : UIApplication.sharedApplication().keyWindow?.rootViewController
        rootVC?.presentViewController(alertVC, animated: true, completion: nil)
    }
}

