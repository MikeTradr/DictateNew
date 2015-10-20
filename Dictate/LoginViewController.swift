//
//  LoginViewController.swift
//  Dictate
//
//  Created by Mike Derr on 7/26/15.
//  Copyright (c) 2015 ThatSoft.com. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    var window: UIWindow?
    
    var signupActive = true
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var registeredText: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func buttonTestPrefsScene(sender: AnyObject) {
        
        
        let storyboard = UIStoryboard(name: "oldPrefs", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("someViewController") 
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    //TODO Temp force login for testing... and Parse Mike username problems lol...
    
    @IBAction func buttonForceGo(sender: AnyObject) {
        
        print("p47 We here buttonForceGo?")
        
        var errorMessage = "Please try again later"
        
        //TODO I atempted to make a user namve for forced login so Parse still works!
        
        PFUser.logInWithUsernameInBackground("force", password: "force", block: { (user, error) -> Void in
            
            print("119 We here logged in?")
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
                // lpgged In!
                
                self.performSegueWithIdentifier("login", sender: self)
                
            } else {
                
                if let errorString = error!.userInfo["error"] as? String {
                    
                    errorMessage = errorString
                    
                }
                
                print("140 We here failed signup?")
                //println("140 username.text: \(username.text)")
                //println("140 password.text: \(password.text)")
                //println("140 self.email.text: \(email.text)")
                
                self.displayAlert("Failed SignUp", message: errorMessage)
                
                
            }
            
        })
        
        
        
        
        
        self.performSegueWithIdentifier("login", sender: self)
        
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        print("p44 We here buttonSignUp?")
        
        //TODO  if username.text == "" || password.text == "" || email.text == "" {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Error in form", message: "Please enter a username and password and email")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if signupActive == true {
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text
                user.email = email.text
                //TODO so we can see password so store password in our own field on parse, userpassword
                //user.userpassword = password.text
                
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    print("88 We here user.signUpInBackgroundWithBlock")
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        //Signup successful
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed Login", message: errorMessage)
                        
                    }
                    
                    
                })
                
            } else {
                
                print("136 username.text: \(username.text)")
                print("136 password.text: \(password.text)")
                print("136 self.email.text: \(email.text)")
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    print("119 We here logged in?")
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        // logged In!
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                        print("140 We here failed signup?")
                        //println("140 username.text: \(username.text)")
                        //println("140 password.text: \(password.text)")
                        //println("140 self.email.text: \(email.text)")
                        
                        self.displayAlert("Failed SignUp", message: errorMessage)
                        
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    
    
    @IBAction func buttonLogin(sender: AnyObject) {
        
        print("p134 We here buttonLogin?")
        
        
        if signupActive == true {
            
            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            
            registeredText.text = "Not registered?"
            
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
            
        } else {
            
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Alredy registered?"
            
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tabBarController = segue.destinationViewController as! UITabBarController
        tabBarController.selectedIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("190 We in LoginViewController viewDidAppear")
        
        PFUser.logOut()
        
        print("194 PFUser.currentUser(): \(PFUser.currentUser())")
        
        
        
        
        if PFUser.currentUser() != nil {
            // TODO commented out below for testing username problem 081715 MJD
            //  self.performSegueWithIdentifier("login", sender: self)
        }
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
