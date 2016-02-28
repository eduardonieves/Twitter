//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/21/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit



class TweetDetailViewController: UIViewController {
    
    
    var tweets: Tweet!
    var tweet: [Tweet]!
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replierName: UILabel!
    @IBOutlet weak var replyToLabel: UILabel!
    @IBOutlet weak var replyTweetLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var rtLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    var rtCounter = 0
    var fvCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoImage =  UIImage(named: "Twitter_logo_white_30px.png")
        let logoView = UIImageView(image:logoImage)
        self.navigationItem.titleView = logoView
        tweetTextLabel.text = tweets.text
        let profileImage = tweets.user?.profileUrl
        imageView.setImageWithURL(profileImage!)
        imageView.layer.cornerRadius = 10.0
        
        if tweets.favorited == true {
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            fvButton.setImage(tintedImage, forState: .Normal)
            fvButton.tintColor = UIColor.yellowColor()
            tweets.favorited = true
        }
        
        if tweets.favoritesCount == 1{
            favLabel.text = "FAVORITE"
            favoriteCountLabel.hidden = false
            favLabel.hidden = false
        }else if tweets.favoritesCount == 0{
            favoriteCountLabel.hidden = true
            favLabel.hidden = true
        }else{
            favLabel.text = "FAVORITES"
            favoriteCountLabel.hidden = false
            favLabel.hidden = false
        }
        
        favoriteCountLabel.text = String(tweets.favoritesCount!)
        
        if tweets.retweeted == true {
            
            let rtImage = UIImage(named: "retweet.png")
            let tintedImage = rtImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            rtButton.setImage(tintedImage, forState: .Normal)
            rtButton.tintColor = UIColor.greenColor()
        }
        
        if tweets.retweetCount == 1{
            rtLabel.text = "RETWEET"
            retweetCountLabel.hidden = false
            rtLabel.hidden = false
        }else if tweets.retweetCount == 0{
            retweetCountLabel.hidden = true
            rtLabel.hidden = true
        }
        else{
            rtLabel.text = "RETWEETS"
            retweetCountLabel.hidden = false
            rtLabel.hidden = false
        }
        
        retweetCountLabel.text = String(tweets.retweetCount)
        
        nameLabel.text = tweets.user?.name
        timeStamp.text = String(tweets!.timeStampString!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var rtButton: UIButton!
    @IBAction func retweetButton(sender: AnyObject) {
        if tweets.retweeted == false {
            TwitterClient.sharedInstance.retweet(tweets.tweetId!)
            tweets.retweetCount =  tweets.retweetCount + 1
            retweetCountLabel.text = String(tweets.retweetCount)
            tweets.retweeted = true
            
            
            let rtImage = UIImage(named: "retweet.png")
            let tintedImage = rtImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            rtButton.setImage(tintedImage, forState: .Normal)
            rtButton.tintColor = UIColor.greenColor()
            
            
            viewDidLoad()
        } else {
            TwitterClient.sharedInstance.unretweet(tweets.tweetId!)
            tweets.retweetCount =  tweets.retweetCount - 1
            retweetCountLabel.text = String(tweets.retweetCount)
            
            let rtImage = UIImage(named: "retweet.png")
            let tintedImage = rtImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            rtButton.setImage(tintedImage, forState: .Normal)
            rtButton.tintColor = UIColor.blackColor()
            
            tweets.retweeted = false
            viewDidLoad()
        }
    }
    
    @IBOutlet weak var fvButton: UIButton!
    @IBAction func favoriteButton(sender: AnyObject) {
        
        if tweets.favorited == false {
            TwitterClient.sharedInstance.favorited(tweets.tweetId!)
            tweets.favoritesCount =  tweets.favoritesCount + 1
            favoriteCountLabel.text = String(tweets.favoritesCount)
            
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            fvButton.setImage(tintedImage, forState: .Normal)
            fvButton.tintColor = UIColor.yellowColor()
            tweets.favorited = true
            viewDidLoad()
        } else {
            TwitterClient.sharedInstance.unfavorited(tweets.tweetId!)
            tweets.favoritesCount =  tweets.favoritesCount - 1
            favoriteCountLabel.text = String(tweets.favoritesCount)
            
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            fvButton.setImage(tintedImage, forState: .Normal)
            fvButton.tintColor = UIColor.blackColor()
            tweets.favorited = false
            viewDidLoad()
        }
        
        /* if tweets.favorited == true {
        fvCounter = 1
        }
        fvCounter++
        if fvCounter == 1{
        let fvImage = UIImage(named: "favorite.png")
        let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        fvButton.setImage(tintedImage, forState: .Normal)
        fvButton.tintColor = UIColor.yellowColor()
        tweets.favorited = true
        viewDidLoad()
        }
        else if fvCounter == 2{
        let fvImage = UIImage(named: "favorite.png")
        let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        fvButton.setImage(tintedImage, forState: .Normal)
        fvButton.tintColor = UIColor.blackColor()
        tweets.favorited = false
        viewDidLoad()
        }
        */
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ProfileSegue"{
            
            let profileNavigationController = segue.destinationViewController as! UINavigationController
            let profileController = profileNavigationController.viewControllers.first as! ProfileViewController
            
            profileController.tweet2 = tweets
            profileController.name = tweets.user!.name!
            profileController.screenName = (tweets.user?.screenName)!
        }
    else if segue.identifier == "ReplySegue"{
    let composeNavigationController = segue.destinationViewController as! UINavigationController
    let composeViewController = composeNavigationController.viewControllers.first as! ComposeViewController
    
   let replyHandle  = "@\((tweets.user!.screenName!)) "
    composeViewController.screenName = tweets.user!.screenName!
    composeViewController.isReply = true
    composeViewController.tweetId = tweets.tweetId!
    composeViewController.replyTo = replyHandle
    }
    }
    
}
