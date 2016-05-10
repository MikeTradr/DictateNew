//
//  FavoritesManager.swift
//  Dictate
//
//  Created by Mike Derr on 9/13/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit

class FavoritesManager: NSObject {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!

    
    class var sharedInstance : FavoritesManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : FavoritesManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = FavoritesManager()
        }
        return Static.instance!
    }
    
    struct Contact {
        let name: String
        let phone: String
        let email: String
    }
    
    let mike = Contact(name: "mike", phone: "608-242-7700", email: "mike@derr.ws")
    let stephanie = Contact(name: "stephanie", phone: "608-692-6132", email: "steph@derr.ws")
    let mom = Contact(name: "mom", phone: "608-963-8347", email: "germangirl1988@gmail.com")
/*
    func dictionaryFromContacts() -> NSDictionary
    {
        let dictionary: [String: String] = ["name": name, "Phone": phone, "email": email]
        return dictionary
    }
*/

    
    
    
    
    //hard code for now favorites
    //TODO make array  TODO anil  TODO Mike
    
    var favorites = [
        ["name":"Mike",         "phone":"608-242-7700",     "email":"mike@thatsoft.com"],
        ["name":"Stephanie",    "phone":"608-692-6132",     "email":"steph@derr.ws"],
        ["name":"Mom",          "phone":"608-963-8347",     "email":"germangirl1988@gmail.com"],
        ["name":"Jonathan",     "phone":"608-220-8543",     "email":"jonathanmwild@gmail.coms"],
        ["name":"Andrew",       "phone":"262-412-8745",     "email":"aw@rouse.biz"],
    ]
  
    // to call
    // let phone = favorites.filter{$0["name"] == "Mike"}

    
    
}
