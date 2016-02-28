//
//  SearchCollectionViewCell.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/28/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
        @IBOutlet weak var profileImageView: UIImageView!
    var user: User! {
        didSet {
            profileImageView.setImageWithURL(user!.profileUrl!)
            nameLabel.text = user!.name
            screenNameLabel.text = ("@\(user!.screenName!)")
            
            profileImageView.layer.cornerRadius = 4
            profileImageView.clipsToBounds = true
        }
    }
}