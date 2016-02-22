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
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    var rtCounter = 0
    var fvCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextLabel.text = tweets.text
        let profileImage = tweets.user?.profileUrl
        imageView.setImageWithURL(profileImage!)
        imageView.layer.cornerRadius = 10.0
        
        if fvCounter == 0{
        favoriteCountLabel.text = String(tweets.favoritesCount)
            if tweets.favoritesCount == 0{
                favoriteCountLabel.hidden = true
            }
        }
        else if fvCounter == 1{
            favoriteCountLabel.text = String(tweets.favoritesCount+1)
             favoriteCountLabel.hidden = false
        }
        
        else if fvCounter == 2{
            favoriteCountLabel.text = String(tweets.favoritesCount-1)
             favoriteCountLabel.hidden = false
            if tweets.favoritesCount == 0{
                favoriteCountLabel.hidden = true
            }
        }
         
            
        if rtCounter == 0{
            retweetCountLabel.text = String(tweets.retweetCount)
            if tweets.retweetCount == 0{
                retweetCountLabel.hidden = true
            }

        }
    
        else if rtCounter == 1{
        retweetCountLabel.text = String(tweets.retweetCount+1)
             retweetCountLabel.hidden = false
        }
       else if rtCounter == 2{
            retweetCountLabel.text = String(tweets.retweetCount-1)
             retweetCountLabel.hidden = false
            if tweets.retweetCount == 0{
                retweetCountLabel.hidden = true
            }
        }

        nameLabel.text = tweets.user?.name
        timeStamp.text = String(tweets!.timeStamp!)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetButton(sender: AnyObject) {
         rtCounter++
        if rtCounter == 1 {
            retweetCountLabel.text = String(tweets.retweetCount+1)
            viewDidLoad()
        } else if rtCounter == 2{
            rtCounter = 0
            retweetCountLabel.text = String(tweets.retweetCount-1)
            viewDidLoad()
        }

    }

    @IBOutlet weak var fvButton: UIButton!
    @IBAction func favoriteButton(sender: AnyObject) {
        fvCounter++
        if fvCounter == 1{
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            fvButton.setImage(tintedImage, forState: .Normal)
            fvButton.tintColor = UIColor.yellowColor()
            viewDidLoad()
    }
        else if fvCounter == 2{
            fvCounter = 0
            let fvImage = UIImage(named: "favorite.png")
            let tintedImage = fvImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            fvButton.setImage(tintedImage, forState: .Normal)
            fvButton.tintColor = UIColor.blackColor()
            viewDidLoad()
        }
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
