//
//  FeedViewController.swift
//  Dev Showcase
//
//  Created by Jason Leocata on 12/04/2016.
//  Copyright © 2016 Jason Leocata. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import TLYShyNavBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var posts = [Post]()
    var imageSelected = false
    static var imageCache = NSCache()
    var userPostRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("posts")
    
    var username: String!
    
    var imgPicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //let view = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40))
        //ext.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 347
        imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    //print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String,AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dicitionary: postDict)
                        self.posts.append(post)
                    }
                }
                
            }
            
            self.tableView.reloadData()
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = post.imageUrl{
                img = FeedViewController.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            
            return cell
        } else {
            return PostCell()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imgPicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
    }
    
    
    @IBAction func selectImg(sender: UITapGestureRecognizer) {
        presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func makePost(sender: AnyObject) {
        if let txt = postField.text where txt != "" {
            
            if let img = imageSelectorImage.image where imageSelected == true {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "024BGRUW130c3eff4ae836e0ac37a0d0f0833803".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    
                    
                }) { encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload,_,_):
                        upload.responseJSON(completionHandler: { response in
                            
                            if let info = response.result.value as? Dictionary<String,AnyObject> {
                                if let links = info["links"] as? Dictionary<String,AnyObject> {
                                    if let imgLink = links["image_link"] as? String {
                                        print("LINK: \(imgLink)")
                                        self.postToFirebase(imgLink)
                                    }
                                }
                            }
                            
                        })
                    case .Failure(let error):
                        print(error)
                    }
                    
                    
                }
            
            } else {
                self.postToFirebase(nil)
            }
    }

    }
    
    func postToFirebase(imgUrl: String?) {
        
        
        var post: Dictionary<String,AnyObject> = [
            "description": postField.text!,
            "likes": 0,
            "user": "\(DataService.ds.REF_USER_CURRENT.key)",
            "username": "\(self.username)"
            
        ]
        
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        let postKey = firebasePost.key
        userPostRef.childByAppendingPath("\(postKey)").setValue(true)
        
        let usernameRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("username")
        
        usernameRef.observeEventType(.Value, withBlock: { snapshot in
            //self.username = "\(snapshot.value)"
            print(snapshot.value)
            let firsebasePostUsername = firebasePost.childByAppendingPath("username")
            firsebasePostUsername.setValue(snapshot.value)
        })
        
        
        

        postField.text = ""
        imageSelectorImage.image = UIImage(named: "camera")
        imageSelected = false
        
        tableView.reloadData()
    }
    

}


