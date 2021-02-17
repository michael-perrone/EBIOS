//
//  EmployeeBusinessSearchCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 8/1/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeeBusinessSearchCell: UICollectionViewCell {
    
    var bID: String?;
    
    var index_: Int?
    
    weak var delegate: EmployeeBusinessSearchCollection?;
    
    
    override init(frame: CGRect) {
        super.init(frame:frame);
        backgroundColor = .literGray;
        configureView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    var businessName: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 22);
        return uitv;
    }();
    
    var streetText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 16);
        return uitv;
    }()
    
    var cityText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 16);
        return uitv;
    }()
    
    var stateText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 16);
        return uitv;
    }()
    
    var zipText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 16);
        return uitv;
    }()
    
   lazy var sendIDButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.backgroundColor = .darkGray;
        uib.tintColor = .mainLav;
        uib.setTitle("Send ID To This Business", for: .normal);
        uib.layer.borderColor = CGColor.CGBlack;
        uib.layer.cornerRadius = 6;
        uib.layer.borderWidth = 1.0;
        uib.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18);
        uib.setWidth(width: UIScreen.main.bounds.width / 1.5);
        uib.showsTouchWhenHighlighted = true;
        uib.addTarget(self, action: #selector(sendIdToBusiness), for: .touchUpInside)
        return uib;
    }()
    
    @objc func sendIdToBusiness() {
        delegate?.sendID(bpId: self.bID!)
    }
    
    private let borderBottom: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: 0.8);
        uiv.setWidth(width: UIScreen.main.bounds.width);
        uiv.backgroundColor = .gray;
        return uiv;
    }()
    
    func configureView() {
        addSubview(businessName);
        businessName.centerTo(element: centerXAnchor);
        businessName.padTop(from: topAnchor, num: 0);
        addSubview(streetText);
        streetText.padTop(from: businessName.bottomAnchor, num: -2);
        streetText.padLeft(from: leftAnchor, num: 14);
        addSubview(cityText);
        cityText.padTop(from: streetText.bottomAnchor, num: -2);
        cityText.padLeft(from: leftAnchor, num: 14);
        addSubview(stateText);
        stateText.padTop(from: businessName.bottomAnchor, num: -2);
        stateText.padRight(from: rightAnchor, num: 14);
        addSubview(zipText);
        zipText.padRight(from: rightAnchor, num: 14);
        zipText.padTop(from: stateText.bottomAnchor, num: -2);
        addSubview(borderBottom);
        borderBottom.padBottom(from: bottomAnchor, num: 0);
        borderBottom.centerTo(element: centerXAnchor);
        addSubview(sendIDButton);
        sendIDButton.centerTo(element: centerXAnchor);
        sendIDButton.padBottom(from: borderBottom.topAnchor, num: 10)
    }
    
}
