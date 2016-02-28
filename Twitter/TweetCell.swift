//
//  TweetCell.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/18/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

  
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var rtButton: UIButton!

    @IBOutlet weak var fvButton: UIButton!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
  

    
    var tweet: Tweet! {
        didSet {
            
            nameLabel.text = tweet.user!.name!
            screenNameLabel.text = ("@\(tweet.user!.screenName!)")
            tweetTextLabel.text = tweet.text
            timeStampLabel.text = tweet.timeStampString
            let url = tweet.user?.profileUrl
            profileImageView.setImageWithURL(url!)
            retweetCountLabel.text = String(tweet.retweetCount)
            favoriteCountLabel.text = String(tweet.favoritesCount!)
            tweet.favorited = false
            tweet.retweeted = false
            
        }
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        if !tweet.favorited {
            TwitterClient.sharedInstance.favorited(tweet.tweetId!)
            tweet.favoritesCount =  tweet.favoritesCount + 1
            favoriteCountLabel.text = String(tweet.favoritesCount)
            
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            fvButton.setImage(tintedImage, forState: .Normal)
            fvButton.tintColor = UIColor.yellowColor()
            tweet.favorited = true
        } else {
            TwitterClient.sharedInstance.unfavorited(tweet.tweetId!)
            tweet.favoritesCount =  tweet.favoritesCount - 1
            favoriteCountLabel.text = String(tweet.favoritesCount)
            
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            fvButton.setImage(tintedImage, forState: .Normal)
            fvButton.tintColor = UIColor.blackColor()
            tweet.favorited = false
    }
    }
    
    
    @IBAction func onRetweet(sender: UIButton) {
        if !tweet.retweeted {
            TwitterClient.sharedInstance.retweet(tweet.tweetId!)
            tweet.retweetCount =  tweet.retweetCount + 1
            retweetCountLabel.text = String(tweet.retweetCount)
            tweet.retweeted = true
            
            
            let rtImage = UIImage(named: "retweet.png")
            let tintedImage = rtImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            rtButton.setImage(tintedImage, forState: .Normal)
            rtButton.tintColor = UIColor.greenColor()
            
            
            
        } else {
            TwitterClient.sharedInstance.unretweet(tweet.tweetId!)
            tweet.retweetCount =  tweet.retweetCount - 1
            retweetCountLabel.text = String(tweet.retweetCount)
            
            let rtImage = UIImage(named: "retweet.png")
            let tintedImage = rtImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            rtButton.setImage(tintedImage, forState: .Normal)
            rtButton.tintColor = UIColor.blackColor()
            
            tweet.retweeted = false
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
