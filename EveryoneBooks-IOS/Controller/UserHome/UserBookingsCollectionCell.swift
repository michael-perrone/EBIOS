//
//  UserBookingsCollectionCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/26/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class UserBookingsCollectionCell: UICollectionViewCell {
    
    var booking: Booking? {
        didSet {
            servicesTable.servicesChosen = self.booking?.serviceNames;
            timeText.text = "Time: " + self.booking!.time!;
            businessText.text = "At: " + self.booking!.businessName!;
            dateText.text = "Date: " + self.booking!.date!;
            if let employeeName = self.booking!.employeeName {
                employeeNameText.text = "With: " +  employeeName;
            }
            else {
                employeeNameText.text = "Employee: None";
            }
            costText.text = "Cost: " + self.booking!.cost!;
        }
    }
    
    var row: Int?;
    
    private let servicesText = Components().createLittleText(text: "Services");
    
    private let servicesTable: ServicesChosenTable = {
        let sct = ServicesChosenTable();
        sct.backgroundColor = .mainLav;
        sct.fontSize = 14;
        return sct;
    }()
    
    
    weak var cancelDelegate: UserBookingCancel?;
    
    private let timeText = Components().createLittleText(text: "");
    
    private let businessText = Components().createLittleText(text: "");
    
    private let dateText = Components().createLittleText(text: "");
    
    private let employeeNameText = Components().createLittleText(text: "")
    
    private let costText = Components().createLittleText(text: "");
    
  
    
    lazy var cancelButton: UIButton = {
        let uib = Components().createNormalButton(title: "Cancel");
        uib.setWidth(width: 120);
        uib.setHeight(height: 44);
        uib.backgroundColor = .bookedRed;
        uib.tintColor = .black;
        uib.showsTouchWhenHighlighted = true;
        uib.addTarget(self, action: #selector(cancelBooking), for: .touchUpInside)
        return uib;
    }()

    @objc func cancelBooking() {
        print("hello")
        cancelDelegate?.cancelBooking(booking: self.booking!, row: row!);
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
        addSubview(servicesTable);
        servicesTable.padRight(from: rightAnchor, num: 5);
        servicesTable.padTop(from: topAnchor, num: 40);
        servicesTable.setHeight(height: 140);
        servicesTable.setWidth(width: fullWidth / 2.1);
        addSubview(cancelButton);
        cancelButton.padBottom(from: costText.bottomAnchor, num: 0);
        cancelButton.padRight(from: servicesTable.rightAnchor, num: 30);
        addSubview(servicesText);
        servicesText.centerTo(element: servicesTable.centerXAnchor);
        servicesText.padTop(from: topAnchor, num: 3);
    }
    
}
