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

extension LoginViewController: loginViewDelegate {
    func didSelectLoginButton(_ loginView: LoginView, accountState: AccountStatus) {
        guard let email = loginView.nameTextField.text,
        let password = loginView.passwordTextField.text,
            !email.isEmpty, !password.isEmpty else {
               showAlert(title: "missing required fields", message: "email and password required", actionTitle: "try again")
                return
        }
        switch accountState {
        case .newAccount:
            usersession.createNewAccount(email: email, password: password)
       case .existingAccount:
            usersession.signInExistingUser(email: email, password: password)
        }
    }
}

extension LoginViewController: UserSessionAccountCreationDelegate {
    func didCreateAccount(_ userSession: UserSession, user: User) {
        showAlert(title: "Account Created", message: "account created using: \(user.email ?? "no email entered")", style: .alert) { (alert) in

        }
    }
    
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error) {
    
    }
    
}

extension LoginViewController: UserSessionSignInDelegate {
    func didRecieveSignInError(_ usersession: UserSession, error: Error) {
        
    }
    
    func didSignInExistingUser(_ usersession: UserSession, user: User) {
        <#code#>
    }
    
    
}
