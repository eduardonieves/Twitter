//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/25/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var tweetView: UITextView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var charCountButton: UIBarButtonItem!
    @IBOutlet weak var replyToLabel: UILabel!
    
    var tweets: [Tweet]!
    var name: String!
    var screenName = ""
    var tweetId: String = ""
    var replyTo: String = ""
    var charCount: String!
    var isReply: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetView.delegate = self
        let logoImage =  UIImage(named: "Twitter_logo_white_30px.png")
        let logoView = UIImageView(image:logoImage)
        self.navigationItem.titleView = logoView
        
        print(tweetId)
        
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = ("@\(User.currentUser!.screenName!)")
        let imageUrl = (User.currentUser?.profileUrl)!
        profileImageView.setImageWithURL(imageUrl)
        tweetView.text = replyTo
        
        if isReply == false {
            replyToLabel.hidden = true
        } else if isReply == true {
            replyToLabel.hidden = false
            replyToLabel.text = "In reply to @\(screenName)"
        }
         tweetView.becomeFirstResponder()
        
    }
    func textViewDidChange(tweetView: UITextView) {
        let count = tweetView.text.characters.count
        charCountButton.title = "\(140-count)"
        if (140-count) < 0 {
            charCountButton.tintColor = UIColor.redColor()
        } else {
            charCountButton.tintColor = UIColor.grayColor()
        }
    }

    @IBAction func submitTweet(sender: AnyObject) {
        let count = tweetView.text.characters.count
        
        if count <= 140{
            if isReply == false {
                print("Tweeted")
                TwitterClient.sharedInstance.tweet("\(tweetView.text)")
                NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                dismissViewControllerAnimated(true, completion: nil)
            }else if isReply == true {
                print("Replyed")
                TwitterClient.sharedInstance.reply(tweetId, tweetText: tweetView.text)
                NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
               dismissViewControllerAnimated(true, completion: nil)
        }
        }
    }
    @IBAction func onCancel(sender: AnyObject) {
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
