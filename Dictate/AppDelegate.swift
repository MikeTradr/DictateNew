//
//  AppDelegate.swift
//  WatchInput
//
//  Created by Mike Derr on 5/8/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    //Anill's 

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
       // Crashlytics().debugMode = true
        Fabric.with([Crashlytics()])    // added 081715 for Crash reporting   MJD

        
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
        
        Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.thatsoft.dictateApp")
        
        //Parse.enableDataSharingWithApplicationGroupIdentifier("group.com.parse.Dictate", containingApplication: "com.parse.Dictate")
        
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
        
        //make Reminder's List Array
        ReminderManager.sharedInstance.createReminderArray()
        
        //make Calendar's List Array
        ReminderManager.sharedInstance.createCalendarArray()
        
        
        //make Calendar's List Array
   //     ReminderManager.sharedInstance.getLocalEventCalendars()

        
        //TODO Anil can we pull users device info, sys tem version, and stuff??? to save to parse db
        
        let app = UIApplication.sharedApplication()
        println("p147 app: \(app)")
        
        println("p149 Device and Phone munber in here: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")

        // above here attempted to get device info
        
        
        
        
        
        
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
