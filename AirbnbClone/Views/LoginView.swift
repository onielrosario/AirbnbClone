//
//  LoginView.swift
//  AirbnbClone
//
//  Created by Oniel Rosario on 2/19/19.
//  Copyright © 2019 Oniel Rosario. All rights reserved.
//

import UIKit

class LoginView: UIView {
    var gradient: CAGradientLayer!
    
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "enter you name"
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
    }
    
    private func setupTextfieldConstrains() {
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        //name
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
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
    
}


