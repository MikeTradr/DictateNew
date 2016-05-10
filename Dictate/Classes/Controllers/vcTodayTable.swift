//
//  vcTodayTable.swift
//  WatchInput
//
//  Created by Mike Derr on 6/19/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import AVFoundation

/*
class CustomTableViewCell : UITableViewCell {

@IBOutlet var titleLabel: UILabel!
@IBOutlet weak var startLabel: UILabel!
@IBOutlet weak var endLabel: UILabel!
@IBOutlet weak var calendarLabel: UILabel!
@IBOutlet weak var barLabel: UILabel!

//@IBOutlet var backgroundImage: UIImageView!

func loadItem(#title: String) {
// backgroundImage.image = UIImage(named: image)
titleLabel.text = title
}
}
*/


class vcTodayTable: UITableViewController {
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet var tableViewToday: UITableView!
    
    var numberOfNewItems:Int    = 0
    var startDT:NSDate          = NSDate()
    var endDT:NSDate            = NSDate()
    var today:NSDate            = NSDate()
    var events:NSMutableArray   = []
    
    
    // from http://stackoverflow.com/questions/24722597/fetch-events-from-ekeventstore-and-show-in-tableview-in-swift-ios8
    
    func fetchEvents() -> NSMutableArray {
        var eventStore : EKEventStore = EKEventStore()
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent' TODO use for Reminders? Mike
        
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            granted, error in
            if (granted) && (error == nil) {
                print("granted: \(granted)")
                print("error:  \(error)")
                
                var event:EKEvent = EKEvent(eventStore: eventStore)
                /*
                event.title = "Test Title"
                event.startDate = NSDate()
                event.endDate = NSDate()
                event.notes = "This is a note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                println("Saved Event")
                */
            }
        })
        
        
        // This lists every reminder
        var predicate = eventStore.predicateForRemindersInCalendars([])
        eventStore.fetchRemindersMatchingPredicate(predicate) { reminders in
            for reminder in reminders! {
                print("•p73: reminder title: \(reminder.title)")
                
                //TODO Mike get reminders going :)
                
            }
        }
        
        // What about Calendar entries?
        
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let startDate = cal!.startOfDayForDate(date)
        
        var endDate = startDate.dateByAddingTimeInterval(60*60*24)
        var predicate2 = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
        
        print("startDate:\(startDate) endDate:\(endDate)")
        var eV = eventStore.eventsMatchingPredicate(predicate2) as [EKEvent]!
        
        //println("p68 eV: \(eV)" )         // prints Event details! good.
        
        if eV != nil {
            
            if eV.count == 0 {
                print("No events could be found")
            } else {
                
                events = NSMutableArray(array: eventStore.eventsMatchingPredicate(predicate2))
                //println("p88 events  \(events)" )
                
                for i in eV {
                    print("p66 Title  \(i.title)" )
                    print("p67 stareDate: \(i.startDate)" )
                    print("p68 endDate: \(i.endDate)" )
                    
                    
                    // Access list of available sources from the Event Store
                    let sourcesInEventStore = eventStore.sources as! [EKSource]
                    
          // http://www.andrewcbancroft.com/2015/06/17/creating-calendars-with-event-kit-and-swift/
                    
                    
                    if i.title == "Test Title" {
                        print("YES" )
                        // Uncomment if you want to delete
                        //eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                    }
                }
            }
        }
        
        return events
            
            
    }
    
    func playSound(sound: NSURL){
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch var error1 as NSError {
            error = error1
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var viewController = self
        
        // TODO Mike move this to EventCode class???
        events = fetchEvents()
        
        //Register custom cell
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableViewToday.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        //Set the badger number to display
        // TODO add this to the app start up, does not show when app loads.
        numberOfNewItems = events.count
        if (self.numberOfNewItems == 0) {
            self.tabBarItem.badgeValue = nil;
        } else {
            self.tabBarItem.badgeValue = String(numberOfNewItems)
        }
*/        
    }
    
    override func viewWillAppear(animated: Bool) {
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!)
        //General.playSound(alertSound3!)
        
        playSound(alertSound3)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var viewController = self
        
        print("p182 vcToday viewController: \(viewController)" )

        
        // TODO Mike move this to EventCode class???
        events = fetchEvents()
        
        //Register custom cell
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableViewToday.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        //Set the bader number to display
        // TODO add this to the app start up, does not show when app loads.
        numberOfNewItems = events.count
        if (self.numberOfNewItems == 0) {
            self.tabBarItem.badgeValue = nil;
        } else {
            self.tabBarItem.badgeValue = String(numberOfNewItems)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let object: EKEvent = events[indexPath.row] as! EKEvent
        
        var cell:TableCell = tableView.dequeueReusableCellWithIdentifier("customCell") as! TableCell
        // cell.selectionStyle = .None
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let eventStartDTString = dateFormatter.stringFromDate(object.startDate)
        let eventEndDTString = dateFormatter.stringFromDate(object.endDate)
        
        cell.labelTitle.text = object.title
        
        //Anil 1. we need to pull calendar Name somehow here...
        //Anil 2. we need to pull set label for calendar color:  labelVertical
        
        //cell.calendar = eventStore.eventCalendar
       // println("p179 cell = \(cell.calendar)")
        
       // cell.labelCalendar.text = object.calendar
        


        
        cell.labelCalendar.text = "add this from code"
        cell.labelVertical.text = ""            //TODO set this label background color to calendar color somehow
        cell.labelVertical.backgroundColor = UIColor.blueColor()
        
        cell.labelStart.text = eventStartDTString
        cell.labelEnd.text = eventEndDTString
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            events.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!)
        
        //General.playSound(alertSound3!)
        
        playSound(alertSound3)
     
    }

    
    
    
}

