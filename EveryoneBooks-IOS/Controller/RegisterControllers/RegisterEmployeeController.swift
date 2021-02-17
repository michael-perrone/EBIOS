//
//  RegisterEmployeeController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/22/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegisterEmployeeController: UIViewController {
    
    // MARK: - Properties
    
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
    
    private let errorText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.textColor = .red;
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let topText: UITextView = {
        let uitv = UITextView();
        uitv.text = "Register As Employee";
        uitv.font = UIFont(name: "ChalkboardSE-Bold", size: 26);
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
        let uiv = Components().createInput(textField: fullNameTextField, view: view, typeOfInput: nil);
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
        let uiv = Components().createInput( textField: emailLoginTextField, view: view, typeOfInput: "mail")
        return uiv;
    }()
    
    lazy var passwordInput: UIView = {
        let uiv = Components().createInput(textField: passwordLoginTextField, view: view, typeOfInput: "lock")
        return uiv;
    }()
    
    private let confirmPasswordLoginTextField: UITextField = {
        let tf = UITextField();
        tf.font = .systemFont(ofSize: 22);
        tf.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        tf.isSecureTextEntry = true;
        return tf;
    }()
    
    lazy var confirmPasswordInput: UIView = {
        let uiv = Components().createInput(textField: confirmPasswordLoginTextField, view: view, typeOfInput: "lock")
        return uiv;
    }()
    
    private let employerTextField: UITextField = {
          let tf = UITextField();
          tf.font = .systemFont(ofSize: 22);
          tf.attributedPlaceholder = NSAttributedString(string: "Employer Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]);
          return tf;
      }()
      
      lazy var employerInput: UIView = {
          let uiv = Components().createInput(textField: fullNameTextField, view: view, typeOfInput: nil);
          return uiv;
      }()
      
    
    private let registerButton: UIButton = {
        let uib = Components().createNormalButton(title: "Register");
        uib.addTarget(self, action: #selector(employeeRegister), for: .touchUpInside)
        return uib;
    }()
    
    private let undoButton: UIButton = {
        let uib = Components().createBackButton();
        uib.addTarget(self, action: #selector(goBack), for: .touchUpInside);
        return uib;
    }()
    
    // MARK: - Selectors
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true);
    }
    
    @objc func employeeRegister() {
        if let fullName = fullNameTextField.text, let email = emailLoginTextField.text, let password = passwordLoginTextField.text, let confirm = confirmPasswordLoginTextField.text {
            if fullName != "" && email != "" && password != "" && confirm != "" {
                if password == confirm {
                    let dataToSend = ["fullName": fullName,"email": email,"createPassword": password];
                    let url = "http://localhost:4000/api/employeeSignup"
                    BasicCalls().register(urlString: url, dataToSend: dataToSend) { (token) in
                        if token != "406" && token != "409" {
                            if Utilities().setTokenInKeyChain(token: token, key: "employeeToken") {
                                DispatchQueue.main.async {
                                    let employeeHome = EmployeeHomeController();
                                    employeeHome.modalTransitionStyle = .crossDissolve;
                                    self.navigationController?.pushViewController(employeeHome, animated: true);
                                }
                            }
                            else {
                                print("employee signup failed")
                            }
                        }
                        else {
                            if token == "409" {
                                DispatchQueue.main.async {
                                    self.errorText.text = "This email is already in use.";
                                    if self.errorText.isHidden {
                                        self.errorText.isHidden = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                if fullName == "" {
                    error = "Please enter full name."
                }
                else if email == "" {
                    error = "Please enter email."
                }
                else if password == "" {
                    error = "Please enter password."
                }
                else if confirm == "" {
                    error = "Please enter password confirm."
                }
            }
        }
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
        topText.padLeft(from: undoButton.rightAnchor, num: view.frame.width / 100);
        topText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        topText.setWidth(width: view.frame.width / 1.3);
        topText.setHeight(height: 70);
        
        view.addSubview(fullNameInput);
        fullNameInput.centerTo(element: view.centerXAnchor);
        fullNameInput.padTop(from: topText.bottomAnchor, num: 0);
        
        view.addSubview(emailInput)
        emailInput.centerTo(element: view.centerXAnchor);
        emailInput.padTop(from: fullNameInput.bottomAnchor, num: 20);
        
        view.addSubview(passwordInput);
        passwordInput.centerTo(element: view.centerXAnchor);
        passwordInput.padTop(from: emailInput.bottomAnchor, num: 20);
        
        view.addSubview(confirmPasswordInput);
        confirmPasswordInput.centerTo(element: view.centerXAnchor);
        confirmPasswordInput.padTop(from: passwordInput.bottomAnchor, num: 20);
        
        view.addSubview(registerButton)
        registerButton.centerTo(element: view.centerXAnchor);
        registerButton.padTop(from: confirmPasswordInput.bottomAnchor, num: 20);
        registerButton.setWidth(width: view.frame.width / 3.33);
        registerButton.setHeight(height: 45);
        
        view.addSubview(errorText);
        errorText.padTop(from: registerButton.bottomAnchor, num: 30);
        errorText.centerTo(element: view.centerXAnchor);
        errorText.isHidden = true;
    }

}
