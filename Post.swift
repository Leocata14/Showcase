//
//  Post.swift
//  Dev Showcase
//
//  Created by Jason Leocata on 12/04/2016.
//  Copyright © 2016 Jason Leocata. All rights reserved.
//

import Foundation
import Firebase

class Post{
    
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String?
    private var _postKey: String!
    private var _postRef: Firebase!
    
    private var _userKey: String?
    private var _userRef: Firebase!

    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String? {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    var userKey: String? {
        return _userKey
    }

    
    
    
    init(description: String, imageUrl: String?, username: String) {
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
    }
    
    init(postKey: String, dicitionary: Dictionary<String,AnyObject>){
        self._postKey = postKey
        
        //self._userKey = userKey
        
        if let likes = dicitionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dicitionary["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let desc = dicitionary["description"] as? String {
            self._postDescription = desc
        }
        
        if let username = dicitionary["username"] as? String {
            self._username = username
        }
        
        if let userKey = dicitionary["user"] as? String {
            self._userKey = userKey
        }
        
        
        self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self._postKey)
        self._userRef = DataService.ds.REF_POSTS.childByAppendingPath(self._userKey)
        
        //self._username = _userRef.valueForKey("user") as? String
        
        
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)
    }
    
    
    
}