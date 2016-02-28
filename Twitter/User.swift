//
//  User.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/18/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileUrl: NSURL?
    var tagline: String?
    var headerUrl: NSURL?
    var tweetCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    var medias: [NSURL]?
    var location: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        tagline = dictionary["description"] as? String
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tweetCount = dictionary["statuses_count"] as? Int

        location = dictionary["location"] as? String
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        let headerUrlString = dictionary["profile_banner_url"] as? String
        if let headerUrlString = headerUrlString {
            headerUrl = NSURL(string: headerUrlString)
        }

        tagline = dictionary["description"] as? String
    }
    
    class func usersWithArray(array: [NSDictionary]) -> [User] {
        var users = [User]()
        
        for dictionary in array {
            users.append(User(dictionary: dictionary))
        }
        return users
    }
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let userData = defaults.objectForKey("currentUserData") as? NSData
        
            if let userData = userData {
                let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                _currentUser = User(dictionary: dictionary)
                }
            }
        
        return _currentUser
        
    }
      
        
        set(user) {
            _currentUser = user
             let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            }else{
                defaults.setObject(nil, forKey: "currentUserData")

            }
           
            defaults.synchronize()
        }
    }
}
