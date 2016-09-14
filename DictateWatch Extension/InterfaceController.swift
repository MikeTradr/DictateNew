//
//  InterfaceController.swift
//  DictateWatch Extension
//
//  Created by Mike Derr on 5/4/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    override func didAppear() {
        super.didAppear()
        session = WCSession.default()
        
        session?.sendMessage(["name" : "Anil"], replyHandler: { (response) in
            
            }, errorHandler: { (error) in
                //handle error
        })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}


extension InterfaceController: WCSessionDelegate {
    
}
