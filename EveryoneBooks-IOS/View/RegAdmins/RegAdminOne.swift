//
//  RegAdminOne.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/25/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegAdminOne: UIView {
    
    // MARK: - VARS
   
    
    private var nameOfBusiness = "";
    private var typeOfBusiness = "";
    private var selected = "";
    private let screenSize = UIScreen.main.bounds;

    // MARK: -INIT
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
  
    
   private let nameBusinessText: UITextView = {
          let uitv = Components().createSimpleText(text: "Name of Business:");
    uitv.backgroundColor = .mainLav;
          return uitv;
      }()
      
   private let nameBusinessTextField: UITextField = {
          let uitf = Components().createTextField(placeHolder: "Name of Business", fontSize: 22.0);
          return uitf;
      }()
      
      lazy var nameBusinessInput: UIView = {
        let uiv = Components().createInput(textField: nameBusinessTextField, view: self, width: screenSize.width / 1.3);
          return uiv;
      }()
      
     private let typeBusinessText: UITextView = {
          let uitv = Components().createSimpleText(text: "Type of Business:");
        uitv.backgroundColor = .mainLav;
          return uitv;
      }()
      
     private let typeOfBusinessText: UITextView = {
          let uitv = Components().createSimpleText(text: "Type of Business")
          return uitv;
      }()
      
    private let businessPicker: BusinessPicker = {
          let uipv = BusinessPicker();
          uipv.setHeight(height: 140);
          return uipv;
      }()
    
    // MARK: -HELPERS
    
    func getName() -> String {
            return nameBusinessTextField.text!;
    }
    
    func getType() -> String {
            return businessPicker.selected;
    }
    
   
    
    
    func configureView() {
        backgroundColor = .mainLav;
        addSubview(nameBusinessText);
        nameBusinessText.centerTo(element: centerXAnchor);
        nameBusinessText.padTop(from: topAnchor, num: screenSize.height / 22)
        
        addSubview(nameBusinessInput);
        nameBusinessInput.centerTo(element: centerXAnchor);
        nameBusinessInput.padTop(from: nameBusinessText.bottomAnchor, num: screenSize.height / 42);
        
        addSubview(typeBusinessText);
        typeBusinessText.centerTo(element: centerXAnchor);
        typeBusinessText.padTop(from: nameBusinessInput.bottomAnchor, num: screenSize.height / 8);
        
        addSubview(businessPicker);
        businessPicker.centerTo(element: centerXAnchor);
        businessPicker.padTop(from: typeBusinessText.bottomAnchor, num: 0);
        
        
        
        
        
        
        
   
        
        
       
        
    }
    
}
