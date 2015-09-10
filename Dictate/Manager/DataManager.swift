//
//  DataManager.swift
//  Dictate
//
//  Created by Anil Varghese on 10/09/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    class var sharedInstance : DataManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : DataManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DataManager()
        }
        return Static.instance!
    }

}
