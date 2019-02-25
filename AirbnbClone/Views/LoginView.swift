//
//  LoginView.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/19/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

protocol loginViewDelegate: AnyObject {
    func didSelectLoginButton(_ loginView: LoginView, accountState: AccountStatus)
}



class LoginView: UIView {
    var gradient: CAGradientLayer!
    var buttonGradient: CAGradientLayer!
    public weak var delegate: loginViewDelegate?
    private var tapGesture: UITapGestureRecognizer!
    private var accountLoginState = AccountStatus.newAccount
    
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "enter username"
        tf.textAlignment = .center
        tf.backgroundColor = .white
        tf.backgroundColor?.withAlphaComponent(0.5)
        tf.layer.cornerRadius = 20
        return tf
    }()
    
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "enter you email"
        tf.textAlignment = .center
        tf.backgroundColor = .white
        tf.backgroundColor?.withAlphaComponent(0.5)
        tf.layer.cornerRadius = 20
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.textAlignment = .center
        tf.backgroundColor = .white
        tf.backgroundColor?.withAlphaComponent(0.5)
        tf.layer.cornerRadius = 20
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
         button.backgroundColor = .blue
        button.layer.cornerRadius = 20
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    lazy var loginLabel: UILabel = {
    var label = UILabel()
        label.text = "Login using your acccount"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        commonInit()

        
    }
    
    
    private func commonInit() {
        setupLoginViewBackground()
        setupTextfieldConstrains()
        setupButtonLogin()
        setupLabel()
        loginLabel.isUserInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        loginLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        accountLoginState = accountLoginState == .newAccount ? .existingAccount : .newAccount
        switch accountLoginState {
        case .newAccount:
           loginButton.setTitle("Create", for: .normal)
            loginLabel.text = "Login using your acccount"
        case .existingAccount:
            loginButton.setTitle("Login", for: .normal)
            loginLabel.text = "New user? Create an account"
        }
        
        
    }
    
    private func setupLabel() {
        addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        loginLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
        loginLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    
    
    
    
    private func setupTextfieldConstrains() {
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        //name
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //email
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
        //password
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor).isActive = true
    }

    private func setupLoginViewBackground()  {
        gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.init(r: 241, g: 159, b: 132).cgColor, UIColor.init(r: 247, g: 203, b: 187).cgColor]
        layer.addSublayer(gradient)
    }
    
    private func setupButtonLogin() {
        addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.applyGradient(colors: [UIColor.init(r: 23, g: 54, b: 255).cgColor, UIColor.init(r: 89, g: 149, b: 247).cgColor])
        loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, multiplier: 0.8).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
 
    
}


