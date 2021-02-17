//
//  RegAdminTwo.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/25/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegAdminTwo: UIView {
    
    var fullName = "";
    var email = "";
    var password = "";
    var confirmPassword = "";

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let adminInfoText: UITextView = {
        let uitv = Components().createSimpleText(text: "Enter Administrator Info");
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let emailTextField: UITextField = {
        let tf = Components().createTextField(placeHolder: "Email", fontSize: 22);
        return tf;
    }();
    
    lazy var emailInput: UIView = {
        let uiv = Components().createInput(textField: emailTextField, view: self, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Components().createTextField(placeHolder: "Password", fontSize: 22);
        tf.isSecureTextEntry = true;
        return tf;
    }();
    
    lazy var passwordInput: UIView = {
        let uiv = Components().createInput(textField: passwordTextField, view: self, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let tf = Components().createTextField(placeHolder: "Confirm Password", fontSize: 22);
        tf.isSecureTextEntry = true;
        return tf;
    }();
    
    lazy var confirmPasswordInput: UIView = {
        let uiv = Components().createInput(textField: confirmPasswordTextField, view: self, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
   
    
    func getEmail() -> String {
        return emailTextField.text!;
    }
    
    func getPassword() -> String {
        return passwordTextField.text!;
    }
    
    func getConfirmPassword() -> String {
        return confirmPasswordTextField.text!;
    }
    
    func configureView() {
        
        addSubview(adminInfoText);
        adminInfoText.padTop(from: topAnchor, num: 10);
        adminInfoText.centerTo(element: centerXAnchor);
        
        addSubview(emailInput);
        emailInput.padTop(from: adminInfoText.bottomAnchor, num: 20);
        emailInput.centerTo(element: centerXAnchor);
        
        addSubview(passwordInput);
        passwordInput.padTop(from: emailInput.bottomAnchor, num: 20);
        passwordInput.centerTo(element: centerXAnchor);
        
        addSubview(confirmPasswordInput);
        confirmPasswordInput.padTop(from: passwordInput.bottomAnchor, num: 20);
        confirmPasswordInput.centerTo(element: centerXAnchor);
        
    }
    
    
}
