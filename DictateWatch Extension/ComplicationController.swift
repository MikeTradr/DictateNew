//
//  ComplicationController.swift
//  ComplicationTester WatchKit Extension
//
//  Created by Mike Derr on 6/20/16.
//  Copyright © 2016 Mike Derr. All rights reserved.
//
// sample started from here:  http://www.techotopia.com/index.php/A_watchOS_2_Complication_Tutorial
//

import ClockKit

//---multipliers to convert to seconds---
let HOUR: NSTimeInterval = 60 * 60
let MINUTE: NSTimeInterval = 60

let imageName = UIImage(named: "micWithAlphaD-58px")!


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let timeLineText = ["Oatmeal Stout at Booth 212", "Porter at Booth 432", "Pale Ale at Booth 232", "English Bitter at Booth 327"]
    
    
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
        
            let currentDate = NSDate()
            handler(currentDate)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
        
        let currentDate = NSDate()
        let endDate =
            currentDate.dateByAddingTimeInterval(NSTimeInterval(4 * 60 * 60))           //4 hours from now for 4 entries
        
        handler(endDate)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        if complication.family == .ModularLarge {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            
            let timeString = dateFormatter.stringFromDate(NSDate())
            
            let entry = createTimeLineEntry(timeString, bodyText: timeLineText[0], date: NSDate())
            
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        
        var timeLineEntryArray = [CLKComplicationTimelineEntry]()
        //var nextDate = NSDate(timeIntervalSinceNow: 1 * 60 * 60)    //every hour
        var nextDate = NSDate(timeIntervalSinceNow: 10 * 60)    //every 10 minutes

        for index in 1...3 {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            
            let timeString = dateFormatter.stringFromDate(nextDate)
            
            let entry = createTimeLineEntry(timeString, bodyText: timeLineText[index], date: nextDate)
            
            timeLineEntryArray.append(entry)
            
            nextDate = nextDate.dateByAddingTimeInterval(10 * 60)   //every 10 minutes hard coded
        }
        handler(timeLineEntryArray)
        
        
        
        //handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        var template: CLKComplicationTemplate?
        
        print("w63 we here complication.family: \(complication.family)")
    /*
        let headerTextTime = "3 PM-4:15"
        let timeUntil = "Now"
        let headerText = headerTextTime + " " + timeUntil
        let body1Text = "Tennis Drills w/Ken Weekly"
        let body2Text = "Ahuska Park"
     */
        switch complication.family {
            
            
            case .ModularLarge:
                
                print("w75 we here .ModularLarge")

                let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
                let headerTextTime = "3 PM-4:15"
               // let timeUntil = "in 15 min"
                let timeUntil = "in 1hr, 36 min"
                let headerText = headerTextTime  //+ "  " + timeUntil
                let body1Text = "Show Apartment"
                //let body2Text = "Ahuska Park"
                let body2Text =  "             " + timeUntil
                
                //let textProvider = CLKSimpleTextProvider(text: "your string here", shortText: "string")

               // modularLargeTemplate.headerImageProvider = CLKImageProvider(onePieceImage: defaultSticker)
                modularLargeTemplate.headerTextProvider = CLKSimpleTextProvider(text: headerText)
                modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: body1Text)
                modularLargeTemplate.body2TextProvider = CLKSimpleTextProvider(text: body2Text)
                
                //modularLargeTemplate.body2TextProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate:.distantFuture())

               
               // let textProvider = CLKTimeTextProvider(date: NSDate())
               // let textProvider = CLKDateTextProvider(date: NSDate(), units: .Day)
               // let textProvider = CLKRelativeDateTextProvider(date: NSDate(), style: .Timer, units: .Hour)
               // let textProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate: .distantFuture())

                
                let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                
             //   modularLargeTemplate.body2TextProvider = CLKTextProvider.text

               // modularLargeTemplate.tintColor = UIColor.yellowColor()
                
                modularLargeTemplate.body2TextProvider!.tintColor = UIColor.yellowColor()
                
                print("w91 headerText: \(headerText)")
                print("w92 body1Text: \(body1Text)")
                print("w93 body2Text: \(body2Text)")

                template = modularLargeTemplate
                handler(modularLargeTemplate)
                
            case .ModularSmall:
                let modularSmallTemplate =  CLKComplicationTemplateModularSmallSimpleImage()
                //let imageName = UIImage(named: "micWithAlphaD-58px")!
                //let imageName = UIImage(named: "u0iNw")!
                
                modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: imageName)
                template = modularSmallTemplate
                
                handler(template)

          
                
            case .CircularSmall:
                let circularSmallTemplate = CLKComplicationTemplateCircularSmallRingImage()
                circularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "micWithAlphaD-58px")!)
                template = circularSmallTemplate
                           
            case .UtilitarianSmall:
                let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingImage()
                utilitarianSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "micWithAlphaD-58px")!)
                template = utilitarianSmallTemplate
     
            case .UtilitarianLarge:
                let headerTextTime = "3 PM-4:15"
                let timeUntil = "Now"
                let headerText = headerTextTime + " " + timeUntil
                
                let utilitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
                utilitarianLargeTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "micWithAlphaD-58px")!)
                utilitarianLargeTemplate.textProvider = CLKSimpleTextProvider(text: headerText)
                template = utilitarianLargeTemplate
      
            
            default:
                template = nil
        }
        handler (template)
    }
    
    // MARK: - Auxiliary methods: Composing templates for timeline entries
    /*
     func composeModularSmallTemplateFor(message: Message) -> CLKComplicationTemplateModularSmallSimpleImage {
     let modularSmallTemplate = CLKComplicationTemplateModularSmallSimpleImage()
     
     if let stickerImage = getStickerImageFromMessage(message) {
     modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: stickerImage)
     }
     
     return modularSmallTemplate
     }
     */
    
    func createTimeLineEntry(headerText: String, bodyText: String, date: NSDate) -> CLKComplicationTimelineEntry {
        
        let template = CLKComplicationTemplateModularLargeStandardBody()
        let beerGlass = UIImage(named: "micWithAlphaD-58px")
        
        template.headerImageProvider =
            CLKImageProvider(onePieceImage: beerGlass!)
        template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
        template.body1TextProvider = CLKSimpleTextProvider(text: bodyText)
        
        let entry = CLKComplicationTimelineEntry(date: date,
                                                 complicationTemplate: template)
        
        return(entry)
    }
    
    
    
    
}
