//
//  WatchGeneral.swift
//  Dictate
//
//  Created by Mike Derr on 6/13/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
//import MessageUI //commented for new watchExtension 040516
//import AVFoundation  //commented for new watchExtension 040516
//FIXWC import Parse


//import CoreTelephony
//import CoreTelephony

class WatchGeneral: NSObject {
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var carrierName = ""
    var mcc = ""
    var mnc = ""
    

    

  // var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep2", ofType: "mp3")!)
    
    // make sure to add this sound to your project
  //  var alertSound3 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep2", ofType: "mp3")!)
  //  var audioPlayer = AVAudioPlayer()

  //  var sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep2", ofType: "mp3")!)
    
    // make sure to add this sound to your project
 //   var alertSound3 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Beep2", ofType: "mp3")!)
   // var audioPlayer = AVAudioPlayer()
    
    //---- my General functions ----------------------------------------
 /*
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene) 
        // TODO FIX    self.presentViewController(vc, animated: true, completion: nil)
    }
*/
    func cleardata() {
        print("General p37 we here cleardata")
        
        var mainType = ""
        var day = ""
        var timeString = ""
        var phone = ""
        var fullDT = ""
        var fullDTEnd = ""
        var outputNote = ""
        var calendarName = ""
        
        /*
        resultType.text = ""
        resultDate.text = ""
        resultTime.text = ""
        resultPhone.text = ""
        resultStartDate.text = ""
        resultEndDate.text = ""
        resultTitle.text = ""
        resultCalendar.text = ""
        
        enteredText2.text = ""
        
        */
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
 /*
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // self.view.endEditing(true)
        return false
    }
*/
    func makeCall(toPhone:String) {
        
        if let url = NSURL(string: "tel://\(toPhone)") {
            //TODO Anl can this work here?
            //UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func saveToParse() {
        
        // ____ Save to Parse Database ____________________________________
        
        let strRaw      = defaults.stringForKey("strRaw")
        let actionType:String  = defaults.stringForKey("actionType")!
        var output      = defaults.stringForKey("output")
        var calendarName    = defaults.stringForKey("calendarName")


        
        print("p99 output: \(output)")
        print("p99 calendarName: \(calendarName)")


//FIXWC
        /*
        let rawDataObject = PFObject(className: "UserData")
        rawDataObject["rawString"] = strRaw                 //TODO why this black others blue??
        rawDataObject["output"] = output
        rawDataObject["fullDT"] = fullDT
        rawDataObject["fullDTEnd"] = fullDTEnd
        rawDataObject["actionType"] = actionType            //TODO why this black others blue??
        rawDataObject["calendarName"] = calendarName
*/
        //TODO get these two fields from code!
        //TODO see here:
        print("109 Device and Phone munber in here: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")
 /*
        let uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let device = UIDevice.currentDevice().model
        let systemVersion = UIDevice.currentDevice().systemVersion
        
        let modelName = UIDevice.currentDevice().modelName
        
        let memory = NSProcessInfo.processInfo().physicalMemory/(1024 * 1024 * 1024)    //to convert to GB
        // memory = memory/(1024 * 1024 * 1024)
        
        // Setup the Network Info and create a CTCarrier object
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        //let carrierName: String = "no carrier"
        
        print("p127 networkInfo: \(networkInfo)")
        print("p127 carrier: \(carrier)")
 
     
        
        // Get carrier name
        if carrier != nil {
            carrierName = carrier!.carrierName!
            print("p139 carrierName: \(carrierName)")
            mcc = carrier!.mobileCountryCode!
            mnc = carrier!.mobileNetworkCode!

            
        }
        
        //print("p\(#line) uuid: \(uuid)")
        print("p127 uuid: \(uuid)")
        print("p127 device: \(device)")
        print("p127 systemVersion: \(systemVersion)")
        print("p127 modelName: \(modelName)")
        print("p127 memory: \(memory)")
        print("p127 carrierName: \(carrierName)")
        print("p157 mcc: \(mcc)")
        print("p157 mnc: \(mnc)")
    
        let deviceComplete = "\(modelName) - \(memory) GB"
        
        print("p127 deviceComplete: \(deviceComplete)")
        
        rawDataObject["device"] = deviceComplete
        rawDataObject["system"] = systemVersion
        rawDataObject["carrier"] = carrierName
        rawDataObject["mcc"] = mcc
        rawDataObject["mnc"] = mnc
        
        rawDataObject["userPhoneNumber"] = "608-242-7700"               //TODO hardcoded get device from code?
        
        //TODO get this from login Screen, hard coded for now...
        
        print("p146 PFUser.currentUser(): \(PFUser.currentUser()!)")
        
        //TODO fix PFuser when is nil can be nil???
 */
 //FIXWC
/*
        if PFUser.currentUser() == nil {
            rawDataObject["userName"] = "Mike Coded"
        } else {
            // rawDataObject["userName"] = "Mike Hard Coded"
            
            print("p155 PFUser.currentUser().username: \(PFUser.currentUser()!.username!)")
            
            // todo bombs below here.
            //TODO Anil I chnged as had nil, when we no longer sue login screen 123115 MJD
            //rawDataObject["userName"] = PFUser.currentUser()!.username
            rawDataObject["userName"] = PFUser.currentUser()!.username!
        }
 */
        print("p\(#line) we here? ")
        print("p168 we here? ")
        
        //TODO works, hard coded name for now Anil help
       // commented fixed above? 012916MJD rawDataObject["userName"] = "Mike TEST Coded"
        
        // TODO used to have this alone:  rawDataObject["userName"] = PFUser.currentUser()?.username
        
//FIXWC        let query = PFQuery(className:"UserData")
        //TODO somehow get and save email to parse database
        // query.whereKey(“username”, equalTo: PFUser.currentUser()?.username)
        
//FIXWC        print("p174 query: \(query)")
 //FIXWC
/*
        if PFUser.currentUser()?.email != nil {
            print("p176 PFUser.currentUser()?.email: \(PFUser.currentUser()?.email!)")
            rawDataObject["userEmail"] = PFUser.currentUser()?.email!
        }
        
        rawDataObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("p214 General rawDataObject has been saved.")
        }
*/        
        // ____ End Save to Parse Database ____________________________________
        
        
        
    }
    
    
    


    

    //---- end my Gerneral functions -------------------------------------
    
}

/*
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        var devSpec : String

        
        switch identifier {
            case "iPhone1,2": devSpec = "iPhone 3G"
            case "iPhone2,1": devSpec = "iPhone 3GS"
            case "iPhone3,1": devSpec = "iPhone 4"
            case "iPhone3,3": devSpec = "Verizon iPhone 4"
            case "iPhone4,1": devSpec = "iPhone 4S"
            case "iPhone5,1": devSpec = "iPhone 5 (GSM)"
            case "iPhone5,2": devSpec = "iPhone 5 (GSM+CDMA)"
            case "iPhone5,3": devSpec = "iPhone 5c (GSM)"
            case "iPhone5,4": devSpec = "iPhone 5c (GSM+CDMA)"
            case "iPhone6,1": devSpec = "iPhone 5s (GSM)"
            case "iPhone6,2": devSpec = "iPhone 5s (GSM+CDMA)"
            case "iPhone7,1": devSpec = "iPhone 6 Plus"
            case "iPhone7,2": devSpec = "iPhone 6"
            case "iPhone8,1": devSpec = "iPhone 6s"
            case "iPhone8,2": devSpec = "iPhone 6s Plus"
            case "iPod1,1": devSpec = "iPod Touch 1G"
            case "iPod2,1": devSpec = "iPod Touch 2G"
            case "iPod3,1": devSpec = "iPod Touch 3G"
            case "iPod4,1": devSpec = "iPod Touch 4G"
            case "iPod5,1": devSpec = "iPod Touch 5G"
            case "iPad1,1": devSpec = "iPad"
            case "iPad2,1": devSpec = "iPad 2 (WiFi)"
            case "iPad2,2": devSpec = "iPad 2 (GSM)"
            case "iPad2,3": devSpec = "iPad 2 (CDMA)"
            case "iPad2,4": devSpec = "iPad 2 (WiFi)"
            case "iPad2,5": devSpec = "iPad Mini (WiFi)"
            case "iPad2,6": devSpec = "iPad Mini (GSM)"
            case "iPad2,7": devSpec = "iPad Mini (GSM+CDMA)"
            case "iPad3,1": devSpec = "iPad 3 (WiFi)"
            case "iPad3,2": devSpec = "iPad 3 (GSM+CDMA)"
            case "iPad3,3": devSpec = "iPad 3 (GSM)"
            case "iPad3,4": devSpec = "iPad 4 (WiFi)"
            case "iPad3,5": devSpec = "iPad 4 (GSM)"
            case "iPad3,6": devSpec = "iPad 4 (GSM+CDMA)"
            case "iPad4,1": devSpec = "iPad Air (WiFi)"
            case "iPad4,2": devSpec = "iPad Air (Cellular)"
            case "iPad4,4": devSpec = "iPad mini 2G (WiFi)"
            case "iPad4,5": devSpec = "iPad mini 2G (Cellular)"
                
            case "iPad4,7": devSpec = "iPad mini 3 (WiFi)"
            case "iPad4,8": devSpec = "iPad mini 3 (Cellular)"
            case "iPad4,9": devSpec = "iPad mini 3 (China Model)"
                
            case "iPad5,3": devSpec = "iPad Air 2 (WiFi)"
            case "iPad5,4": devSpec = "iPad Air 2 (Cellular)"
                
            case "i386": devSpec = "Simulator"
            case "x86_64": devSpec = "Simulator"
                
            default: devSpec = "Unknown"
                
        }

        return devSpec

        
        
        
   /*
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }

*/
 
    }
    
}
 
 */

public extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
                
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}





