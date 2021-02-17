//
//  RegAdminThree.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/26/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegAdminThree: UIView {
    
    var street = "";
    var city = "";
    var state = "";
    var zip = "";

    override init(frame: CGRect) {
        super.init(frame:frame);
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let businessLocationText: UITextView = {
        let uitv = Components().createSimpleText(text: "Business Location")
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let streetTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Street Address", fontSize: 22.0);
        return uitf
    }()
    
    lazy var streetInput: UIView = {
        let uiv = Components().createInput(textField: streetTextField, view: self, typeOfInput: nil, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
    private let cityTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "City", fontSize: 22.0);
        return uitf
    }()
    
    lazy var cityInput: UIView = {
        let uiv = Components().createInput(textField: cityTextField, view: self, typeOfInput: nil, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
    private let stateTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "State", fontSize: 22.0);
        return uitf;
    }()
    
    lazy var stateInput: UIView = {
        let uiv = Components().createInput(textField: stateTextField, view: self, typeOfInput: nil, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
    private let zipTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Zip Code", fontSize: 22.0);
        return uitf
    }()
    
    lazy var zipInput: UIView = {
        let uiv = Components().createInput(textField: zipTextField, view: self, typeOfInput: nil, width: UIScreen.main.bounds.width / 1.3);
        return uiv;
    }()
    
    
    func configureView() {
        backgroundColor = .mainLav;
        
        addSubview(businessLocationText);
        businessLocationText.centerTo(element: centerXAnchor);
        businessLocationText.padTop(from: topAnchor, num: 10)
        
        addSubview(streetInput);
        streetInput.padTop(from: businessLocationText.bottomAnchor, num: 20);
        streetInput.centerTo(element: centerXAnchor);
        
        addSubview(cityInput);
        cityInput.padTop(from: streetInput.bottomAnchor, num: 20);
        cityInput.centerTo(element: centerXAnchor);
        
        addSubview(stateInput);
        stateInput.padTop(from: cityInput.bottomAnchor, num: 20);
        stateInput.centerTo(element: centerXAnchor);
        
        addSubview(zipInput);
        zipInput.padTop(from: stateInput.bottomAnchor, num: 20);
        zipInput.centerTo(element: centerXAnchor)
    }
    
    func getStreet() -> String {
        return streetTextField.text!;
    }
    
    func getCity() -> String {
        return cityTextField.text!;
    }
    
    func getState() -> String {
        return stateTextField.text!;
    }
    
    func getZip() -> String {
        return zipTextField.text!;
    }
    
    
}
