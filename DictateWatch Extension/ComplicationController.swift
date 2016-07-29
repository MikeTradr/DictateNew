//
//  ComplicationController.swift
//  ComplicationTester WatchKit Extension
//
//  Created by Mike Derr on 6/20/16.
//  Copyright © 2016 Mike Derr. All rights reserved.
//
// sample started from here:  http://www.techotopia.com/index.php/A_watchOS_2_Complication_Tutorial
//
// look here for cleaner code??? http://macoscope.com/blog/the-not-so-complicated-complications/
//

import ClockKit
import EventKit

//---multipliers to convert to seconds---
let HOUR: NSTimeInterval = 60 * 60
let MINUTE: NSTimeInterval = 60

var allEvents: [EKEvent]    = []
var eventID:String          = ""
var timeUntil:String        = ""
let imageDMic = UIImage(named: "micWithAlphaD-58px")!

let dateFormatter = NSDateFormatter()


let timeTable = [7, 18, 29, 32, 38, 49, 59]




class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let timeLineText = ["Show Apartment", "Meeting with Paul", "Pale Ale at Booth 232", "English Bitter at Booth 327", "Dinner", "Go to the Gym"]
    
   // let timeLineText2 = ["     NOW", "     in 9 min", "     in 21 min", "     in 1hr 11m"]
    
   // let timeUntil = ["* NOW *", "in 9m", "in 21m", "in 1hr 11m"]
    var timeUntilArray = ["  ** NOW **", "   in 9 min", "   in 21 mim", "in 1hr 11 min", "   in 2 hrs", "in 3hr 5 min"]
    
    
    func fetchEvents() {
        let startDate =  NSDate()
        let calendar = NSCalendar.currentCalendar()
        let endDate: NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 2, toDate: startDate, options: [])!
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        //THIS NEEDED?? TODO FIX
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Event, completion: { (granted) -> Void in
            
            if granted{
                print("w51 Events granted: \(granted)")
            }
        })
        
        //FIXME:1
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            allEvents = events
        })
        print("w56 allEvents: \(allEvents)")
    }


    
 
    
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
            
            fetchEvents()
            
            let dateFormatterA = NSDateFormatter()
            dateFormatterA.dateFormat = "h:mm a"
            
           //let endTimeA = dateFormatter.stringFromDate(item.endDate)
           // let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            
            let endDate1 = NSDate()
            let endDate = endDate1.dateByAddingTimeInterval(10.0 * 60.0)    //add 10 minutes to test
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm"
            let endTime = dateFormatter.stringFromDate(endDate)
            
            var endTimeDash = "- \(endTime)"
            
            var timeString = dateFormatterA.stringFromDate(NSDate())
            timeString = timeString.stringByReplacingOccurrencesOfString(":00", withString: "")

            //timeString = "\(timeString) \(timeUntil[0])"
            timeString = "\(timeString) \(endTimeDash)"
            
            //call func, createTimeLineEntry, to display data...
          //  let entry = createTimeLineEntry(timeString, bodyText: timeLineText[0], date: NSDate())
            let entry = createTimeLineEntry2(timeString, body1Text: timeLineText[0], body2Text: timeUntilArray[0], date: NSDate())

            
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        
        var timeLineEntryArray = [CLKComplicationTimelineEntry]()
        
        let headerTextTime = "12 PM-12:45"
        // let timeUntil = "in 15 min"
        timeUntil = "in 1hr, 36 min"
        let headerText = headerTextTime  //+ "  " + timeUntil
        let body1Text = "Lunch Meting"
        //let body2Text = "Ahuska Park"
        let body2Text =  "             " + timeUntil
        
        let priorDate = NSDate().dateByAddingTimeInterval(-10 * 60)
        print("w112 NSDate(): \(NSDate())")
        print("w112 priorDate: \(priorDate)")

        let entry = createTimeLineEntry2(headerText, body1Text: body1Text, body2Text: body2Text, date: priorDate)
        
        timeLineEntryArray.append(entry)
        
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        
        var timeLineEntryArray = [CLKComplicationTimelineEntry]()
        //var nextDate = NSDate(timeIntervalSinceNow: 1 * 60 * 60)    //every hour
        var nextDate = NSDate(timeIntervalSinceNow: 10 * 60)    //every 10 minutes
        
         for (index, title) in allEvents.enumerate() {
            print("---------------------------------------------------")
            print("w40 index, title: \(index), \(title)")
            
            let item = allEvents[index]
            
            dateFormatter.dateFormat = "h:mm a"
            
            let startTimeA = dateFormatter.stringFromDate(item.startDate)
            var startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            NSLog("%@ w137", startTime)
            
            dateFormatter.dateFormat = "h:mm"
            
            let endTimeA = dateFormatter.stringFromDate(item.endDate)
            let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            
            var endTimeDash = "- \(endTime)"
            
            timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
            
            let startTimeItem = item.startDate
            let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
            //print("w187 timeUntilStart: \(timeUntilStart)")
            
            let endTimeItem = item.endDate
            let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
            //print("w192 timeUntilEnd: \(timeUntilEnd)")
            
            if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {
                timeUntil = "Now"
                let neonRed = UIColor(red: 255, green: 51, blue: 0, alpha: 1)
                let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
                
                //let swiftColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
          //      row.labelTimeUntil.setTextColor(brightYellow)
                //row.labelTimeUntil.setTextColor(UIColor.yellowColor())
                
                // works
                let headlineFont =
                    UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                
                let fontAttribute = [NSFontAttributeName: headlineFont]
                
                let attributedString = NSAttributedString(string: "Now  ",
                                                          attributes: fontAttribute)
                
              //  row.labelTimeUntil.setAttributedText(attributedString)
   
            }   //end timeUntilstart <== 0
            
            
            let entry = createTimeLineEntry2(timeString, body1Text: timeLineText[index], body2Text: timeUntilArray[index], date: nextDate)
            
            print("w106 entry: \(entry)")
            
            timeLineEntryArray.append(entry)
            print("w109 timeLineEntryArray: \(timeLineEntryArray)")
            
            nextDate = nextDate.dateByAddingTimeInterval(10 * 60)   //every 10 minutes hard coded
            
            
        } //end for loop...
        
        
        
        
        

        for index in 1..<timeLineText.count {
            
            print("w95 index: \(index)")
            
            let dateFormatterA = NSDateFormatter()
            dateFormatterA.dateFormat = "h:mm a"
            
            //let endTimeA = dateFormatter.stringFromDate(item.endDate)
            // let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
            
            let endDate1 = nextDate
            let endDate = endDate1.dateByAddingTimeInterval(10.0 * 60.0)    //add 10 minutes to test
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm"
            let endTime = dateFormatter.stringFromDate(endDate)
            
            var endTimeDash = "- \(endTime)"
            
            var timeString = dateFormatterA.stringFromDate(nextDate)
            timeString = timeString.stringByReplacingOccurrencesOfString(":00", withString: "")

            //timeString = "\(timeString) \(timeUntil[0])"
            timeString = "\(timeString) \(endTimeDash)"
            
           // let dateFormatter = NSDateFormatter()
           // dateFormatter.dateFormat = "h:mm a"
            
          //  var timeString = dateFormatter.stringFromDate(nextDate)
        //  timeString = "\(timeString) \(timeUntil[index])"
            
           // let entry = createTimeLineEntry(timeString, bodyText: timeLineText[index], date: nextDate)
            //let entry = createTimeLineEntry(timeString, bodyText: timeLineText[index], date: nextDate)
            let entry = createTimeLineEntry2(timeString, body1Text: timeLineText[index], body2Text: timeUntilArray[index], date: nextDate)
            
            print("w106 entry: \(entry)")

            timeLineEntryArray.append(entry)
            print("w109 timeLineEntryArray: \(timeLineEntryArray)")
            
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
                
                modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: imageDMic)
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
        let myImage = imageDMic
        template.headerImageProvider = CLKImageProvider(onePieceImage: myImage)
        template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
        template.body1TextProvider = CLKSimpleTextProvider(text: bodyText)
        template.body1TextProvider.tintColor = UIColor.yellowColor()

        
        let entry = CLKComplicationTimelineEntry(date: date,
                                                 complicationTemplate: template)
        
        return(entry)
    }
    
    func createTimeLineEntry2(headerText: String, body1Text: String, body2Text: String, date: NSDate) -> CLKComplicationTimelineEntry {
        
        let template = CLKComplicationTemplateModularLargeStandardBody()
        let myImage = imageDMic
        
        let timeUntilCentered = "       \(body2Text)"
        
        template.headerImageProvider = CLKImageProvider(onePieceImage: myImage)
        template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
        template.body1TextProvider = CLKSimpleTextProvider(text: body1Text)
        template.body2TextProvider = CLKSimpleTextProvider(text: timeUntilCentered)
        template.body2TextProvider!.tintColor = UIColor.yellowColor()
        
      /*
        print("w269 headerText: \(template.headerTextProvider)")
        print("w269 body1Text: \(template.body1TextProvider)")
        print("w269 body2Text: \(template.body2TextProvider)")
       */
        
        let entry = CLKComplicationTimelineEntry(date: date,
                                                 complicationTemplate: template)
        
        return(entry)
    }
    
    func getNextBusArrivalDate(fromDate date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Minute, .Hour], fromDate: date)
        if let nextBusArrivalMinute = timeTable.filter({ return $0 > components.minute }).first {
            return calendar.dateBySettingHour(components.hour, minute: nextBusArrivalMinute, second: 0, ofDate: date, options: .MatchFirst)!
        } else {
            let date = calendar.dateBySettingHour(components.hour, minute: timeTable.first!, second: 0, ofDate: date, options: .MatchFirst)!
            return date.dateByAddingTimeInterval(NSTimeInterval(3600))
        } 
    }
    
    
    func getLastBusArrivalDate(fromDate date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Minute, .Hour], fromDate: date)
        if let lastBusArrivalMinute = timeTable.reverse().filter({ return $0 < components.minute }).first {
            return calendar.dateBySettingHour(components.hour, minute: lastBusArrivalMinute, second: 0, ofDate: date, options: .MatchFirst)!
        } else {
            let date = calendar.dateBySettingHour(components.hour, minute: timeTable.last!, second: 0, ofDate: date, options: .MatchFirst)!
            return date.dateByAddingTimeInterval(NSTimeInterval(-3600))
        } 
    }
    
 /*
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        var entries: [CLKComplicationTimelineEntry] = []
        var prevDate = date
        for _ in 0..<limit {
            prevDate = getLastBusArrivalDate(fromDate: prevDate)
            let entry = timelineEntryForDate(prevDate)
            entries.append(entry)
        }
        handler(entries)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        var entries: [CLKComplicationTimelineEntry] = []
        var nextDate = date
        for _ in 0..<limit {
            nextDate = getNextBusArrivalDate(fromDate: nextDate)
            let entry = timelineEntryForDate(nextDate)
            entries.append(entry)
        }
        handler(entries)
    }
*/
    
    
}
