//
//  UserSettingsViewController.swift
//  Dev Showcase
//
//  Created by Jason Leocata on 17/04/2016.
//  Copyright © 2016 Jason Leocata. All rights reserved.
//

import UIKit
import Firebase

class UserSettingsViewController: UIViewController {
    
    
    @IBOutlet weak var usernameText: MaterialTextField!
    @IBOutlet weak var saveUsernameBtn: MaterialButton!
    
    var usernameRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("username")
    
    
    //var currentUser = DataService.ds.REF_USER_CURRENT as? String
    
    var currentUser = DataService.ds.REF_USER_CURRENT
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        
    }

    
    
    @IBAction func saveUserBtnTapped(sender: AnyObject) {
        if usernameText.text != nil {
            usernameRef.setValue(usernameText.text)
        }
        
        
    }
    




}
