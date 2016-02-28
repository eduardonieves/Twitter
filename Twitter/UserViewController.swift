//
//  UserViewController.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/27/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class UserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetsCounterLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    var tweets: [Tweet]!
    var screenName: String = ""
    var name: String!
    var tweetId: String!
    var replyHandle: String!
    var index: Int?


    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
  NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        let logoImage =  UIImage(named: "Twitter_logo_white_30px.png")
        let logoView = UIImageView(image:logoImage)
        self.navigationItem.titleView = logoView
        
        let profileImage = User.currentUser?.profileUrl
        profileImageView.setImageWithURL(profileImage!)
        profileImageView.layer.cornerRadius = 10.0
        
        if let  headerImage = User.currentUser?.headerUrl {
            headerImageView.setImageWithURL(headerImage)
            let ligthBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurView = UIVisualEffectView(effect: ligthBlur)
            blurView.alpha = 0.8
            blurView.frame = headerImageView.bounds
            headerImageView.addSubview(blurView)
        }
        
    nameLabel.text = User.currentUser!.name!
    screenNameLabel.text = User.currentUser!.screenName!
    descriptionLabel.text = User.currentUser!.tagline!
     tweetsCounterLabel.text = String(User.currentUser!.tweetCount!)
        followingCountLabel.text = String(User.currentUser!.followingCount!)
        followersCountLabel.text = String(User.currentUser!.followersCount!)
        
        getTweets()
        
        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        cell.tweetTextLabel.sizeToFit()
        tweetId = cell.tweet.tweetId
        
     /*
        cell.profileNameLabel.text = tweet.user?.name
        cell.screenNameLabel.text = "@\(tweet.user!.screenName!)"
        let profileImage = tweet.user?.profileUrl
        cell.profileImageView.setImageWithURL(profileImage!)
        cell.tweetTextLabel.text = tweet.text
        tweetId = tweet.tweetId
        
*/
        
        return cell
    }

    func getTweets() {
        
       screenName = (User.currentUser?.screenName)!
        TwitterClient.sharedInstance.userTimeline(screenName) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }
    
    func loadList(notification: NSNotification){
        //load data here
        viewDidLoad()
        self.tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "ComposeSegue"{
            let composeNavigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = composeNavigationController.viewControllers.first as! ComposeViewController
            composeViewController.isReply = false
        } else if segue.identifier == "ReplySegue"{
            let composeNavigationController = segue.destinationViewController as! UINavigationController
            let composeViewController = composeNavigationController.viewControllers.first as! ComposeViewController
            
            replyHandle  = "@\((screenName) ) "
            composeViewController.screenName = screenName
            composeViewController.isReply = true
            composeViewController.tweetId = tweetId
            composeViewController.replyTo = replyHandle
        }
        else if segue.identifier == "TweetDetailSegue"{
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = self.tweets![indexPath!.row]
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            // print("favorites: \(tweet.favoritesCount)")
            tweetDetailViewController.tweets = tweet
        }


    }


}
