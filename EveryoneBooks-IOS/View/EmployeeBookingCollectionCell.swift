//
//  EmployeeBookingCollectionCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/6/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeeBookingCollectionCell: UICollectionViewCell {

    var booking: Booking? {
        didSet {
            print("shoudl work");
            print(self.booking)
            self.servicesTable.services = self.booking?.serviceNames;
            timeText.text! = self.booking!.time!;
            cName.text! = self.booking!.cName!;
            costText.text! = self.booking!.cost!;
        }
    }
    
    var delegate: EmployeeBookingCellProtocol?
    
    var bct: String? {
        didSet {
            if let booking = booking {
                bctnText.text = bct! + " " + booking.bcn!
            }
        }
    }
    
    private let servicesText: UITextView = {
        let uitv = Components().createLittleText(text: "Services Included:");
        return uitv;
    }();
    
    private let border = Components().createBorder(height: 0.8, width: 160, color: .black);
    
    private let servicesTable = ServicesTextTable();
    
    private let timeText = Components().createLittleText(text: "");
    
    private let bctnText = Components().createLittleText(text: "");
    
    private let bigBorder = Components().createBorder(height: 1.4, width: fullWidth, color: .black);
    
    private let cName = Components().createLittleText(text: "");
    
    private let costText = Components().createLittleText(text: "");
    
    lazy var editButton: UIButton = {
        let uib = Components().createAlternateButton(title: "Edit");
        uib.backgroundColor = .darkGray;
        uib.tintColor = .mainLav;
        uib.setWidth(width: 100);
        uib.setHeight(height: 38);
        uib.showsTouchWhenHighlighted = true;
        uib.addTarget(self, action: #selector(editMe), for: .touchUpInside);
        return uib;
    }()
    
    @objc func editMe() {
        delegate?.goToBooking(booking: booking!);
    }
    
    func configureCell() {
        contentView.addSubview(servicesText);
        servicesText.padTop(from: contentView.topAnchor, num: 10);
        servicesText.padLeft(from: contentView.leftAnchor, num: 30);
        contentView.addSubview(border);
        border.padTop(from: servicesText.bottomAnchor, num: 0);
        border.padLeft(from: contentView.leftAnchor, num: 16);
        contentView.addSubview(servicesTable);
        servicesTable.padTop(from: servicesText.bottomAnchor, num: 10);
        servicesTable.padLeft(from: contentView.leftAnchor, num: 0);
        servicesTable.setHeight(height: 180);
        servicesTable.setWidth(width: fullWidth / 1.9);
        contentView.addSubview(timeText);
        timeText.padTop(from: contentView.topAnchor, num: 10);
        timeText.padRight(from: contentView.rightAnchor, num: 8);
        contentView.addSubview(bctnText);
        bctnText.padTop(from: timeText.bottomAnchor, num: 10);
        bctnText.padRight(from: contentView.rightAnchor, num: 8);
        contentView.addSubview(bigBorder);
        bigBorder.padBottom(from: contentView.bottomAnchor, num: 0);
        bigBorder.centerTo(element: contentView.centerXAnchor);
        contentView.addSubview(cName);
        cName.padTop(from: bctnText.bottomAnchor, num: 8);
        cName.padRight(from: contentView.rightAnchor, num: 8);
        contentView.addSubview(costText);
        costText.padTop(from: cName.bottomAnchor, num: 8);
        costText.padRight(from: contentView.rightAnchor, num: 8);
        contentView.addSubview(editButton);
        editButton.padBottom(from: servicesTable.bottomAnchor, num: 0);
        editButton.padRight(from: contentView.rightAnchor, num: 8);
    }
}
