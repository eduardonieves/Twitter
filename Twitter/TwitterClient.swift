//
//  TwitterClient.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/17/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "10SJAdUgWJiE2qlzRZ5PFGuzR"
let twitterConsumerSecret = "RdZ7aYeXEjHCN5bkxnfDfwhvNxbDiIpbXx35uJdMozVi4SiL0t"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")





class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    var loginSucces: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: ()->(), failure: (NSError)->()){
        loginSucces = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterEduardo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            var authURl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURl!)
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
        
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    func userTimeline(screenname: String, completion: (tweet: [Tweet]?, error: NSError?)-> ()) {
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                completion(tweet: tweets, error: nil)
            },
            
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Error retrieving info: \(error)")
                
                completion(tweet: nil, error: error)
               
        })
        
    }

    func tweet(tweetText: String) {
        let tweetText = (tweetText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        POST("1.1/statuses/update.json?status=\(tweetText)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Tweeted")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Tweet error:\(error)")
        })
        
    }
    
    func reply(tweetId: String, tweetText: String) {
        let escapedText = (tweetText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        print("1.1/statuses/update.json?status=\(escapedText)&in_reply_to_status_id=\(tweetId)")
        POST("1.1/statuses/update.json?status=\(escapedText)&in_reply_to_status_id=\(tweetId)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print(response)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Reply error:\(error)")
        })
        
    }
    func favorited(id:String) {
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json?id=\(id)", parameters:nil , success: { (operation:NSURLSessionDataTask?, response:AnyObject?) -> Void in
            print("successfully favorited")
            print(response)
            }) { (operation:NSURLSessionDataTask?, error:NSError!) -> Void in
                print("failed to favorited")
        }
    }
    func unfavorited(id:String) {
        TwitterClient.sharedInstance.POST("1.1/favorites/destroy.json?id=\(id)", parameters:nil , success: { (operation:NSURLSessionDataTask?, response:AnyObject?) -> Void in
            print("successfully unfavorited")
            print(response)
            }) { (operation:NSURLSessionDataTask?, error:NSError!) -> Void in
                print("failed to unfavorited")
        }
    }
    func retweet(id:String){
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters:nil , success: { (operation:NSURLSessionDataTask?, response:AnyObject?) -> Void in
            print("successfully retweeted")
            }) { (operation:NSURLSessionDataTask?, error:NSError!) -> Void in
                print("failed to retweet")
                
        }
        
    }
    func unretweet(id:String) {
        TwitterClient.sharedInstance.POST("1.1/statuses/unretweet/\(id).json", parameters:nil , success: { (operation:NSURLSessionDataTask?, response:AnyObject?) -> Void in
            print("successfully unretweeted")
            print(response)
            }) { (operation:NSURLSessionDataTask?, error:NSError!) -> Void in
                print("failed to unretweet")
        }
    }
    
    func homeTimeline(succes: ([Tweet]) -> (), failure: (NSError)-> ()){
        
        
       GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            succes(tweets)
            
          //  print("home_timeline: \(response)")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    func userProfileMedias(screenName: String!, completion: (medias: [NSURL]?, error: NSError?) -> ()) {
        self.GET("1.1/search/tweets.json?q=from%3A"+String(screenName.characters.dropFirst()).lowercaseString+"%20filter%3Aimages&include_entities=true&count=16", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            var medias = [NSURL]()
            if let tweets = response!["statuses"] as? [NSDictionary] {
                for tweet in tweets {
                    if let media = (tweet["entities"])!["media"] as? [NSDictionary] {
                        for image in media {
                            medias.append(NSURL(string: image["media_url_https"] as! String)!)
                        }
                    }
                    
                }
            }
            completion(medias: medias, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
                completion(medias: nil, error: error)
        })
        
    }
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("homeline error")
                completion(tweets: nil, error: error)
        })
        
    }
    func searchUsersWithParams(term: String!, params: NSDictionary?, completion: (users: [User]?, error: NSError?) -> ()) {
        
        
        self.GET("https://api.twitter.com/1.1/users/search.json?q=" + term, parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let users = User.usersWithArray(response as! [NSDictionary])
            completion(users: users, error: nil)
            print(response)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
                completion(users: nil, error: error)
        }
        
    }
    
    func currentAccount(succes: (User) ->(), failure: (NSError) ->()) {
        
        GET("1.1/account/verify_credentials.json", parameters: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            succes(user)
            
        
        
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error.localizedDescription)")
        })
    }
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken , success: { (accesToken: BDBOAuth1Credential!) -> Void in
           
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSucces?()
                }, failure:{ (error: NSError) -> () in
                   self.loginFailure?(error)
            })
        }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }

    }
}
