//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/18/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var tweets: [Tweet]!
    var fvCounter = 0
    var rtCounter = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 120
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
            
            for tweet in tweets{
                print(tweet.text)
            }
            
            }) { (error: NSError) -> () in
                print("error: \(error.localizedDescription)")
        }
      
       // print("HERE: \(name)")
        
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
        
        let tweet = tweets![indexPath.row]
        let retweetCount = String(tweet.retweetCount)
        if rtCounter == 0{
            
            cell.retweetCountLabel.text = retweetCount
            
            if tweet.retweetCount == 0{
            cell.retweetCountLabel.hidden = true
            }
        }
        else if rtCounter == 1{
            
             let retweetCount = String(tweet.retweetCount+1)
             cell.retweetCountLabel.text = retweetCount
             cell.retweetCountLabel.hidden = false
        }
        else if rtCounter == 2 {
            
            let retweetCount = String(tweet.retweetCount-1)
            cell.retweetCountLabel.text = retweetCount
            cell.retweetCountLabel.hidden = false
            if tweet.retweetCount == 0{
                cell.retweetCountLabel.hidden = true
            }
        }
        
        let favoriteCount = String(tweet.favoritesCount)
        if fvCounter == 0{
            
            cell.favoriteCountLabel.text = favoriteCount
            cell.favoriteCountLabel.hidden = true
            if tweet.favoritesCount == 0{
                cell.favoriteCountLabel.hidden = true
            }
        }
        else if fvCounter == 1{
            
            let favoriteCount = String(tweet.favoritesCount+1)
            cell.favoriteCountLabel.text = favoriteCount
            cell.favoriteCountLabel.hidden = false
        }
        else if rtCounter == 2 {
            
            let favoriteCount = String(tweet.favoritesCount-1)
            cell.favoriteCountLabel.text = favoriteCount
            cell.favoriteCountLabel.hidden = false
            if tweet.favoritesCount == 0{
                cell.favoriteCountLabel.hidden = true
            }
        }
        
        
        
        
        
        cell.screenNameLabel.text = tweet.user?.name
        cell.timeStampLabel.text = String(tweet.timeStamp!)
        cell.tweetTextLabel.text = tweet.text
        let profileImage = tweet.user?.profileUrl
        let profileView = profileImage
        cell.profileImageView.layer.cornerRadius = 10.0
        cell.profileImageView.setImageWithURL(profileView!)
       
        
        
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func retweetButton(sender: AnyObject) {
        rtCounter++
        if rtCounter == 1 {
            viewDidLoad()
        } else if rtCounter == 2{
            viewDidLoad()
        }
        
    }
    

   

    
       @IBAction func favoriteButton(sender: AnyObject) {
        fvCounter++
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell


        if fvCounter == 1{
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            
            
            cell.fvButton.setImage(tintedImage, forState: .Normal)
            cell.fvButton.tintColor = UIColor.yellowColor()
            viewDidLoad()
        }
        else if fvCounter == 2{
            fvCounter = 0
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.fvButton.setImage(tintedImage, forState: .Normal)
            cell.fvButton.tintColor = UIColor.blackColor()
            viewDidLoad()
        }
            return cell
        }
    }
  
    
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
       
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = self.tweets![indexPath!.row]
            
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
           
            tweetDetailViewController.tweets = tweet
            

    }


}
