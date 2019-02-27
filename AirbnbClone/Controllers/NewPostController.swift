//
//  NewPostController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/27/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

class NewPostController: UIViewController {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postStepper: UIStepper!
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var PriceTF: UITextField!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addInfoPressed(_ sender: UIButton) {
        print("add info pressed")
    }
    
    @IBAction func LocationPressed(_ sender: UIButton) {
        print("Location Pressed")
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        print("Done Pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
