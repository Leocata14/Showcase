//
//  PostCell.swift
//  Dev Showcase
//
//  Created by Jason Leocata on 12/04/2016.
//  Copyright © 2016 Jason Leocata. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!
    var userRef: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeTapped(_:)))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
        
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        
        
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        userRef = post.userKey!
        
        //let temp = DataService.ds.REF_POSTS.childByAppendingPath("user").childByAppendingPath(post.userKey).key
        //let temp = DataService.ds.REF_USERS.childByAppendingPath("users").childByAppendingPath("posts").valueForKey("\()")
        //print("TEMP: \(temp)")
        //print("user: \(userRef)")
        
        self.descriptionText.text = post.postDescription
        self.likesLabel.text = "\(post.likes)"
            self.usernameLabel.text = post.username
        

    
        
        
        //self.showcaseImg.image = img
        
        if post.imageUrl != nil {
            
            if img != nil {
                
                self.showcaseImg.image = img
                
            } else {
                
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedViewController.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                    
                })
            }
            
        } else {
            self.showcaseImg.hidden = true
        }
        
        
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExisit = snapshot.value as? NSNull {
                //This means we have not liked this post
                self.likeImage.image = UIImage(named: "heart-empty")
            } else {
                self.likeImage.image = UIImage(named: "heart-full")
            }
            
        })
        
        
        
    
    }
    
    func likeTapped(sender: UIGestureRecognizer?) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExisit = snapshot.value as? NSNull {
                
                self.likeImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
            
        })
    }
}























