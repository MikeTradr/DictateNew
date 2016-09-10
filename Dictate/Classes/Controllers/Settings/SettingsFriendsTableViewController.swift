//
//  SettingsFriendsTableViewController.swift
//  Dictate
//
//  Created by Mike Derr on 8/26/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//
// http://iswift.org/cookbook/add-item-to-dictionary
//

import UIKit




class SettingsFriendsTableViewController: UIViewController{

   //@IBOutlet var tableView: UITableView!
    
    
    
    @IBAction func buttonAddFriend(sender: AnyObject) {
        print("p23 we here")
        switchScreen("AddFriend")
        
        
    }
    
    
    @IBAction func buttonAddFriendold1(sender: AnyObject) {
        print("p22 we here")
        switchScreen("AddFriend")
    }
    
    
    
    
    @IBAction func buttonAddFriendold(sender: AnyObject) {
       self.performSegueWithIdentifier("addFriend", sender: self)

        switchScreen("AddFriend")
    }
   
    @IBOutlet weak var table: UITableView!
    
    var people: [[String:String]] = [[:]]
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    
    let smilieFace:UIImage = UIImage(named:"smilieFace")!
    
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene)
        self.presentViewController(vc, animated: true, completion: nil)
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // tableView.tableFooterView = UIView()    //hides blank cells
        
        
        people = [
            [
            "firstName": "Calvin",
            "lastName": "Newton",
            "phone": "608-242-7700",
            "email": "mike@newton.ws",
            "picture": "picture as data?"
            ],
            [
            "firstName": "Garry",
            "lastName": "Mckenzie",
            "phone": "608-255-1234",
            "email": "garry@gmail.com"
            ],
            [
                "firstName": "Mom",
                "phone": "608-837-2341"
            ],
            [
                "firstName": "Dad",
                "email": "tony.tiger.myemail@yahoo.com"
            ]
        ]
        
        print("p66 people.count: \(people.count)")
        print("p67 people: \(people)")
        
        // let sortedDict = people.sort { $0.0 < $1.0 }
        
      //  let results = Array(people).sort({ $0.0 < $1.0})
        
        // http://stackoverflow.com/questions/31527754/sort-dictionary-by-key-value
        
        // let fruitsTupleArray = people.sort{ $0.1 > $1.1 }


        
     //   let sortedKeysAndValues = sorted(people) { $0.0 < $1.0 }
      //  let keys = sortedKeysAndValues.map {$0.0 }
     //   let values = sortedKeysAndValues.map {$0.1 }
        
        //let sortedKeysAndValues = sorted(people) { $0.0 < $1.0 }

        
        //swift 3
        //let sortedDict2 = people.sorted(by: <)
        
        print("p71 people: \(people)")
        
        defaults.setObject(people, forKey: "people")        //sets actionType for processing

        
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - TableView Data Source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }


    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Configure the cell...
        
        let identifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! SettingsFriendsTableViewCell
    
        cell.selectionStyle = .None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

    
        let row = people[indexPath.row]
    
        let firstName:String = row["firstName"]!
        let lastName:String = row["lastName"] ?? ""

        cell.labelName.text     = firstName + " " + lastName
        cell.labelPhone.text    = row["phone"]
        cell.labelEmail.text    = row["email"]
    
        //make image a circle
        //https://www.appcoda.com/ios-programming-circular-image-calayer/
        //
        cell.imagePicture.layer.cornerRadius = cell.imagePicture.frame.size.width / 2
        cell.imagePicture.clipsToBounds = true
    
        //add a border
        cell.imagePicture.layer.borderWidth = 1.0
        cell.imagePicture.layer.borderColor = UIColor.whiteColor().CGColor
    
        print("p154 row[phone]: \(row["phone"])")
    
        if row["phone"] == nil {
            cell.constraintEmailTop.constant = 0
        }
    
        print("p162 row[picture]: \(row["picture"])")
    
    
    //TODO Anil Mike tried to have smilie face is no image is set
    //http://stackoverflow.com/questions/26569371/how-do-you-create-a-uiimage-view-programmatically-swift
    //
        if row["picture"] == nil {
            print("p165 we here? ")
            
           cell.imagePicture.image  =  UIImage(named: "smilie46px.png")
        }
        
    


        return cell
    }
    
    
    //===== didSelectRowAtIndexPath ================================================
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("p119 You selected row/event # \(indexPath.row)")
        
         var selectedCell:UITableViewCell = table.cellForRowAtIndexPath(indexPath)!
        
        let identifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier( identifier, forIndexPath: indexPath) as! SettingsFriendsTableViewCell
        
        let row = people[indexPath.row]
        
    
        
        self.performSegueWithIdentifier("addFriend", sender: self)

        
        
        
    }
    
    
    
    // for Add contact VC
    //https://www.hackingwithswift.com/example-code/media/how-to-save-a-uiimage-to-a-file-using-uiimagepngrepresentation
  /*
    if let image = UIImage(named: "example.png") {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().stringByAppendingPathComponent("copy.png")
            data.writeToFile(filename, atomically: true)
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
*/
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
