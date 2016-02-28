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
    var tweetId: String?
    var timeStampString: String?
    var retweetCount: Int = 0
    var favoritesCount: Int!
    var user: User?
    var replyToScreename: String?
    var retweeted: Bool!
    var favorited: Bool!

    init(dictionary: NSDictionary){
        tweetId = (dictionary["id_str"] as! String?)!
         user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoritesCount =  Int((dictionary["favorite_count"] as! NSNumber?)!)
        print(favoritesCount)
        retweeted = false
        favorited = false
         timeStampString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timeStamp = formatter.dateFromString(timeStampString!)
        replyToScreename = dictionary["in_reply_to_screen_name"] as? String
   
        
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
