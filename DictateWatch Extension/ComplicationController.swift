//
//  ComplicationController.swift
//  ComplicationTester WatchKit Extension
//
//  Created by Mike Derr on 6/20/16.
//  Copyright © 2016 Mike Derr. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
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
            let body1Text = "Meeting with Clients"
            //let body2Text = "Ahuska Park"
            let body2Text =  "             " + timeUntil

 
           // modularLargeTemplate.headerImageProvider = CLKImageProvider(onePieceImage: defaultSticker)
            modularLargeTemplate.headerTextProvider = CLKSimpleTextProvider(text: headerText)
            modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: body1Text)
            modularLargeTemplate.body2TextProvider = CLKSimpleTextProvider(text: body2Text)
            
            let brightYellow = UIColor(red: 255, green: 255, blue: 0, alpha: 1)
            
         //   modularLargeTemplate.body2TextProvider = CLKTextProvider.text

            modularLargeTemplate.tintColor = UIColor.yellowColor()
            
            print("w91 headerText: \(headerText)")
            print("w92 body1Text: \(body1Text)")
            print("w93 body2Text: \(body2Text)")

            template = modularLargeTemplate
            handler(modularLargeTemplate)
            
        case .ModularSmall:
            let modularSmallTemplate =  CLKComplicationTemplateModularSmallSimpleImage()
            let imageName = UIImage(named: "micWithAlphaD")!
            //let imageName = UIImage(named: "u0iNw")!
            
            modularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: imageName)
            template = modularSmallTemplate
            
            handler(modularSmallTemplate)

         /*
            
        case .CircularSmall:
            let circularSmallTemplate = CLKComplicationTemplateCircularSmallRingImage()
            circularSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "micWithAlphaD")!)
            template = circularSmallTemplate
                       
        case .UtilitarianSmall:
            let utilitarianSmallTemplate = CLKComplicationTemplateUtilitarianSmallRingImage()
            utilitarianSmallTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "micWithAlphaD")!)
            template = utilitarianSmallTemplate
 
        case .UtilitarianLarge:
            let headerTextTime = "3 PM-4:15"
            let timeUntil = "Now"
            let headerText = headerTextTime + " " + timeUntil
            
            let utilitarianLargeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
            utilitarianLargeTemplate.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "micWithAlphaD")!)
            utilitarianLargeTemplate.textProvider = CLKSimpleTextProvider(text: headerText)
            template = utilitarianLargeTemplate
         */
        
        default:
            template = nil
        
        handler (template)
        }
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
    
}
