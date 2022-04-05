//
//  UserGroupsCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 3/21/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.

import UIKit

class UserGroupsCell: UICollectionViewCell {
    
    var group: Group? {
        didSet {
            customersTable.servicesChosen = self.group?.customerNames;
            timeText.text = "Time: " + self.group!.time!;
            businessText.text = "At: " + self.group!.businessName!;
            dateText.text = "Date: " + self.group!.date!;
            if let employeeName = self.group!.employeeName {
                employeeNameText.text = "With: " +  employeeName;
            }
            else {
                employeeNameText.text = "Employee: None";
            }
            costText.text = "Cost: " + self.group!.price!;
        }
    }
    
    var row: Int?;
    
    private let customersText = Components().createLittleText(text: "Group Members");
    
    private let customersTable: ServicesChosenTable = {
        let sct = ServicesChosenTable();
        sct.backgroundColor = .mainLav;
        sct.fontSize = 14;
        return sct;
    }()
    
    
    weak var leaveDelegate: LeaveGroupDelegate?;
    
    private let timeText = Components().createLittleText(text: "");
    
    private let businessText = Components().createLittleText(text: "");
    
    private let dateText = Components().createLittleText(text: "");
    
    private let employeeNameText = Components().createLittleText(text: "")
    
    private let costText = Components().createLittleText(text: "");
    
  
    
    lazy var leaveButton: UIButton = {
        let uib = Components().createNormalButton(title: "Leave");
        uib.setWidth(width: 120);
        uib.setHeight(height: 44);
        uib.backgroundColor = .bookedRed;
        uib.tintColor = .black;
        uib.showsTouchWhenHighlighted = true;
        uib.addTarget(self, action: #selector(leaveGroup), for: .touchUpInside)
        return uib;
    }()

    @objc func leaveGroup() {
        leaveDelegate?.leaveGroup(group: group!, row: row!);
    }
    
    func configureCell() {
        addSubview(dateText);
        dateText.padLeft(from: leftAnchor, num: 8);
        dateText.padTop(from: topAnchor, num: 8);
        addSubview(businessText);
        businessText.padLeft(from: leftAnchor, num: 8);
        businessText.padTop(from: dateText.bottomAnchor, num: 20);
        businessText.setWidth(width: fullWidth / 2.1);
        addSubview(timeText);
        timeText.padLeft(from: leftAnchor, num: 8);
        timeText.padTop(from: businessText.bottomAnchor, num: 20);
        addSubview(employeeNameText);
        employeeNameText.padTop(from: timeText.bottomAnchor, num: 20);
        employeeNameText.padLeft(from: leftAnchor, num: 8);
        employeeNameText.setWidth(width: fullWidth / 2.1);
        addSubview(costText);
        costText.padTop(from: employeeNameText.bottomAnchor, num: 20);
        costText.padLeft(from: leftAnchor, num: 8);
        let border = UIView();
        border.setHeight(height: 1);
        border.setWidth(width: UIScreen.main.bounds.width);
        border.backgroundColor = .gray;
        addSubview(border);
        border.padBottom(from: bottomAnchor, num: 0);
        border.centerTo(element: centerXAnchor);
        addSubview(customersTable);
        customersTable.padRight(from: rightAnchor, num: 5);
        customersTable.padTop(from: topAnchor, num: 40);
        customersTable.setHeight(height: 140);
        customersTable.setWidth(width: fullWidth / 2.1);
        addSubview(leaveButton);
        leaveButton.padBottom(from: costText.bottomAnchor, num: 0);
        leaveButton.padRight(from: customersTable.rightAnchor, num: 30);
        addSubview(customersText);
        customersText.centerTo(element: customersTable.centerXAnchor);
        customersText.padTop(from: topAnchor, num: 3);
    }
    
}
