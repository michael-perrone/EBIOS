//
//  RegAdminFour.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/27/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegAdminFour: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame);
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let extraBusinessInfo: UITextView = {
        let uitv = Components().createSimpleText(text: "Extra Business Info");
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let businessPhoneTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Business Phone Number", fontSize: 22.0)
        return uitf;
    }()
    
    lazy var businessPhoneInput: UIView = {
        let uiv = Components().createInput(textField: businessPhoneTextField, view: self, typeOfInput: nil, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
   private let businessWebsiteTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Business Website (Optional)", fontSize: 22.0)
        return uitf;
    }()
    
    lazy var businessWebsiteInput: UIView = {
        let uiv = Components().createInput(textField: businessWebsiteTextField, view: self, typeOfInput: nil, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
    func getWebsite() -> String {
        return businessWebsiteTextField.text!;
    }
    
    func getPhone() -> String {
        return businessPhoneTextField.text!;
    }
    

    func configureUI() {
        backgroundColor = .mainLav;
        
        addSubview(extraBusinessInfo);
        extraBusinessInfo.padTop(from: topAnchor, num: 10);
        extraBusinessInfo.centerTo(element: centerXAnchor);
        
        addSubview(businessPhoneInput);
        businessPhoneInput.centerTo(element: centerXAnchor);
        businessPhoneInput.padTop(from: extraBusinessInfo.bottomAnchor, num: 20);
        
        addSubview(businessWebsiteInput)
        businessWebsiteInput.padTop(from: businessPhoneInput.bottomAnchor, num: 20);
        businessWebsiteInput.centerTo(element: centerXAnchor);
    }
}
