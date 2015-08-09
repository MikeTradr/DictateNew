//
//  ToDoTableViewController.swift
//  WatchInput
//
//  Created by Mike Derr on 6/22/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import AVFoundation

class ToDoTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numberOfNewItems:Int    = 0
    var startDT:NSDate          = NSDate()
    var endDT:NSDate            = NSDate()
    var today:NSDate            = NSDate()
    var reminders:NSMutableArray   = []
    
    @IBOutlet var ToDoTableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()

    func playSound(sound: NSURL){
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    func fetchReminders() -> NSMutableArray {
        var eventStore : EKEventStore = EKEventStore()
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent' TODO use for Reminders? Mike
        
        eventStore.requestAccessToEntityType(EKEntityTypeReminder, completion: {
            granted, error in
            if (granted) && (error == nil) {
                println("granted: \(granted)")
                println("error:  \(error)")
                
                var reminder:EKEvent = EKEvent(eventStore: eventStore)
                
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
            for reminder in reminders {
                println("p52 reminder title: \(reminder.title)")
                


                
                //Anil error below, ... 'NSMutableArray' does not have member named 'append'
                
               self.reminders.addObject(reminder.title!!)
                
                println("p62 self.reminders: \(self.reminders)")

                
                
                //var reminders = (reminders as! Array<EKReminder>).map
                
                //Anil line 141 below here  bombs, I've tried for all day on this!
                // see consel I have the reminder titles somehow! just can't get them into Array~
                // uncomment it was suppsoed to populate the array
                //self.reminders = NSMutableArray(array: eventStore.eventsMatchingPredicate(predicate))
                
                //reminders = ("This String")
                
                //TODO Mike get reminders going :)
                
                
            }
        }
        
        // What about Calendar entries?

        
        
        
        
  /*
 

    // make Reminder array try...
        
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let startDate = cal!.startOfDayForDate(date)
        
        var endDate = startDate.dateByAddingTimeInterval(60*60*24)
        
        println("•p87 we here? startDate: \(startDate)")
        
        var predicate3 = eventStore.predicateForIncompleteRemindersWithDueDateStarting(startDate, ending: endDate, calendars: nil)
        
       // var predicate2 = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
        
        println(" p93 startDate:\(startDate) endDate:\(endDate)")
        
       // var eV = eventStore.eventsMatchingPredicate(predicate) as! [EKEvent]!
        
       var eV = eventStore.eventsMatchingPredicate(predicate3)

        
        println("p97 eV: \(eV)" )         // prints Event details! good.
        
        if eV != nil {
            
            if eV.count == 0 {
                println("No events could be found")
            } else {
                
                reminders = NSMutableArray(array: eventStore.eventsMatchingPredicate(predicate3))
                println("p177 events  \(reminders)" )
                
                for i in eV {
                    println("p66 Title  \(i.title)" )
                    println("p67 stareDate: \(i.startDate)" )
                    println("p68 endDate: \(i.endDate)" )
                    
                    
                    // Access list of available sources from the Event Store
                    let sourcesInEventStore = eventStore.sources() as! [EKSource]
                    
                    // http://www.andrewcbancroft.com/2015/06/17/creating-calendars-with-event-kit-and-swift/
                    
                    
                    if i.title == "Test Title" {
                        println("YES" )
                        // Uncomment if you want to delete
                        //eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
                    }
                }
            }
        }
        
    // above her emake array testing
        
*/
        
       // reminders = ["first reminder title", "second reminder title", "third reminder title lol"]
        
        
        
        println("p152: reminders: \(reminders)")
        
        return reminders
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var viewController = self
        
        // TODO Mike move this to EventCode class???
        
        //reminders = fetchReminders()
        reminders = fetchReminders()
        
        
        println("p175: reminders: \(self.reminders)")
        println("p176: reminders.count: \(self.reminders.count)")
        
        
        
        //Register custom cell
        var nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        ToDoTableView.registerNib(nib, forCellReuseIdentifier: "customCell")
        
        //Set the badger number to display
        // TODO add this to the app start up, does not show when app loads.
        numberOfNewItems = reminders.count
        if (self.numberOfNewItems == 0) {
            self.tabBarItem.badgeValue = nil;
        } else {
            numberOfNewItems = reminders.count
            self.tabBarItem.badgeValue = String(numberOfNewItems)
        }
  
    }
    
    override func viewWillAppear(animated: Bool) {
        var alertSound3: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("se_tap", ofType: "m4a")!)!
        //General.playSound(alertSound3!)
        
        playSound(alertSound3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return reminders.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let object: AnyObject = reminders[indexPath.row]
        
        println("p222: object: \(object)")
        
        
        var cell:ToDoTableCell = tableView.dequeueReusableCellWithIdentifier("customCell") as! ToDoTableCell
        
        cell.labelTitle.text = String(object as! NSString)
        //cell.labelTitle.text = "Test Reminder Title"
        
        
        
        // let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
