//
//  ProfileTableViewCell.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/19/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIButton!
    @IBOutlet weak var profileName: UILabel!
   
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePicture.layer.cornerRadius = profilePicture.bounds.width / 2
        profilePicture.clipsToBounds = true
    }


    @IBAction func ProfileButtonPressed(_ sender: UIButton) {
        print("profile button pressed")
        
        
    }
    

}
