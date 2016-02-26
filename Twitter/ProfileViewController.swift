//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/24/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var tweet2: Tweet!
    var index: Int?
    var screenName: String = ""
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        
        infoView.layer.borderWidth = 1
        infoView.layer.borderColor = UIColor.grayColor().CGColor
        
        if let tweet = tweets?[index!] {
        
        tweetCountLabel.text = String(tweet.user!.tweetCount!)
        followersCountLabel.text = String(tweet.user!.followersCount!)
        followingCountLabel.text = String(tweet.user!.followingCount!)
        
        profileNameLabel.text = tweet.user?.name
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
        
        let profileImage = tweet.user?.profileUrl
        profileImageView.setImageWithURL(profileImage!)
        profileImageView.layer.cornerRadius = 10.0

       
        if let  headerImage = tweet.user?.headerUrl{
        headerImageView.setImageWithURL(headerImage)
        let ligthBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: ligthBlur)
        blurView.alpha = 0.8
        blurView.frame = headerImageView.bounds
        headerImageView.addSubview(blurView)
        }
        }
        else{
            profileNameLabel.text = name
            screenNameLabel.text = screenName
            
            tweetCountLabel.text = String(tweet2.user!.tweetCount!)
            followersCountLabel.text = String(tweet2.user!.followersCount!)
            followingCountLabel.text = String(tweet2.user!.followingCount!)
            
            let profileImage = tweet2.user?.profileUrl
            profileImageView.setImageWithURL(profileImage!)
            profileImageView.layer.cornerRadius = 10.0

            
            if let  headerImage = tweet2.user?.headerUrl{
                headerImageView.setImageWithURL(headerImage)
                let ligthBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
                let blurView = UIVisualEffectView(effect: ligthBlur)
                blurView.alpha = 0.8
                blurView.frame = headerImageView.bounds
                headerImageView.addSubview(blurView)
            }

            
        }
        getTweets()
        
        
        
   // settingsView.layer.borderWidth = 1
     //   settingsView.layer.borderColor = UIColor.grayColor().CGColor
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileViewCell
    
        let tweet = tweets![indexPath.row]

        cell.profileNameLabel.text = tweet.user?.name
        cell.screenNameLabel.text = "@\(tweet.user!.screenName!)"
        let profileImage = tweet.user?.profileUrl
        cell.profileImageView.setImageWithURL(profileImage!)
        cell.tweetTextLabel.text = tweet.text
      

    
    return cell
    }
    func getTweets() {
        
        if let tweet = tweets?[index!]{
        screenName = tweet.user!.screenName!
        }
        else{
            screenName = tweet2.user!.screenName!
        }
        TwitterClient.sharedInstance.userTimeline(screenName) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }

    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
