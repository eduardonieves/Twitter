//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/18/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var fvCounter = 0
    var rtCounter = 0
    var tweetsCount: Int!
    var tweeted = false
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var loadingCount = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
        let logoImage =  UIImage(named: "Twitter_logo_white_30px.png")
        let logoView = UIImageView(image:logoImage)
        self.navigationItem.titleView = logoView
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
     
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.navigationItem.titleView = logoView
            
            for tweet in tweets{
                print(tweet.text)
            }
            
            }) { (error: NSError) -> () in
                print("error: \(error.localizedDescription)")
        }
      
        let refreshControl2 = UIRefreshControl()
        refreshControl2.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl2, atIndex: 0)
    
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
              print("Tweets Count: \(tweets!.count)")
            return tweets!.count
          
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        
        cell.tweetTextLabel.sizeToFit()
        
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
    
    func loadList(notification: NSNotification){
        //load data here
        viewDidLoad()
        self.tableView.reloadData()
    }
    
    func loadMoreData() {
        
        loadingCount += 20
        let param = ["count": loadingCount]
        TwitterClient.sharedInstance.homeTimelineWithParams(param) { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets!
                self.isMoreDataLoading = false
                
                self.tableView.reloadData()
            }
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadingCount = 20
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets!
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }
       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
            if segue.identifier == "ComposeSegue"{
                let composeNavigationController = segue.destinationViewController as! UINavigationController
                let composeViewController = composeNavigationController.viewControllers.first as! ComposeViewController
                composeViewController.isReply = false
        }
       
            if segue.identifier == "ProfileSegue"{
                
                let button = sender as! UIButton
                let buttonFrame = button.convertRect(button.bounds, toView: self.tableView)
                if let indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin) {
                    let profileNavigationController = segue.destinationViewController as! UINavigationController
                    let profileController = profileNavigationController.viewControllers.first as! ProfileViewController
                    
                    let selectedRow = indexPath.row as NSInteger
                    
                    profileController.tweets = tweets
                    profileController.index = selectedRow
                }


            }
            else if segue.identifier == "TweetDetailSegue"{
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = self.tweets![indexPath!.row]
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
               // print("favorites: \(tweet.favoritesCount)")
            tweetDetailViewController.tweets = tweet
        }
            else if segue.identifier == "ReplySegue"{
                let button = sender as! UIButton
                let buttonFrame = button.convertRect(button.bounds, toView: self.tableView)
                if let indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin){                let tweet = self.tweets![indexPath.row]
                let composeNavigationController = segue.destinationViewController as! UINavigationController
                let composeViewController = composeNavigationController.viewControllers.first as! ComposeViewController
                
              let replyHandle  = "@\((tweet.user!.screenName!) ) "
                composeViewController.screenName = (tweet.user!.screenName)!
                composeViewController.isReply = true
                composeViewController.tweetId = tweet.tweetId!
                composeViewController.replyTo = replyHandle
                }
        }


    }


}
