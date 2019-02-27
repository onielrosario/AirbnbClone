//
//  DescriptionController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/27/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

class DescriptionController: UIViewController {
    @IBOutlet weak var descriptionInfo: UITextView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doneDescriptionPressed(_ sender: UIButton) {
        print("description button pressed")
       self.dismiss(animated: true, completion: nil)
    }
    
}
