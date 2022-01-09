//
//  AdminEmployeePerformanceCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/2/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class AdminEmployeePerformanceCell: UITableViewCell {
    
    var data: [String: Any]? {
        didSet {
            employeeName.text = data!["employeeName"] as? String;
            totalServicesIncomeAmount.text = data!["employeeEarnings"] as? String;
            amountPerDay.text = data!["realAmountPerDay"] as? String;
            
        }
    }
    
    private let employeeName = Components().createSimpleText(text: "")
    
    private let totalServicesIncomeText = Components().createLittleText(text: "Total Service Amount:");
    
    private let totalServicesIncomeAmount = Components().createSimpleText(text: "");
    
    
    private let amountPerDayText = Components().createLittleText(text: "Service $ Per Day:");
    
    private let amountPerDay = Components().createSimpleText(text: "");
    
    
    
    private let productsSoldText = Components().createLittleText(text: "Total Product Amount:");
    
    private let productsSoldAmount = Components().createSimpleText(text: "");
    
    
    private let productSoldPerDayText = Components().createLittleText(text: "Product $ Per Day:");
    
    private let productSoldPerDayAmount = Components().createSimpleText(text: "");
 
    
    func configureCell() {
        backgroundColor = .mainLav;
        contentView.addSubview(employeeName);
        employeeName.centerTo(element: contentView.centerXAnchor);
        employeeName.padTop(from: contentView.topAnchor, num: 4);
        createLittleStack(text: totalServicesIncomeText, amount: totalServicesIncomeAmount, left: true, secondLevel: false);
        createLittleStack(text: amountPerDayText, amount: amountPerDay, left: false, secondLevel: false);
        createLittleStack(text: productsSoldText, amount: productsSoldAmount, left: true, secondLevel: true);
        createLittleStack(text: productSoldPerDayText, amount: productSoldPerDayAmount, left: false, secondLevel: true);
    }
    
    func createLittleStack(text: UITextView, amount: UITextView, left: Bool, secondLevel: Bool) {
        let border = Components().createBorder(height: 1, width: fullWidth / 2.7, color: .black);
        let stack = UIStackView(arrangedSubviews: [text, border, amount]);
        stack.alignment = .center;
        amount.setWidth(width: fullWidth / 2.7);
        amount.textAlignment = .center;
        text.setWidth(width: fullWidth / 2.3 );
        text.textAlignment = .center;
        stack.setHeight(height: 70);
        stack.setWidth(width: fullWidth / 2);
        stack.axis = .vertical;
        contentView.addSubview(stack);
        if !secondLevel {
            stack.padTop(from: employeeName.bottomAnchor, num: 8);
        }
        else {
            stack.padBottom(from: contentView.bottomAnchor, num: 12);
        }
        if left {
            stack.padLeft(from: contentView.leftAnchor, num: 0);
        }
        else {
            stack.padRight(from: contentView.rightAnchor, num: 0);
        }
    }
    
}
