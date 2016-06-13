//
//  ComplicationController.swift
//  DictateWatch Extension
//
//  Created by Mike Derr on 5/4/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    var image = UIImage()
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates

    //---multipliers to convert to seconds---
    let HOUR: NSTimeInterval = 60 * 60
    let MINUTE: NSTimeInterval = 60
    
    
 /*
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        var template: CLKComplicationTemplate?
        
        switch complication.family {
        case .CircularSmall:
            template = CLKComplicationTemplateCircularSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "app_icon")!)
        case .UtilitarianSmall:
            template = CLKComplicationTemplateUtilitarianSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "app_icon")!)
        case .ModularSmall:
            template = CLKComplicationTemplateModularSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "app_icon")!)
        case .ModularLarge:
            template = nil
        case .UtilitarianLarge:
            template = nil
        }
        
        handler(template)
    }
    
*/
    func getPlaceholderTemplateForComplication(
        complication: CLKComplication,
        withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and
        // the results will be cached       
        
        
        // handler(nil)
        var template: CLKComplicationTemplate?
        switch complication.family {
    /*
            
        case .ModularSmall:
            
            let fgImage = UIImage(named: "app_icon")
            //Initialize imageProvider from Apple
            let imageProvider = CLKImageProvider(backgroundImage: bgImage,
                                                 backgroundColor: aColor,
                                                 foregroundImage: fgImage,
                                                 foregroundColor: CLKImageProviderForegroundColor.White)

            
            template = CLKComplicationTemplateModularSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "app_icon")!)
*/
        case .ModularSmall:
          //  let modularSmallTemplate =  CLKComplicationTemplateModularSmallRingText()
          //  modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: "D_%")

            let modularSmallTemplate =  CLKComplicationTemplateModularSmallSimpleImage()
            
            //Set images for both watch sizes :)
            let thisDevice = WKInterfaceDevice.currentDevice()
            let rect:CGRect =  thisDevice.screenBounds
            if (rect.size.height == 195.0) {
                // Apple Watch 42mm
               // image = UIImage(named: "micAlpha3-58px")!.imageWithRenderingMode(.AlwaysTemplate)
                image = UIImage(named: "micWithAlphaD-58px")!
            } else if (rect.size.height == 170.0){
                // Apple Watch 38mm
                image = UIImage(named: "micWithAlphaD-52px")!.imageWithRenderingMode(.AlwaysTemplate)
            }
            
            //     modularSmallTemplate.imageProvider = CLKImageProvide(onePieceImage: UIImage(named: "app_icon")!)
            //    modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "micWithAlphaD-58px")!)
            
            modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: image)

            
          //  let imager = CLKImageProvider(onePieceImage: image)

        //    modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: "R")
        //    modularSmallTemplate.fillFraction = 0.75
         //   modularSmallTemplate.ringStyle = CLKComplicationRingStyle.Closed
            
            template = modularSmallTemplate


            
        case .ModularLarge:
            let modularLargeTemplate =
                CLKComplicationTemplateModularLargeStandardBody()
            modularLargeTemplate.headerTextProvider =
                CLKTimeIntervalTextProvider(startDate: NSDate(),
                                            endDate: NSDate(timeIntervalSinceNow: 1.5 * HOUR))
            modularLargeTemplate.body1TextProvider =
                CLKSimpleTextProvider(text: "Movie Name",
                                      shortText: "Movie")
            modularLargeTemplate.body2TextProvider =
                CLKSimpleTextProvider(text: "Running Time",
                                      shortText: "Time")
            template = modularLargeTemplate
        case .UtilitarianSmall:
            /*
                let percentage = WatchEntryHelper.sharedHelper.percentage() ?? 0

           
                let smallFlat = CLKComplicationTemplateUtilitarianSmallFlat()
                smallFlat.textProvider = CLKSimpleTextProvider(text: "\(percentage)%")
                smallFlat.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "complication")!)
                smallFlat.tintColor = .mainColor()
                handler(CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: smallFlat))
        
            */
            
            
            template = nil
        case .UtilitarianLarge:
            template = nil
        case .CircularSmall:
            template = nil
       // default:
        //     template = nil
           
            
        }
 
 
        handler(template)
    }


    
}
