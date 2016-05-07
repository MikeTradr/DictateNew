//
//  ConnectivityPhoneManager.swift
//  Dictate
//
//  Created by Mike Derr on 5/7/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit
import WatchConnectivity

@available(iOS 9.0, *)
class ConnectivityPhoneManager: NSObject, WCSessionDelegate {
    
    class var sharedInstance : ConnectivityPhoneManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ConnectivityPhoneManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ConnectivityPhoneManager()
        }
        return Static.instance!
    }
    
    var label = ""
    let now = NSDate()
    var timeOutput = ""
    var outputInterval = ""
    let dateFormatter = NSDateFormatter()
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var dict = [String: String]()   //make empty dictionary
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
 
    
    //pass NSUserDefaults Key to send to watch"
    func sendKey(keyString:String) {  //key is the UserDefaults ID
        print("p36 key: \(keyString)")
        
        let updatedValue:String = defaults.stringForKey(keyString)!
        print("p40 updatedValue: \(updatedValue)")

        dict[keyString] = updatedValue
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
       //send message to watch
       //session?.sendMessage([keyString:updatedValue], replyHandler: nil, errorHandler: nil)
       // session?.sendMessage(dict, replyHandler: nil, errorHandler: nil)

        
        // The paired iPhone has to be connected via Bluetooth.
        if let session = session where session.reachable {
            session.sendMessage(dict,
                                replyHandler: { replyData in
                                    // handle reply from iPhone app here
                                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error.description)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }
        
        
    }   //end func sendKey
    
    func recieveKey(keyString:String) {  //key is the UserDefaults ID
        
        
    
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        //recieve messages from watch
        let key = message
        
        //defaults.setObject(defaultReminderListID, forKey: "defaultReminderListID")    //sets defaultReminderList
        
        let data = "0000"
        let forKey  = "defaultReminderListID"

        defaults.setObject(data, forKey: forKey)    //sets data into forKey USerData

        
       // let counterValue = message[key]

    
    
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            if let counterValue = message["counterValue"] as? Int {
               // self.counterData.append(counterValue)
               // self.mainTableView.reloadData()
            }
        }
    }
    
    
    
    
        
}   //end class
        
        
   





