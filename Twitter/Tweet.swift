//
//  Tweet.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/18/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timeStamp: NSDate?
    var timeStampString: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?

    
    init(dictionary: NSDictionary){
         user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoritesCount = dictionary["favourites_count"] as? Int ?? 0
        
         timeStampString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timeStamp = formatter.dateFromString(timeStampString!)
   
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        
        return tweets

    }
    
    
    
}
