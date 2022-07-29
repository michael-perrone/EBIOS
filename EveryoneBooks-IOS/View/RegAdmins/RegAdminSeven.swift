//
//  RegAdminSeven.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/30/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegAdminSeven: UIView {
    
    var eq: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let bookingThingText: UITextView = {
        let uitv = Components().createSimpleText(text: "Item/Area Being Booked");
        uitv.font = .systemFont(ofSize: 18);
        uitv.backgroundColor = .mainLav;
        return uitv
    }()
    
    private let bookingThingTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Item/Area for Booking", fontSize: 22.0);
        return uitf;
    }()
    
    lazy var bookingThingInput: UIView = {
        let uiv = Components().createInput(textField: bookingThingTextField, view: self, width: UIScreen.main.bounds.width / 1.3)
        return uiv;
    }()

    private let bookingThingNumberText: UITextView = {
        let uitv = Components().createSimpleText(text: "Num of Items/Areas Being Booked");
        uitv.font = .systemFont(ofSize: 18);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let bookingItemPicker: BookingItemPicker = {
        let bip = BookingItemPicker();
        return bip;
    }()
    
    private let employeeQuestionText: UITextView = {
        let uitv = Components().createSimpleText(text: "Does your business require that employees who are booked for a service should be working a shift during that time? (Click the help button on the bottom left and see Step 10 for more details.)");
        uitv.font = .systemFont(ofSize: 18);
        uitv.setWidth(width: fullWidth / 1.04);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    lazy var yesButton: UIButton = {
        let uib = Components().createGoodButton(title: "Yes");
        uib.addTarget(self, action: #selector(yes), for: .touchUpInside);
        uib.setHeight(height: 48);
        uib.setWidth(width: 90);
        return uib;
    }()
    
    lazy var noButton: UIButton = {
        let uib = Components().createGoodButton(title: "No");
        uib.setWidth(width: 108);
        uib.setHeight(height: 55);
        uib.addTarget(self, action: #selector(no), for: .touchUpInside);
        return uib;
    }()
    
    @objc func yes() {
        yesButton.backgroundColor = .darkGray;
        yesButton.tintColor = .white;
        noButton.tintColor = .black;
        noButton.backgroundColor = .white;
        self.eq = "y";
    }
    
    @objc func no() {
        noButton.backgroundColor = .darkGray;
        noButton.tintColor = .white;
        yesButton.tintColor = .black;
        yesButton.backgroundColor = .white;
        self.eq = "n";
    }
    
    func getBookingColumnType() -> String? {
        return bookingThingTextField.text;
    }
    
    func getBookingColumnNumber() -> String? {
        return bookingItemPicker.selected;
    }
    
    func configureView() {
        addSubview(bookingThingText);
        bookingThingText.padTop(from: topAnchor, num: 10);
        bookingThingText.centerTo(element: centerXAnchor);
        
        addSubview(bookingThingInput);
        bookingThingInput.padTop(from: bookingThingText.bottomAnchor, num: 6);
        bookingThingInput.centerTo(element: centerXAnchor);
        
        addSubview(bookingThingNumberText);
        bookingThingNumberText.padTop(from: bookingThingInput.bottomAnchor, num: 30);
        bookingThingNumberText.centerTo(element: centerXAnchor);
        
        addSubview(bookingItemPicker);
        bookingItemPicker.padTop(from: bookingThingNumberText.bottomAnchor, num: 4);
        bookingItemPicker.centerTo(element: centerXAnchor);
        bookingItemPicker.setHeight(height: 90);
        bookingItemPicker.setWidth(width: 130);
        
        addSubview(employeeQuestionText);
        employeeQuestionText.padTop(from: bookingItemPicker.bottomAnchor, num: 10);
        employeeQuestionText.centerTo(element: centerXAnchor);
        
        addSubview(yesButton);
        yesButton.padLeft(from: leftAnchor, num: fullWidth / 4);
        yesButton.padTop(from: employeeQuestionText.bottomAnchor, num: 8);
        
        addSubview(noButton);
        noButton.padRight(from: rightAnchor, num: fullWidth / 4);
        noButton.padTop(from: employeeQuestionText.bottomAnchor, num: 8);
        
    }
}
