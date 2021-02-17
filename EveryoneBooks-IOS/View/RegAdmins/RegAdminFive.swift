//
//  RegAdminFive.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/27/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegAdminFive: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame);
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let weekendText: UITextView = {
        let uitv = Components().createSimpleText(text: "Enter Weekend Open/Close");
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let saturdayRow: DayRow = {
        let dayRow = DayRow(dayName: "Sat:")
        return dayRow;
    }()
    
    private let sundayRow: DayRow = {
        let dayRow = DayRow(dayName: "Sun:");
        return dayRow;
    }()
    
    func getSatOpen() -> String {
        return saturdayRow.getOpen();
    }
    
    func getSatClose() -> String {
        return saturdayRow.getClose();
    }
    
    func getSunOpen() -> String {
        return sundayRow.getOpen();
    }
    
    func getSunClose() -> String {
        return sundayRow.getClose();
    }
    
    func configureView() {
        backgroundColor = .mainLav;
        
        addSubview(weekendText);
        weekendText.padTop(from: topAnchor, num: 10);
        weekendText.centerTo(element: centerXAnchor);
        
        addSubview(saturdayRow);
        saturdayRow.padTop(from: weekendText.bottomAnchor, num: 20);
        saturdayRow.centerTo(element: centerXAnchor);
        
        addSubview(sundayRow);
        sundayRow.padTop(from: saturdayRow.bottomAnchor, num: 20);
        sundayRow.centerTo(element: centerXAnchor);

    }
}
