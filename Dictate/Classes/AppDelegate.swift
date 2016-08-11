//
//  AppDelegate.swift
//  Dictate
//
//  Created by Mike Derr on 5/8/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Fabric
import Crashlytics
import WatchConnectivity


@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    //Anill's

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        WatchSessionManager.sharedManager.startSession()
        
        Fabric.with([Crashlytics.self])
        
        // TODO: Move this to where you establish a user session
        self.logUser()
   
        Parse.enableLocalDatastore()
        
        // ****************************************************************************
        // Uncomment this line if you want to enable Crash Reporting
        // ParseCrashReporting.enable()
        //
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        
        PFUser.enableAutomaticUser()
        
        // Enable data sharing in main app.
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp")


      //  Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp",
       //     containingApplication: "com.thatsoft.dictateApp")
        
        // Setup Parse
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        //        let defaultACL = PFACL();
        //
        //        // If you would like all objects to be private by default, remove this line.
        //        defaultACL.setPublicReadAccess(true)
        //
        //        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        
        
        
        
        //        // Initialize Parse.
        //        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
        //            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //from LittleApp
        
        PFUser.currentUser()?.incrementKey("RunCount")
        PFUser.currentUser()?.saveInBackground()
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            /*
            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
            */
            
            let types: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
            //TODO FIX ERROR HERE
            // application.registerForRemoteNotificationTypes(types)
            
            
        }
        
        // Enable data sharing in main app.
     //   Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp")
        
        // Setup Parse
       // Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE", clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent    //set top menu to white text
        

        if let tabBarController = self.window!.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 2    //set to start at tab index 2
        }
   /*
       // let firstLaunch: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("isFirstLaunch")
        if firstLaunch == nil{
            //set NSDefault at startup
            DataManager.sharedInstance.createDefaults()
            NSUserDefaults.standardUserDefaults().setObject("DictateFirstLaunh", forKey: "isFirstLaunch")
        }
   */
        let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
        
        let firstLaunch = defaults.boolForKey("isFirstLaunch")
        if firstLaunch  {
            print("p139 Not first launch.")
        } else {
            print("p141 First launch, setting NSUserDefault.")
            defaults.setBool(true, forKey: "isFirstLaunch")
            
            //initialize defaults first time app launched...
            DataManager.sharedInstance.createDefaults()
        }
    
        
        //get Access to Reminders
        NSLog("%@ p127 appDelegate", self)
        print("p128 call getAccessToEventStoreForType")
        ReminderManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Reminder, completion: { (granted) -> Void in
            
            if granted{
                print("p132 Reminders granted: \(granted)")
                }
        })
        
        //get Access to Events
        NSLog("%@ p137 appDelegate", self)
        print("p138 call getAccessToEventStoreForType")
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Event, completion: { (granted) -> Void in
            
            if granted{
                print("p142 Events granted: \(granted)")
            }
        })

       
        

        
        
    
//_____ Initialize calls ______________________________________________________
        
        //make Reminder's List Array
        NSLog("%@ p127 appDelegate", self)
        print("p128 here")
   //     ReminderManager.sharedInstance.createReminderArray()
        
        //make Calendar's List Array
        EventManager.sharedInstance.createCalendarArray()
        
        //make ReminderStringList Array
        ReminderManager.sharedInstance.createReminderStringArray()
   /*
        //temp to remove TODO  112715  added for new variables here. SEt on first initialization so maybe ok to remove now.
        let newAlert = 30
        defaults.setObject(newAlert, forKey: "defaultEventAlert")
        
        let duration = 10
        defaults.setObject(duration, forKey: "defaultEventDuration")
 */
        
        //make Calendar's List Array LOCAL CALENDARS TODO
   //     ReminderManager.sharedInstance.getLocalEventCalendars()
        
       
        //TODO Anil can we pull users device info, system version, users  location? city, state country? and stuff??? to save to parse db
        
        let app = UIApplication.sharedApplication()
        print("p147 app: \(app)")
        
        print("p149 Device and Phone munber in here: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")

        // above here attempted to get device info
                
