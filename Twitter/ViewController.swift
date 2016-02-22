//
//  ViewController.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/17/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit
import BDBOAuth1Manager



class ViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
    
        TwitterClient.sharedInstance.login({ () -> () in
            print("I've logged in!")
            self.performSegueWithIdentifier("LoginSegue", sender: nil)
            
            }) { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        }
        
        
        
    }

}

