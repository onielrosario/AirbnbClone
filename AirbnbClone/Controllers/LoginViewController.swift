//
//  LoginViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/19/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountStatus {
    case newAccount
    case existingAccount
}




class LoginViewController: UIViewController {
    private var usersession: UserSession!
let loginView = LoginView()
    override func viewDidLoad() {
        super.viewDidLoad()
view.addSubview(loginView)
    }
    


}