//_____ End Initialize calls ______________________________________________________
      


        //put badge on app icon here...
        let restartGameCategory = UIMutableUserNotificationCategory()
        
        application.registerUserNotificationSettings(
            UIUserNotificationSettings(
                forTypes: [.Alert, .Badge, .Sound],
                categories: (NSSet(array: [restartGameCategory])) as? Set<UIUserNotificationCategory>))
        
        let count:Int = EventManager.sharedInstance.countEventsToday(0)
        application.applicationIconBadgeNumber = count
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
        }
        
        return true
    }       // end didFinishLaunchingWithOptions
    
    
    func logUser() {
        //TODO Mike TODO Anil add user informatione here...
        // TODO: Use the current user's information
        // You can call any combination of these three methods
      //  Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
      //  Crashlytics.sharedInstance().setUserIdentifier("12345")
     //   Crashlytics.sharedInstance().setUserName("Test User")
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n");
            } else {
                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error)
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    
    
 
}


@available(iOS 9.0, *)
extension AppDelegate: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
    /*    if let name = message["name"] as? String {
            print("p302 Received data: \(name)")
        }
     */
        if let action = message["action"] as? String {
            print("p307 action: \(action)")
            
            setDefaultsWithMessage(message)
            
            if action == "Event" {
                EventManagerSave.sharedInstance.createEvent()
            }
            
            if action == "Reminder" {
                let output = (message["output"] as? String)!
                let outputArray:[String] = Array(arrayLiteral: output)  //make output into Array for func call below
                let calendarName:String = (message["calendarName"] as? String)!
                print("p315 outputArray: \(outputArray)")
                print("p315 calendarName: \(calendarName)")
                
                ReminderManagerSave.sharedInstance.addReminder(calendarName, items: outputArray)
            }
            
            if action == "saveReminder" {
                let reminderItem = (message["reminderItem"] as? EKReminder)!
               
                print("p325 reminderItem: \(reminderItem)")
                
                ReminderManagerSave.sharedInstance.saveReminder(reminderItem)
            }
            
            
            
           
        }
        
        replyHandler(["status":"Success"])
    }
    
    func setDefaultsWithMessage(message:[String : AnyObject]){
        let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
        defaults.setObject(message["startDT"], forKey: "startDT")
        defaults.setObject(message["endDT"], forKey: "endDT")
        defaults.setObject(message["output"], forKey: "output")
        defaults.setObject(message["outputNote"], forKey: "outputNote")
       // defaults.setObject(message["eventDuration"], forKey: "eventDuration")
        defaults.setObject(message["eventLocation"], forKey: "eventLocation")
        defaults.setObject(message["eventRepeat"], forKey: "eventRepeat")
        defaults.setObject(message["action"], forKey: "actionType")
        defaults.setObject(message["calendarName"], forKey: "calendarName")

    }
}




/*


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        Parse.enableLocalDatastore()
        
        // ****************************************************************************
        // Uncomment this line if you want to enable Crash Reporting
        // ParseCrashReporting.enable()
        //
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************


        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp")
        
        // Initialize Parse.
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }

        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            /*
            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
            */
            
            let types = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
            //TODO FIX ERROR HERE
            // application.registerForRemoteNotificationTypes(types)
            
            
        }
        
        // Enable data sharing in main app.
       // Parse.enableDataSharingWithApplicationGroupIdentifier(<#groupIdentifier: String#>)
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp")
    
        
        // Setup Parse
        //Parse.setApplicationId(“<ParseAppId>”, clientKey: “<ClientKey>”)
        
        Parse.setApplicationId("1wwwPAQ0Of2Fp6flotUw4YzN64HFDmy3ijAlQZKE",
            clientKey: "EHeeek4uXhJQi0vXPBba945A4h0LQ4QddEGW8gSs")
        
        
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        //UITabBar.appearance().barTintColor = UIColor.blackColor()
        //UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        //TODO set to start at tab index 2
        
        //self.window.rootViewController
        
        //tabBarController?.selectedIndex = 0
        
        //works  let tabBar: UITabBarController = self.window?.rootViewController as! UITabBarController
        
        /// works tabBar.selectedIndex = 2
        
        if let tabBarController = self.window!.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 2
        }
        
        return true
        
    }
    

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            println("Push notifications are not supported in the iOS Simulator.")
        } else {
            println("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // UIApplication.sharedApplication().statusBarStyle = .LightContent
        
    }
    
    
    
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

*/
