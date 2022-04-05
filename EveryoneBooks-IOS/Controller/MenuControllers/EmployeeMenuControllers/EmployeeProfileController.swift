//
//  EmployeeProfileMenu.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/22/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation
import UIKit


protocol EmployeeProfileDelegate: EmployeeProfileController {
    func leaveBusiness(bId: String, businessName: String, index: Int);
}

class EmployeeProfileController: UIViewController, EmployeeProfileDelegate {
    
    func leaveBusiness(bId: String, businessName: String, index: Int) {
        let alert = UIAlertController(title: "Confirm Leaving Business", message: "Are you sure you would like to leave " + businessName + " ? Once this is done, you will be completely removed from their schedule and this action will be permanent.", preferredStyle: .alert);
        let confirmButton = UIAlertAction(title: "Confirm", style: .destructive) { (UIAlertAction) in
            API().post(url: myURL + "employeeInfo/leaveBusiness", headerToSend: Utilities().getEmployeeToken(), dataToSend: ["bId": bId]) { (res) in
                if let sc = res["statusCode"] as? Int {
                    if sc == 200 {
                        self.businesses?.remove(at: index);
                    }
                }
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alert.addAction(confirmButton);
        alert.addAction(cancelButton);
        self.present(alert, animated: true, completion: nil);
    }
    
    private var businesses: [Business]? {
        didSet {
            businessesCollectionView.businesses = self.businesses;
        }
    }
    
    private let employeeProfileTextView: UIView = {
        let uiv = UIView();
        let uitv = UITextView();
        uiv.setHeight(height: 80);
        uiv.setWidth(width: fullWidth);
        uiv.backgroundColor = .mainLav;
        uitv.text = "My Profile";
        uitv.font = .boldSystemFont(ofSize: 22);
        uitv.isScrollEnabled = false;
        uitv.isEditable = false;
        uiv.addSubview(uitv);
        uitv.padLeft(from: uiv.leftAnchor, num: fullWidth / 10);
        uitv.backgroundColor = .mainLav
        uitv.padTop(from: uiv.topAnchor, num: 30);
        let uib = Components().createXButton();
        uiv.addSubview(uib);
        uib.padRight(from: uiv.rightAnchor, num: 20);
        uib.padTop(from: uiv.topAnchor, num: 20);
        uib.addTarget(self, action: #selector(dismissMe), for: .touchUpInside);
        return uiv;
    }()
    
    @objc func dismissMe() {
        dismiss(animated: true, completion: nil);
    }
    
    private let yourBusinessText = Components().createLittleText(text: "Places you are currently working:");
    
    private let businessesCollectionView: BusinessesCurrentlyWorking = {
        let uicv = BusinessesCurrentlyWorking(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout());
        return uicv;
    }()
    
    private let changePasswordText = Components().createLittleText(text: "Change Password:");
    
    private let currentPasswordTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Current Password", fontSize: 22);
        uitf.isSecureTextEntry = true;
        return uitf;
    }()
    
    lazy var currentPasswordInput: UIView = {
        let uiv = Components().createInput(textField: currentPasswordTextField, view: view);
        return uiv;
    }()
    
    private let newPasswordTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "New Password", fontSize: 22);
        uitf.isSecureTextEntry = true;
        return uitf;
    }()
    
    lazy var newPasswordInput: UIView = {
        let uiv = Components().createInput(textField: newPasswordTextField, view: view);
        return uiv;
    }()
    
    private let repeatNewPasswordTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Confirm New Password", fontSize: 22);
        uitf.isSecureTextEntry = true;
        return uitf;
    }()
    
    lazy var repeatNewPasswordInput: UIView = {
        let uiv = Components().createInput(textField: repeatNewPasswordTextField, view: view);
        return uiv;
    }()
    
    private let changePasswordButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.titleLabel?.font = .boldSystemFont(ofSize: 22);
        uib.backgroundColor = .liteGray;
        uib.setTitle("Change Password", for: .normal);
        uib.tintColor = .black;
        uib.setWidth(width: fullWidth / 1.3);
        uib.layer.borderWidth = 2.0;
        uib.layer.borderColor = .CGBlack;
        uib.setHeight(height: 42);
        uib.addTarget(self, action: #selector(changePassword), for: .touchUpInside);
        return uib;
    }()
    
    @objc func changePassword() {
        if let currentPassword = currentPasswordTextField.text, let newPassword = newPasswordTextField.text, let repeatNewPassword = repeatNewPasswordTextField.text {
            if newPassword == repeatNewPassword {
                API().post(url: myURL + "changePassword/employee", headerToSend: Utilities().getEmployeeToken(), dataToSend: ["cp": currentPassword, "np": newPassword]) { (res) in
                    if res["statusCode"] as? Int == 200 {
                        print("BOOYA")
                    }
                }
            }
        }
    }
    
    private let myIdText = Components().createLittleText(text: "My unique ID:");
    private let actualIdText = Components().createSimpleText(text: Utilities().getEmployeeId()!);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainLav;
        configure()
        getImportantInfo()
    }
    
    func configure() {
        businessesCollectionView.otherDelegate = self;
        view.addSubview(employeeProfileTextView);
        employeeProfileTextView.padTop(from: view.topAnchor, num: 0);
        employeeProfileTextView.centerTo(element: view.centerXAnchor);
        view.addSubview(changePasswordText);
        changePasswordText.centerTo(element: view.centerXAnchor);
        changePasswordText.padTop(from: employeeProfileTextView.bottomAnchor, num: 16);
        view.addSubview(currentPasswordInput);
        currentPasswordInput.padTop(from: changePasswordText.bottomAnchor, num: 8);
        currentPasswordInput.centerTo(element: view.centerXAnchor);
        view.addSubview(newPasswordInput);
        newPasswordInput.padTop(from: currentPasswordInput.bottomAnchor, num: 8);
        newPasswordInput.centerTo(element: view.centerXAnchor);
        view.addSubview(repeatNewPasswordInput);
        repeatNewPasswordInput.padTop(from: newPasswordInput.bottomAnchor, num: 8);
        repeatNewPasswordInput.centerTo(element: view.centerXAnchor);
        view.addSubview(changePasswordButton);
        changePasswordButton.padTop(from: repeatNewPasswordInput.bottomAnchor, num: 14);
        changePasswordButton.centerTo(element: view.centerXAnchor);
        view.addSubview(myIdText);
        myIdText.padTop(from: changePasswordButton.bottomAnchor, num: 30);
        myIdText.centerTo(element: view.centerXAnchor);
        view.addSubview(actualIdText);
        actualIdText.padTop(from: myIdText.bottomAnchor, num: 0);
        actualIdText.centerTo(element: view.centerXAnchor);
        view.addSubview(yourBusinessText);
        yourBusinessText.centerTo(element: view.centerXAnchor);
        yourBusinessText.padTop(from: actualIdText.bottomAnchor, num: 20);
        view.addSubview(businessesCollectionView);
        businessesCollectionView.padTop(from: yourBusinessText.bottomAnchor, num: 8);
        businessesCollectionView.centerTo(element: view.centerXAnchor);
        businessesCollectionView.setWidth(width: fullWidth);
        businessesCollectionView.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 4);
    }
    
    func getImportantInfo() {
        API().get(url: myURL + "employeeInfo/getBusinesses", headerToSend: Utilities().getEmployeeToken()) { (res) in
            if let businessBack = res["business"] as? [String: Any] {
                let myBusiness = Business(dic: businessBack);
                self.businesses = [myBusiness];
            }
        }
    }
}
