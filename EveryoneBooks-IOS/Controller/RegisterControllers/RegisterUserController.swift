//
//  RegisterUserController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/22/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegisterUserController: UIViewController {
    
    var error = "" {
        didSet {
            if error != "" {
                errorText.isHidden = false;
            }
            else {
                errorText.isHidden = true;
            }
            errorText.text = error;
        }
    }
    
    // MARK: - Properties
    
    private let topText: UITextView = {
        let uitv = UITextView();
        uitv.text = "Register As User";
        uitv.font = UIFont(name: "ChalkboardSE-Bold", size: 28);
        uitv.backgroundColor = .mainLav;
        uitv.textAlignment = .center;
        uitv.isEditable = false;
        uitv.textColor = .black;
        return uitv;
    }();

    private let fullNameTextField: UITextField = {
        let tf = UITextField();
        tf.font = .systemFont(ofSize: 22);
        tf.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]);
        return tf;
    }()
    
    lazy var fullNameInput: UIView = {
        let uiv = Components().createInput( textField: fullNameTextField, view: view, typeOfInput: nil);
        return uiv;
    }()
    
    private let phoneNumberTextField: UITextField = {
        let tf = UITextField();
        tf.font = .systemFont(ofSize: 22);
        tf.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]);
        return tf;
    }()
    
    lazy var phoneNumberInput: UIView = {
        let uiv = Components().createInput( textField: phoneNumberTextField, view: view, typeOfInput: nil);
        return uiv;
    }()
    
    private let emailLoginTextField: UITextField = {
        let tf = UITextField();
        tf.font = .systemFont(ofSize: 22);
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return tf;
    }()
    
    private let passwordLoginTextField: UITextField = {
        let tf = UITextField();
        tf.font = .systemFont(ofSize: 22);
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        tf.isSecureTextEntry = true;
        return tf;
    }()
    
    lazy var emailInput: UIView = {
        let uiv = Components().createInput(textField: emailLoginTextField, view: view, typeOfInput: "mail")
        return uiv;
    }()
    
    lazy var passwordInput: UIView = {
        let uiv = Components().createInput(textField: passwordLoginTextField, view: view, typeOfInput: "lock")
        return uiv;
    }()
    
    private let confirmPasswordLoginText: UITextField = {
        let tf = UITextField();
        tf.font = .systemFont(ofSize: 22);
        tf.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        tf.isSecureTextEntry = true;
        return tf;
    }()
    
    lazy var confirmPasswordInput: UIView = {
        let uiv = Components().createInput( textField: confirmPasswordLoginText, view: view, typeOfInput: "lock")
        return uiv;
    }()
    
    private let registerButton: UIButton = {
        let uib = Components().createNormalButton(title: "Register");
        uib.titleLabel?.font = .boldSystemFont(ofSize: 22)
        uib.addTarget(self, action: #selector(registerUser), for: .touchUpInside);
        return uib;
    }()
    
    private let undoButton: UIButton = {
        let uib = Components().createBackButton();
        uib.addTarget(self, action: #selector(goBack), for: .touchUpInside);
        return uib;
    }()
    
    private let errorText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.textColor = .red;
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    // MARK: - Selectors
    
    @objc func registerUser() {
        if fullNameTextField.text! != "" && emailLoginTextField.text! != "" && passwordLoginTextField.text! != "" && phoneNumberTextField.text! != "" && passwordLoginTextField.text! == confirmPasswordLoginText.text! {
            let url = "http://localhost:4000/api/usersSignup"
            let datatoSend = ["fullName": fullNameTextField.text!, "email": emailLoginTextField.text!, "createPassword": passwordLoginTextField.text!, "phoneNumber": phoneNumberTextField.text!];
            BasicCalls().register(urlString: url, dataToSend: datatoSend) { (token) in
                if token != "406" && token != "409" && token != "405" {
                    if Utilities().setTokenInKeyChain(token: token, key: "token") {
                        DispatchQueue.main.async {
                            let userHome = UserHomeViewController();
                            userHome.modalTransitionStyle = .crossDissolve;
                            self.navigationController?.pushViewController(userHome, animated: true);
                            }
                        }
                    else {
                        print("register didnt work")
                    }
                }
                else {
                    if token == "406" {
                        DispatchQueue.main.async {
                            self.errorText.text = "Please enter valid phone number.";
                            if self.errorText.isHidden {
                                self.errorText.isHidden = false;
                            }
                        }
                    }
                    else if token == "409" {
                        DispatchQueue.main.async {
                            self.errorText.text = "This email is already in use.";
                            if self.errorText.isHidden {
                                self.errorText.isHidden = false;
                            }
                        }
                    }
                    else if token == "405" {
                        DispatchQueue.main.async {
                            self.errorText.text = "This phone is already in use.";
                            if self.errorText.isHidden {
                                self.errorText.isHidden = false;
                            }
                        }
                    }
                }
            }
        } else {
            if fullNameTextField.text! == "" {
                if emailLoginTextField.text! == "" {
                    error = "Please fill in forms above"
                    return;
                }
                if passwordLoginTextField.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                if confirmPasswordLoginText.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                if phoneNumberTextField.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                error = "Please Enter Full Name";
            }
            else if emailLoginTextField.text! == "" {
                if passwordLoginTextField.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                if confirmPasswordLoginText.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                if phoneNumberTextField.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                error = "Please Enter Email";
            }
            else if passwordLoginTextField.text! == "" {
                if confirmPasswordLoginText.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                if phoneNumberTextField.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                error = "Please Enter Password"
            }
            else if passwordLoginTextField.text! != confirmPasswordLoginText.text! {
                error = "Passwords do not match"
            }
            if phoneNumberTextField.text! == "" {
                if confirmPasswordLoginText.text! == "" {
                    error = "Please fill in forms above";
                    return;
                }
                error = "Please Enter Phone Number";
            }
        }
    }
    
 
    @objc func goBack() {
        navigationController?.popViewController(animated: true);
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = .mainLav;
        configureUI();
        hkb();
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(undoButton);
        undoButton.padLeft(from: view.leftAnchor, num: 10);
        undoButton.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 5);
        
        view.addSubview(topText);
        topText.padLeft(from: undoButton.rightAnchor, num: view.frame.width / 100)
        topText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        topText.setWidth(width: view.frame.width / 1.3)
        topText.setHeight(height: 70);
        
        view.addSubview(fullNameInput);
        fullNameInput.centerTo(element: view.centerXAnchor);
        fullNameInput.padTop(from: topText.bottomAnchor, num: 0);
        
        view.addSubview(emailInput);
        emailInput.centerTo(element: view.centerXAnchor);
        emailInput.padTop(from: fullNameInput.bottomAnchor, num: 20)
        
        view.addSubview(passwordInput);
        passwordInput.centerTo(element: view.centerXAnchor);
        passwordInput.padTop(from: emailInput.bottomAnchor, num: 20);
        
        view.addSubview(confirmPasswordInput);
        confirmPasswordInput.centerTo(element: view.centerXAnchor);
        confirmPasswordInput.padTop(from: passwordInput.bottomAnchor, num: 20);
        
        view.addSubview(phoneNumberInput);
        phoneNumberInput.centerTo(element: view.centerXAnchor);
        phoneNumberInput.padTop(from: confirmPasswordInput.bottomAnchor, num: 20);
        
        view.addSubview(registerButton)
        registerButton.centerTo(element: view.centerXAnchor);
        registerButton.padTop(from: phoneNumberInput.bottomAnchor, num: 20);
        registerButton.setWidth(width: view.frame.width / 3.33);
        registerButton.setHeight(height: 45);
        
        view.addSubview(errorText);
        errorText.padTop(from: registerButton.bottomAnchor, num: 30);
        errorText.centerTo(element: view.centerXAnchor);
        errorText.isHidden = true;
    }
}
