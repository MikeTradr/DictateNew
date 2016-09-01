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
let HOUR: NSTimeInterval    = 60 * 60
let MINUTE: NSTimeInterval  = 60

var allEvents :[EKEvent]    = []
var eventID :String         = ""
var timeUntil :String       = ""

let imageDMic :UIImage      = UIImage(named: "micWithAlphaD")!
let imageMicSmall           = UIImage(named: "mic38px")!

let image :UIImage  = imageDMic
let imageProvider   = CLKImageProvider(onePieceImage: image)

var startDate       = NSDate()
var endDate         = NSDate()
var startDateTL     = NSDate()
var endDateTL       = NSDate()

let dateFormatter   = NSDateFormatter()

var timeLineEntryArray = [CLKComplicationTimelineEntry]()

//var timeString :String  = ""

//let dYellow = UIColor(red: 255/255, green: 255/255, blue: 51/255, alpha: 1)
let dYellow = UIColor(red: 244/255, green: 250/255, blue: 88/255, alpha: 1)

//let brightYellow = UIColor(red: 255/255, green: 255/255, blue: 0, alpha: 1)

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    class var sharedInstance : ComplicationController {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ComplicationController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ComplicationController()
        }
        return Static.instance!
    }
    
    func requestedUpdateDidBegin() {
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications!.forEach { server.reloadTimelineForComplication($0) }
    }
    
    func fetchEvents() {
        var startDate =  NSDate()
        let calendar = NSCalendar.currentCalendar()
        
        let tomorrow :NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: NSDate(), options: [])!
        
        let endDate = NSCalendar.currentCalendar().startOfDayForDate(tomorrow)
        
        startDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: startDate, options: [])!   //get events back 1 day for timeline ok?
        
        print("w46 startDate: \(startDate)")
        print("w46 endDate: \(endDate)")
        
        EventManager.sharedInstance.getAccessToEventStoreForType(EKEntityType.Event, completion: { (granted) -> Void in
            
            if granted{
                print("w51 Events granted: \(granted)")
            }
        })
        
        EventManager.sharedInstance.fetchEventsFrom(startDate, endDate: endDate, completion: { (events) -> Void in
            allEvents = events
        })
        
        print("w88 allEvents.count: \(allEvents.count)")
        print("w89 allEvents: \(allEvents)")
    }
    
    
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
        
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -2, toDate: startDate, options: [])!  //showed events today from prior day for some reason
        // let date = NSDate()
        handler(date)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
        
        let calendar = NSCalendar.currentCalendar()
        
        let endDate = calendar.dateByAddingUnit(
            .Day,
            value: 2,
            toDate: NSDate(),
            options: []
        )
        
        handler(endDate)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    // ===== Current Entry =======================================
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        switch complication.family {
        case .ModularSmall:
            
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = imageProvider
            template.imageProvider.tintColor = dYellow
            
            let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
            handler(timelineEntry)
            
        case .ModularLarge:
            //var timeLineEntryArray = [CLKComplicationTimelineEntry]()
            
            fetchEvents()
            
            print("w151 we here in CurrentTimeLine Entry")
            print("w152 allEvents.count \(allEvents.count)")
            
            if allEvents.count > 0 {
                
                for (index, title) in allEvents.enumerate() {
                    print("---------------------------------------------------")
                    print("w159 index, title: \(index), \(title)")
                    
                    let item = allEvents[index]
                    var priorIndex = 0
                    
                    startDate = item.startDate
                    endDate = item.endDate
                    
                    dateFormatter.dateFormat = "h:mm a"
                    
                    let startTimeA = dateFormatter.stringFromDate(item.startDate)
                    let startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                    // NSLog("%@ w137", startTime)
                    
                    dateFormatter.dateFormat = "h:mm"
                    
                    let endTimeA = dateFormatter.stringFromDate(item.endDate)
                    let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                    
                    var endTimeDash = "- \(endTime)"
                    
                    if item.startDate == item.endDate {     //for same start & end time event
                        endTimeDash = ""
                    }
                    
                    timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
                    
                    let startTimeItem = item.startDate
                    let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
                    //print("w187 timeUntilStart: \(timeUntilStart)")
                    
                    let endTimeItem = item.endDate
                    let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
                    //print("w192 timeUntilEnd: \(timeUntilEnd)")
                    
                    if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {
                        timeUntil = "•NOW•"
                    }   //end timeUntilstart <== 0
                    
                    timeString = "\(startTime) \(endTimeDash)"
                    
                    let title = item.title
                    print("w197 item.title: \(item.title)")
                    
                    if index >= 1 {
                        priorIndex = index-1
                        
                        print("w202 index: \(index)")
                        print("w202 priorIndex: \(priorIndex)")
                        print("w202 startDate: \(startDate)")
                        print("w202 endDate: \(endDate)")
                        
                        let endDatePrior = allEvents[priorIndex].endDate
                        print("w202 endDatePrior: \(endDatePrior)")
                        
                        endDateTL = allEvents[priorIndex].endDate   //trying to get endDate of prior event for timeline
                        print("w202 endDateTL: \(endDateTL)")
                        
                        endDateTL = endDateTL.dateByAddingTimeInterval(1 * MINUTE)  //add 1 minute
                        print("w218 endDateTL: \(endDateTL)")
                        
                    } else {
                        endDateTL = startDate
                    }
                    
                    let entry = createTimeLineEntry2(timeString, body1Text: title, body2Text: timeUntil, date: endDateTL, startDate: startDate)
                    
                    print("w228 entry: \(entry)")
                    
                    handler(entry)
                    
                } //end for loop...
                
            } else if allEvents.count == 0 { //end If allEvents.count > 0 we Have events
                
                print("w238 allEvents.count = \(allEvents.count)")
                timeString = "Dictate™ 😀"
                let title = "No events today"
                
                let entry = createTimeLineEntryEnd(timeString, body1Text: title, body2Text: timeUntil, date: startDateTL, startDate: startDate)
                
                handler(entry)
                
            } else {
                handler(nil)
            }
            
        default:
            handler(nil)
            
        }   //end Switch
        
    }
    
    // ===== beforeDate =======================================
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        
        var timeLineEntryArray = [CLKComplicationTimelineEntry]()
        
        switch complication.family {
        case .ModularLarge:
            print("w257 we here .ModularLarge")
            
            if allEvents.count > 0 {
                
                for (index, title) in allEvents.enumerate() {
                    print("---------------------------------------------------")
                    print("w238 index, title: \(index), \(title)")
                    
                    let item = allEvents[index]
                    var priorIndex = 0
                    
                    startDate = item.startDate
                    endDate = item.endDate
                    
                    dateFormatter.dateFormat = "h:mm a"
                    
                    let startTimeA = dateFormatter.stringFromDate(item.startDate)
                    let startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                    
                    dateFormatter.dateFormat = "h:mm"
                    
                    let endTimeA = dateFormatter.stringFromDate(item.endDate)
                    let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                    
                    var endTimeDash = "- \(endTime)"
                    
                    if item.startDate == item.endDate {     //for same start & end time event
                        endTimeDash = ""
                    }
                    
                    timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
                    
                    let startTimeItem = item.startDate
                    let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
                    
                    let endTimeItem = item.endDate
                    let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
                    
                    if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {
                        timeUntil = "•NOW•"
                    }   //end timeUntilstart <== 0
                    
                    timeString = "\(startTime) \(endTimeDash)"
                    
                    let title = item.title
                    print("w276 item.title: \(item.title)")
                    
                    if index >= 1 {
                        priorIndex = index-1
                        
                        print("w276 index: \(index)")
                        print("w276 priorIndex: \(priorIndex)")
                        print("w276 startDate: \(startDate)")
                        print("w276 endDate: \(endDate)")
                        
                        let endDatePrior = allEvents[priorIndex].endDate
                        print("w276 endDatePrior: \(endDatePrior)")
                        
                        startDateTL = allEvents[priorIndex].endDate   //trying to get endDate of prior event for timeline
                        print("w276 startDateTL: \(startDateTL)")
                        
                        startDateTL = startDateTL.dateByAddingTimeInterval(1 * MINUTE)  //add 1 minute
                        print("w297 startDateTL: \(startDateTL)")
                        
                    } else {
                        startDateTL = startDate
                    }
                    
                    let entry = createTimeLineEntry2(timeString, body1Text: title, body2Text: timeUntil, date: startDateTL, startDate: startDate)
                    print("w307 entry: \(entry)")
                    
                    timeLineEntryArray.append(entry)
                    print("w310 timeLineEntryArray: \(timeLineEntryArray)")
                    
                    if index == allEvents.count-1 {
                        print("w344 we here entry")
                        
                        timeString = "Dictate™ 😀"
                        let title = "No events today HE HE"
                        
                        startDateTL = allEvents[index].endDate
                        startDateTL = startDateTL.dateByAddingTimeInterval(1 * MINUTE)  //add 1 minute
                        print("w351 startDateTL \(startDateTL)")
                        
                        let entry = createTimeLineEntryEnd(timeString, body1Text: title, body2Text: timeUntil, date: startDateTL, startDate: startDate)
                        
                        timeLineEntryArray.append(entry)
                    }
                    
                } //end for loop...
                
                handler(timeLineEntryArray)
                
            } else { //end If allEvents.count > 0 we Have events
                
                handler(nil)
            }
            
        case .ModularSmall:
            
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = imageProvider
            template.imageProvider.tintColor = dYellow
            
            //   let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
            //  handler(timelineEntry)
            
        default:
            handler(nil)
        }   //end switch
    }
    
    // ===== afterDate =======================================
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        
        var timeLineEntryArray = [CLKComplicationTimelineEntry]()
        
        switch complication.family {
        case .ModularLarge:
            print("w374 we here .ModularLarge")
            
            if allEvents.count > 0 {
                
                for (index, title) in allEvents.enumerate() {
                    print("---------------------------------------------------")
                    print("w324 index, title: \(index), \(title)")
                    
                    let item = allEvents[index]
                    var priorIndex = 0
                    
                    startDate = item.startDate
                    endDate = item.endDate
                    
                    dateFormatter.dateFormat = "h:mm a"
                    
                    let startTimeA = dateFormatter.stringFromDate(item.startDate)
                    let startTime = startTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                    // NSLog("%@ w137", startTime)
                    
                    dateFormatter.dateFormat = "h:mm"
                    
                    let endTimeA = dateFormatter.stringFromDate(item.endDate)
                    let endTime = endTimeA.stringByReplacingOccurrencesOfString(":00", withString: "")
                    var endTimeDash = "- \(endTime)"
                    
                    if item.startDate == item.endDate {     //for same start & end time event
                        endTimeDash = ""
                    }
                    
                    timeUntil = TimeManger.sharedInstance.timeInterval(item.startDate)
                    
                    let startTimeItem = item.startDate
                    let timeUntilStart = startTimeItem.timeIntervalSinceDate(NSDate())
                    let endTimeItem = item.endDate
                    let timeUntilEnd = endTimeItem.timeIntervalSinceDate(NSDate())
                    
                    if ((timeUntilStart <= 0) && (timeUntilEnd >= 0)) {
                        timeUntil = "•NOW•"
                    }   //end timeUntilstart <== 0
                    
                    timeString = "\(startTime) \(endTimeDash)"
                    
                    let title = item.title
                    print("w362 item.title: \(item.title)")
                    
                    if index >= 1 {
                        priorIndex = index-1
                        
                        print("w367 afterDate =================================")
                        print("w367 index: \(index)")
                        print("w367 priorIndex: \(priorIndex)")
                        print("w367 startDate: \(startDate)")
                        print("w367 endDate: \(endDate)")
                        
                        let endDatePrior = allEvents[priorIndex].endDate
                        print("w367 endDatePrior: \(endDatePrior)")
                        
                        startDateTL = allEvents[priorIndex].endDate   //trying to get endDate of prior event for timeline
                        print("w367 startDateTL: \(startDateTL)")
                        startDateTL = startDateTL.dateByAddingTimeInterval(1 * MINUTE)  //add 1 minute
                        print("w383 startDateTL: \(startDateTL)")
                        print("w383 afterDate =================================")
                        
                    } else {
                        startDateTL = startDate
                    }
                    
                    let entry = createTimeLineEntry2(timeString, body1Text: title, body2Text: timeUntil, date: startDateTL, startDate: startDate)
                    
                    print("w389 entry: \(entry)")
                    
                    timeLineEntryArray.append(entry)
                    print("w392 timeLineEntryArray: \(timeLineEntryArray)")
                    
                    print("w430 allEvents.last \(allEvents.last)")
                    print("w430 index \(index)")
                    print("w430 allEvents.count \(allEvents.count)")
                    
                    if index == allEvents.count-1 { //get endDate for last entry of Timeline for day!
                        print("w435 we here entry")
                        
                        timeString = "Dictate™ 😀"
                        let title = "No more events today"
                        
                        var endDateTL = allEvents[index].endDate
                        endDateTL = endDateTL.dateByAddingTimeInterval(1 * MINUTE)  //add 1 minute
                        print("w441 endDateTL \(endDateTL)")
                        
                        let entry = createTimeLineEntryEnd(timeString, body1Text: title, body2Text: timeUntil, date: endDateTL, startDate: startDate)
                        
                        timeLineEntryArray.append(entry)
                    }
                    
                } //end for loop...
                
                handler(timeLineEntryArray)
                
            } else { //end If allEvents.count > 0 we Have events
                
                handler(nil)
            }
            
        case .ModularSmall:
            
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = imageProvider
            template.imageProvider.tintColor = dYellow
            
            //   let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
            //  handler(timelineEntry)
            
        default:
            handler(nil)
        }   //end switch
    }
    
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        
        let calendar = NSCalendar.currentCalendar()
        let nextUpdateDate :NSDate = calendar.dateByAddingUnit(NSCalendarUnit.Hour, value: 1, toDate: NSDate(), options: [])!
        
        handler(nextUpdateDate)
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
    /*
     func createTimeLineEntry(headerText: String, bodyText: String, date: NSDate) -> CLKComplicationTimelineEntry {
     
     let template = CLKComplicationTemplateModularLargeStandardBody()
     let myImage = imageDMic
     template.headerImageProvider = CLKImageProvider(onePieceImage: imageMicSmall)
     template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
     template.body1TextProvider = CLKSimpleTextProvider(text: bodyText)
     template.body1TextProvider.tintColor = UIColor.yellowColor()
     
     
     let entry = CLKComplicationTimelineEntry(date: date,
     complicationTemplate: template)
     
     return(entry)
     }
     */
    
    
    func createTimeLineEntry2(headerText: String, body1Text: String, body2Text: String, date: NSDate, startDate: NSDate) -> CLKComplicationTimelineEntry {
        
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        print("w512 date: \(date)")
        print("w512 date: \(startDate)")
        print("w512 headerText: \(headerText)")
        print("w512 body1Text: \(body1Text)")
        print("w512 body2Text: \(body2Text)")
        
        template.headerImageProvider = CLKImageProvider(onePieceImage: imageMicSmall)
        template.headerImageProvider!.tintColor = UIColor.yellowColor()
        template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
        template.headerTextProvider.tintColor = UIColor.yellowColor()
        template.body1TextProvider = CLKSimpleTextProvider(text: body1Text)
        
        let units : NSCalendarUnit = [.Hour, .Minute]
        let style : CLKRelativeDateStyle = .Natural     //styles: .Natural .Offset  .Timer
        let textProvider = CLKRelativeDateTextProvider(date: startDate,
                                                       style: style,
                                                       units: units) //NSCalendarUnit.Hour.union(.Minute))
        
        template.body2TextProvider = textProvider
        //template.body2TextProvider!.tintColor = UIColor.yellowColor()   //does not work!
        
        let entry = CLKComplicationTimelineEntry(date: date,
                                                 complicationTemplate: template)
        return(entry)
    }
    
    
    func createTimeLineEntryEnd(headerText: String, body1Text: String, body2Text: String, date: NSDate, startDate: NSDate) -> CLKComplicationTimelineEntry {
        
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        print("w512 date: \(date)")
        print("w512 headerText: \(headerText)")
        print("w512 body1Text: \(body1Text)")
        print("w512 body2Text: \(body2Text)")
        
        template.headerImageProvider = CLKImageProvider(onePieceImage: imageMicSmall)
        template.headerImageProvider!.tintColor = UIColor.yellowColor()
        template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
        template.headerTextProvider.tintColor = UIColor.yellowColor()
        template.body1TextProvider = CLKSimpleTextProvider(text: body1Text)
        
        let entry = CLKComplicationTimelineEntry(date: date,
                                                 complicationTemplate: template)
        return(entry)
    }
    
    
    
    // MARK: - Placeholder Templates
    
    // ===== Placeholder =======================================
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        print("w63 we here complication.family: \(complication.family)")
        
        var template: CLKComplicationTemplate?
        
        switch complication.family {
        case .ModularLarge:
            
            print("w75 we here .ModularLarge")
            
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            let headerText  = "Dictate™ 😀"
            let body1Text   = "Getting Events..."
            let body2Text   =  ""
            
            template.headerImageProvider = CLKImageProvider(onePieceImage: imageMicSmall)
            template.headerImageProvider!.tintColor = UIColor.yellowColor()
            template.headerTextProvider = CLKSimpleTextProvider(text: headerText)
            template.headerTextProvider.tintColor = UIColor.yellowColor()
            template.body1TextProvider = CLKSimpleTextProvider(text: body1Text)
            template.body2TextProvider = CLKSimpleTextProvider(text: body2Text)
            
            //template.body2TextProvider!.tintColor = UIColor.yellowColor()
            
            handler(template)
            
        case .ModularSmall:
            template = CLKComplicationTemplateModularSmallSimpleImage()
            if let template = template as? CLKComplicationTemplateModularSmallSimpleImage {
                template.imageProvider = CLKImageProvider(onePieceImage: imageDMic)
                template.imageProvider.tintColor = dYellow
            }
            
            
            
        case .CircularSmall:
            let template = CLKComplicationTemplateCircularSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: imageDMic)
            
        case .UtilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingImage()
            template.imageProvider = CLKImageProvider(onePieceImage: imageDMic)
            
        case .UtilitarianLarge:
            let headerText      = "Dictate™ 😀"
            //let body1Text     = "Getting Events..."
            //let body2Text     =  ""
            
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.imageProvider = CLKImageProvider(onePieceImage: imageDMic)
            template.textProvider = CLKSimpleTextProvider(text: headerText)
            
        default:
            template = nil
        }
        handler (template)
    }
    
}
