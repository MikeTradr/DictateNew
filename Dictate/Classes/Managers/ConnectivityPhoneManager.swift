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
    
    private static var __once: () = {
            Static.instance = ConnectivityPhoneManager()
        }()
    
    class var sharedInstance : ConnectivityPhoneManager {
        struct Static {
            static var onceToken : Int = 0
            static var instance : ConnectivityPhoneManager? = nil
        }
        _ = ConnectivityPhoneManager.__once
        return Static.instance!
    }
    
    var label = ""
    let now = Date()
    var timeOutput = ""
    var outputInterval = ""
    let dateFormatter = DateFormatter()
    
    let defaults = UserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    var dict = [String: String]()   //make empty dictionary
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    
 
    
    //pass NSUserDefaults Key to send to watch"
    func sendKey(_ keyString:String) {  //key is the UserDefaults ID
        print("p36 key: \(keyString)")
        
        let updatedValue:String = defaults.string(forKey: keyString)!
        print("p40 updatedValue: \(updatedValue)")

        dict[keyString] = updatedValue
        
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
       //send message to watch
       //session?.sendMessage([keyString:updatedValue], replyHandler: nil, errorHandler: nil)
       // session?.sendMessage(dict, replyHandler: nil, errorHandler: nil)

        
        // The paired iPhone has to be connected via Bluetooth.
        if let session = session , session.isReachable {
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
    
    func recieveKey(_ keyString:String) {  //key is the UserDefaults ID
        
        
    
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //recieve messages from watch
        let key = message
        
        //defaults.setObject(defaultReminderListID, forKey: "defaultReminderListID")    //sets defaultReminderList
        
        let data = "0000"
        let forKey  = "defaultReminderListID"

        defaults.set(data, forKey: forKey)    //sets data into forKey USerData

        
       // let counterValue = message[key]

    
    
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async {
            if let counterValue = message["counterValue"] as? Int {
               // self.counterData.append(counterValue)
               // self.mainTableView.reloadData()
            }
        }
    }
    
    
    
    
        
}   //end class
        
        
   





