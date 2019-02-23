//
//  ProfileTableViewCell.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/19/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
