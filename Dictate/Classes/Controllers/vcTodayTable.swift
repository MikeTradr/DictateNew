//
//  vcTodayTable.swift
//  Dictate
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
    var startDT:Date          = Date()
    var endDT:Date            = Date()
    var today:Date            = Date()
    var events:NSMutableArray   = []
    
    
    // from http://stackoverflow.com/questions/24722597/fetch-events-from-ekeventstore-and-show-in-tableview-in-swift-ios8
    
    func fetchEvents() -> NSMutableArray {
        let eventStore : EKEventStore = EKEventStore()
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent' TODO use for Reminders? Mike
        
        eventStore.requestAccess(to: EKEntityType.event, completion: {
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
        let predicate = eventStore.predicateForReminders(in: [])
        eventStore.fetchReminders(matching: predicate) { reminders in
            for reminder in reminders! {
                print("•p73: reminder title: \(reminder.title)")
                
                //TODO Mike get reminders going :)
                
            }
        }
        
        // What about Calendar entries?
        
        let date = Date()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let startDate = cal.startOfDay(for: date)
        
        let endDate = startDate.addingTimeInterval(60*60*24)
        let predicate2 = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        print("startDate:\(startDate) endDate:\(endDate)")
        let eV = eventStore.events(matching: predicate2) as [EKEvent]!
        
        //println("p68 eV: \(eV)" )         // prints Event details! good.
        
        if eV != nil {
            
            if eV?.count == 0 {
                print("No events could be found")
            } else {
                
                events = NSMutableArray(array: eventStore.events(matching: predicate2))
                //println("p88 events  \(events)" )
                
                for i in eV! {
                    print("p66 Title  \(i.title)" )
                    print("p67 stareDate: \(i.startDate)" )
                    print("p68 endDate: \(i.endDate)" )
                    
                    
                    // Access list of available sources from the Event Store
                    let sourcesInEventStore = eventStore.sources 
                    
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
    
    func playSound(_ sound: URL){
        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
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
    
    override func viewWillAppear(_ animated: Bool) {
        let alertSound3: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "se_tap", ofType: "m4a")!)
        //General.playSound(alertSound3!)
        
        playSound(alertSound3)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let viewController = self
        
        print("p182 vcToday viewController: \(viewController)" )

        
        // TODO Mike move this to EventCode class???
        events = fetchEvents()
        
        //Register custom cell
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableViewToday.register(nib, forCellReuseIdentifier: "customCell")
        
        //Set the bader number to display
        // TODO add this to the app start up, does not show when app loads.
        numberOfNewItems = events.count
        if (self.numberOfNewItems == 0) {
            self.tabBarItem.badgeValue = nil;
        } else {
            self.tabBarItem.badgeValue = String(numberOfNewItems)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object: EKEvent = events[(indexPath as NSIndexPath).row] as! EKEvent
        
        let cell:TableCell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! TableCell
        // cell.selectionStyle = .None
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let eventStartDTString = dateFormatter.string(from: object.startDate)
        let eventEndDTString = dateFormatter.string(from: object.endDate)
        
        cell.labelTitle.text = object.title
        
        //Anil 1. we need to pull calendar Name somehow here...
        //Anil 2. we need to pull set label for calendar color:  labelVertical
        
        //cell.calendar = eventStore.eventCalendar
       // println("p179 cell = \(cell.calendar)")
        
       // cell.labelCalendar.text = object.calendar
        


        
        cell.labelCalendar.text = "add this from code"
        cell.labelVertical.text = ""            //TODO set this label background color to calendar color somehow
        cell.labelVertical.backgroundColor = UIColor.blue
        
        cell.labelStart.text = eventStartDTString
        cell.labelEnd.text = eventEndDTString
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            events.removeObject(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        
        let alertSound3: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "se_tap", ofType: "m4a")!)
        
        //General.playSound(alertSound3!)
        
        playSound(alertSound3)
     
    }

    
    
    
}

