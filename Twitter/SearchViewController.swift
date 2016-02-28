//
//  SearchViewController.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/28/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var searchBar = UISearchBar()

    var userResults = [User]()
    var resultCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCollectionViewCell
        cell.user = userResults[indexPath.row]
        return cell
    }
    
   /* func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let user = userResults[indexPath.row]
      
        
        TwitterClient.sharedInstance.userProfileMedias(user.screenName, completion: { (medias, error) -> () in
           user.medias = medias
            self.performSegueWithIdentifier("ProfileSegue", sender: user)
})
    }
*/
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)  {
         collectionView.hidden = true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        TwitterClient.sharedInstance.searchUsersWithParams(searchBar.text!, params: nil) { (users, error) -> () in
            self.userResults = users!
            self.resultCount = self.userResults.count
            self.collectionView.reloadData()
        }
        
        collectionView.hidden = false
         searchBar.resignFirstResponder()
    }

   
     /*  // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
*/
}
