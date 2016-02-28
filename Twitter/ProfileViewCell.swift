//
//  ProfileViewCell.swift
//  Twitter
//
//  Created by Eduardo Nieves on 2/24/16.
//  Copyright © 2016 Eduardo Nieves. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
