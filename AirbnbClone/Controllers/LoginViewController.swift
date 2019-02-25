//
//  LoginViewController.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/19/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

enum AccountStatus {
    case newAccount
    case existingAccount
}

protocol LoginViewDelegate: AnyObject {
    func didSelectLoginButton(_loginView: LoginView, accountLoginState: AccountStatus)
}


class LoginViewController: UIViewController {
    private var usersession: UserSession!
let loginView = LoginView()
    private var tapGesture: UITapGestureRecognizer!
    private var accountLoginState = AccountStatus.newAccount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
    
        loginView.nameTextField.delegate = self
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)

        
        
    }
    
    @objc private func loginButtonPressed() {
      
    }

}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let name = loginView.nameTextField.text,
        let email = loginView.emailTextField.text,
        let password = loginView.passwordTextField.text,
            !name.isEmpty, !email.isEmpty, !password.isEmpty else {
                return false
        }
        switch accountLoginState {
        case .newAccount:
          usersession.createNewAccount(email: email, password: password)
        case .existingAccount:
           usersession.signInExistingUser(email: email, password: password)
        }
        return true 
    }
}
