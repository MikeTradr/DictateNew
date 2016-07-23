//
//  ComplicationController.swift
//  DictateWatch Extension
//
//  Created by Mike Derr on 5/4/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//


import ClockKit



/*
struct Show {
    var name: String
    var shortName: String?
    var genre: Strin
    
    var startDate: NSDate
    var length: NSTimeInterval
}

let hour: NSTimeInterval = 60 * 60
let shows = [
    Show(name: "Into the Wild", shortName: "Into Wild", genre: "Documentary", startDate: NSDate(), length: hour * 1.5),
    Show(name: "24/7", shortName: nil, genre: "Drama", startDate: NSDate(timeIntervalSinceNow: hour * 1.5), length: hour),
    Show(name: "How to become rich", shortName: "Become Rich", genre: "Documentary", startDate: NSDate(timeIntervalSinceNow: hour * 2.5), length: hour * 3),
    Show(name: "NET Daily", shortName: nil, genre: "News", startDate: NSDate(timeIntervalSinceNow: hour * 5.5), length: hour)
]

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler(.Forward)
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: (60 * 60 * 24)))
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        let show = shows[0]
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.startDate, endDate: NSDate(timeInterval: show.length, sinceDate: show.startDate))
        template.body1TextProvider = CLKSimpleTextProvider(text: show.name, shortText: show.shortName)
        template.body2TextProvider = CLKSimpleTextProvider(text: show.genre, shortText: nil)
        
        let entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.25, sinceDate: show.startDate), complicationTemplate: template)
        handler(entry)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        
        var entries: [CLKComplicationTimelineEntry] = []
        
        for show in shows
        {
            if entries.count < limit && show.startDate.timeIntervalSinceDate(date) > 0
            {
                let template = CLKComplicationTemplateModularLargeStandardBody()
                
                template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.startDate, endDate: NSDate(timeInterval: show.length, sinceDate: show.startDate))
                template.body1TextProvider = CLKSimpleTextProvider(text: show.name, shortText: show.shortName)
                template.body2TextProvider = CLKSimpleTextProvider(text: show.genre, shortText: nil)
                
                let entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.25, sinceDate: show.startDate), complicationTemplate: template)
                entries.append(entry)
            }
        }
        
        handler(entries)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate: NSDate(timeIntervalSinceNow: 60 * 60 * 1.5))
        template.body1TextProvider = CLKSimpleTextProvider(text: "Show Name", shortText: "Name")
        template.body2TextProvider = CLKSimpleTextProvider(text: "Show Genre", shortText: nil)
        
        handler(template)
    }
}




*/









import ClockKit
import WatchKit

struct Show {
    var name: String
    var shortName: String?
    var genre: String
    
    var startDate: NSDate
    var length: NSTimeInterval
}

let hour: NSTimeInterval = 60 * 60
let shows = [
    Show(name: "Into the Wild", shortName: "Into Wild", genre: "Documentary", startDate: NSDate(), length: hour * 1.5),
    Show(name: "24/7", shortName: nil, genre: "Drama", startDate: NSDate(timeIntervalSinceNow: hour * 1.5), length: hour),
    Show(name: "How to become rich", shortName: "Become Rich", genre: "Documentary", startDate: NSDate(timeIntervalSinceNow: hour * 2.5), length: hour * 3),
    Show(name: "NET Daily", shortName: nil, genre: "News", startDate: NSDate(timeIntervalSinceNow: hour * 5.5), length: hour)
]

class ComplicationControllerORG: NSObject, CLKComplicationDataSource {
    
    var image = UIImage()
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: (60 * 60 * 24)))
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
  //  func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
  //      handler(nil)
  //  }
    
    
    // MARK: - Timeline Population
 /*
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        let show = shows[0]
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.startDate, endDate: NSDate(timeInterval: show.length, sinceDate: show.startDate))
        template.body1TextProvider = CLKSimpleTextProvider(text: show.name, shortText: show.shortName)
        template.body2TextProvider = CLKSimpleTextProvider(text: show.genre, shortText: nil)
        
        let entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.25, sinceDate: show.startDate), complicationTemplate: template)
        handler(entry)
    }
*/
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
 //   func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
 //       handler(nil)
 //   }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        
        var entries: [CLKComplicationTimelineEntry] = []
        
        for show in shows
        {
            if entries.count < limit && show.startDate.timeIntervalSinceDate(date) > 0
            {
                let template = CLKComplicationTemplateModularLargeStandardBody()
                
                template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.startDate, endDate: NSDate(timeInterval: show.length, sinceDate: show.startDate))
                template.body1TextProvider = CLKSimpleTextProvider(text: show.name, shortText: show.shortName)
                template.body2TextProvider = CLKSimpleTextProvider(text: show.genre, shortText: nil)
                
                let entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.25, sinceDate: show.startDate), complicationTemplate: template)
                entries.append(entry)
            }
        }
        
        handler(entries)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
 /*
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate: NSDate(timeIntervalSinceNow: 60 * 60 * 1.5))
        template.body1TextProvider = CLKSimpleTextProvider(text: "Show Name", shortText: "Name")
        template.body2TextProvider = CLKSimpleTextProvider(text: "Show Genre", shortText: nil)
        
        handler(template)
    }
    
*/

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
        
        print("w292 we here complication.family: \(complication.family)")

        
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
           // let modularSmallTemplate =  CLKComplicationTemplateModularSmallRingText()
          //  modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: "D_%")

           // let modularSmallTemplate =  CLKComplicationTemplateModularSmallSimpleImage()
          /*
            //Set images for both watch sizes :)
            let thisDevice = WKInterfaceDevice.currentDevice()
            let rect:CGRect =  thisDevice.screenBounds
            if (rect.size.height == 195.0) {
                print("w323 we here rect.size.height: \(rect.size.height)")
                // Apple Watch 42mm
                image = UIImage(named: "micWithAlphaD-58px")!
               // image = UIImage(named: "u0iNw")!
                modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: image)
            } else if (rect.size.height == 170.0){
                // Apple Watch 38mm
                image = UIImage(named: "micWithAlphaD-52px")!//.imageWithRenderingMode(.AlwaysTemplate)
                modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: image)
            }
       */
            
            
            
            
            //     modularSmallTemplate.imageProvider = CLKImageProvide(onePieceImage: UIImage(named: "app_icon")!)
            //    modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "micWithAlphaD-58px")!)
            
           //// modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: image)
            
            let modularSmallTemplate =  CLKComplicationTemplateModularSmallSimpleImage()
            image = UIImage(named: "micWithAlphaD-58px")!
            let imageName = UIImage(named: "micWithAlphaD-58px")!
            
//modularSmallTemplate.imageProvider = CLKImageProvider.init(onePieceImage: imageName, twoPieceImageBackground: nil, twoPieceImageForeground: nil)
            //image = UIImage(named: "u0iNw")!
            modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: imageName)
            template = modularSmallTemplate

            
          //  let imager = CLKImageProvider(onePieceImage: image)

/*
            let modularSmallTemplate =  CLKComplicationTemplateModularSmallRingText()
            modularSmallTemplate.textProvider = CLKSimpleTextProvider(text: "R")
            modularSmallTemplate.fillFraction = 0.50
            modularSmallTemplate.ringStyle = CLKComplicationRingStyle.Closed
            
            template = modularSmallTemplate
*/

            
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

