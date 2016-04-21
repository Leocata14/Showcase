//
//  ProfileSetupViewController.swift
//  Dev Showcase
//
//  Created by Jason Leocata on 21/04/2016.
//  Copyright © 2016 Jason Leocata. All rights reserved.
//

import UIKit
import Firebase

class ProfileSetupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameTxtField: MaterialTextField!
    
    var usernameRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("username")
    var currentUser = DataService.ds.REF_USER_CURRENT
    
    
    var imgSelected = false
    var imgPicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imgPicker.dismissViewControllerAnimated(true, completion: nil)
        profileImg.image = image
        imgSelected = true
    }


    @IBAction func saveBtnTapped(sender: AnyObject) {
        if usernameTxtField.text != nil {
            usernameRef.setValue(usernameTxtField.text)
        }
        
        self.performSegueWithIdentifier(SEGUE_GO_TO_FEED, sender: nil)
        
    }

    
    
    @IBAction func profileImgSelectorTapped(sender: AnyObject) {
        presentViewController(imgPicker, animated: true, completion: nil)
    }
    

}
