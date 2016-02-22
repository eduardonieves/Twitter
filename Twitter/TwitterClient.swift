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
    
    func homeTimeline(succes: ([Tweet]) -> (), failure: (NSError)-> ()){
        
        
       GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            succes(tweets)
            
            // print("home_timeline: \(response)")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })


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
