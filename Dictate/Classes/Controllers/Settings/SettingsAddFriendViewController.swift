//
//  SettingsAddFriendViewController.swift
//  Dictate
//
//  Created by Mike Derr on 9/6/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsAddFriendViewController: UIViewController {
    
    var messageString = ""
    var friendFirstName = "Belinda"
    
    let defaults = NSUserDefaults(suiteName: "group.com.thatsoft.dictateApp")!
    var audioPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var buttonAddFriend: UIButton!
    
    @IBOutlet weak var buttonPicture: UIButton!
    
    @IBAction func buttonAddPicture(sender: AnyObject) {
        
        self.switchScreen("Friends")

        
    }
    
    
    
    @IBAction func buttonAddFriend(sender: AnyObject) {
        
        let alertSound1 = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("217-buttonclick03", ofType: "mp3")!)
        //  General.playSound(alertSound3!)
        playSound(alertSound1)
        
        
        // ____ Alert Dialog ____________________________________

        self.messageString = "👤 New Friend: \"\(friendFirstName)\" saved!"
        
        let alertTitle = messageString
        let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 22)
        let attributedString = NSAttributedString(string: alertTitle, attributes: [
            NSFontAttributeName: labelFont!,
            NSForegroundColorAttributeName: UIColor.blueColor() //TODO Mike ANIL why is Font color NOT beeing set???
            ])
        
        let textLine2 = "by Dictate™ App 😀"
        let labelFont2 = UIFont(name: "HelveticaNeue-Bold", size: 16)
        let attributedString2 = NSAttributedString(string: textLine2, attributes: [
            NSFontAttributeName: labelFont2!,
            NSForegroundColorAttributeName: UIColor.blackColor() //TODO Mike ANIL why is Font color NOT beeing set???
            ])
        
        let alert = UIAlertController(title: alertTitle, message: textLine2, preferredStyle: UIAlertControllerStyle.Alert)
        alert.setValue(attributedString, forKey: "attributedTitle")
        alert.setValue(attributedString2, forKey: "attributedMessage")
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        // ____ End Alert Dialog ____________________________________
        
        General().delay(3.0) {
            // do stuff
           // self.resultMessage.text = ""
            
            //let processNow = false
           // self.defaults.setObject(processNow, forKey: "ProcessNow")
            
            self.presentedViewController!.dismissViewControllerAnimated(true, completion: nil)      //close alert after the set delay of 3 seconds!
            
           // self.tabBarController?.selectedIndex = 2        //go back to main Dictate start screen
            
             self.switchScreen("Friends")
            
        }
        
        
        
        // switchScreen("Friends")
 
        
    }
    
    
    @IBAction func buttonCancel(sender: AnyObject) {
         switchScreen("Friends")
        
        
    }
    
    
    func switchScreen(scene: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier(scene)
        //self.presentViewController(vc, animated: true, completion: nil)
        self.presentViewController(vc, animated: false, completion: nil)

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

        // Do any additional setup after loading the view.
        
        buttonPicture.layer.borderWidth = 1
        buttonPicture.layer.borderColor = UIColor.yellowColor().CGColor
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
