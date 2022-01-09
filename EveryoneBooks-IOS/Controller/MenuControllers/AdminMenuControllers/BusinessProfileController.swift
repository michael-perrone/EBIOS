//
//  BusinessProfileController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/15/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class BusinessProfileController: UIViewController {

    private let businessNameEditText = EditableText(topText: "Business Name", showEditButton: false);
    private let businessAddressEditText = EditableText(topText: "Business Address", showEditButton: false);
    private let businessCityEditText = EditableText(topText: "Business City", showEditButton: false);
    private let businessStateEditText = EditableText(topText: "Business State", showEditButton: false);
    private let businessZipEditText = EditableText(topText: "Business Zip", showEditButton: false);
    
    private let businessProfileTextView: UIView = {
        let uiv = UIView();
        let uitv = UITextView();
        uiv.setHeight(height: 80);
        uiv.setWidth(width: fullWidth);
        uiv.backgroundColor = .mainLav;
        uitv.text = "Business Profile";
        uitv.font = .systemFont(ofSize: 26);
        uitv.isScrollEnabled = false;
        uitv.isEditable = false;
        let border = Components().createBorder(height: 1.0, width: fullWidth, color: .black);
        uiv.addSubview(border);
        border.padBottom(from: uiv.bottomAnchor, num: 1);
        border.centerTo(element: uiv.centerXAnchor);
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
    
    private let editBusinessButton: UIButton = {
        let uib = Components().createNormalButton(title: "Edit Business Profile")
        uib.setHeight(height: 45);
        uib.setWidth(width: fullWidth / 1.3);
        uib.titleLabel?.font = .boldSystemFont(ofSize: 26);
        uib.addTarget(self, action: #selector(editBusiness), for: .touchUpInside);
        return uib;
    }()
    
    @objc func editBusiness() {
        let editBusiness = EditBusinessProfile();
        editBusiness.modalPresentationStyle = .fullScreen;
        self.present(editBusiness, animated: true, completion: nil);
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainLav;
        configureView()
        getOriginalInfo();
    }
    
    func configureView() {
        let stack = UIStackView()
        stack.setHeight(height: fullHeight / 2);
        [businessNameEditText, businessAddressEditText, businessCityEditText, businessStateEditText, businessZipEditText].forEach { (editableText) in
            stack.addArrangedSubview(editableText)
        }
        view.addSubview(businessProfileTextView);
        businessProfileTextView.padTop(from: view.topAnchor, num: 20);
        businessProfileTextView.centerTo(element: view.centerXAnchor);
        stack.distribution = .equalSpacing;
        stack.setWidth(width: fullWidth);
        stack.axis = .vertical;
        view.addSubview(stack);
        stack.padTop(from: businessProfileTextView.bottomAnchor, num: 16);
        stack.padLeft(from: view.leftAnchor, num: 0);
        view.addSubview(editBusinessButton);
        editBusinessButton.padTop(from: stack.bottomAnchor, num: 20);
        editBusinessButton.centerTo(element: view.centerXAnchor);
    }
    
    func getOriginalInfo() {
        API().get(url: myURL + "business", headerToSend: Utilities().getAdminToken()) { (res) in
            if res["statusCode"] as! Int == 200 {
                let business = res["business"] as? [String: Any];
                self.businessNameEditText.setText(text: business!["businessName"] as! String);
                self.businessAddressEditText.setText(text: business!["address"] as! String);
                self.businessCityEditText.setText(text: business!["city"] as! String);
                self.businessZipEditText.setText(text: business!["zip"] as! String);
                self.businessStateEditText.setText(text: business!["state"] as! String);
            }
        }
    }



}
