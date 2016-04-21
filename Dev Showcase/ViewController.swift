//
//  ViewController.swift
//  Dev Showcase
//
//  Created by Jason Leocata on 11/04/2016.
//  Copyright © 2016 Jason Leocata. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_GO_TO_FEED, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!){
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Facebook login success! \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) in
                    
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("Logged in \(authData)")
                        
                        let user = ["provider": authData.provider!, "blah":"test"]
                        DataService.ds.createFirebaseUsers(authData.uid, user: user)
                        
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        
                        
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    
    
    @IBAction func attemptLogin(sender: UIButton!){
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { (error, authdata) in
                
                if error != nil {
                    print(error.code)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "This account already exists, please try again!")
                            } else {
                                
                                
                                
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                               
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { (err, authData) in
                                    let user = ["provider": authData.provider!]
                                    DataService.ds.createFirebaseUsers(authData.uid, user: user)
                                    
                                })
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                            
                        })
                    } else {
                        self.showErrorAlert("Login Failed", msg: "Please check your username or password")
                    }
                } else {
                    
                }
                
            })
            
        } else {
            showErrorAlert("Login Failed", msg: "Email and password must be provided")
        }
    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }


}

