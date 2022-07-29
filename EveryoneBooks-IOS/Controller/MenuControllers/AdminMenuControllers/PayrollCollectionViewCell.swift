//
//  PayrollCollectionViewCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/15/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class PayrollCollectionViewCell: UICollectionViewCell {
    
    var payrollNums: PayrollNumbers? {
        didSet {
            employeeNameTextField.text = payrollNums?.employeeName;
            salaryText.text = payrollNums?.salaryNum;
            hourlyText.text = payrollNums?.hourlyNum;
            serviceCommissionText.text = payrollNums?.serviceCommissionNum;
            productCommissionText.text = payrollNums?.productCommissionNum;
        
        }
    }
    
    private let employeeNameDisplayText = Components().createNotAsLittleText(text: "Employee:", color: .mainLav);
    
    private let employeeNameTextField = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    private let employeeBorder = Components().createBorder(height: 2, width: fullWidth * 0.3, color: .black);
    
    private let salaryDisplayText = Components().createNotAsLittleText(text: "Salary Earned:", color: .mainLav);
    
    private let salaryBorder = Components().createBorder(height: 2, width: fullWidth * 0.3, color: .black);
    
    private let salaryText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    private let hourlyDisplayText = Components().createNotAsLittleText(text: "Hourly Earned:", color: .mainLav);
    
    private let hourlyBorder = Components().createBorder(height: 2, width: fullWidth * 0.3, color: .black);
    
    private let hourlyText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    private let serviceCommissionDisplayText = Components().createNotAsLittleText(text: "Service Commission:", color: .mainLav);
    
    private let serviceCommissionBorder = Components().createBorder(height: 2, width: fullWidth * 0.44, color: .black);
    
    private let serviceCommissionText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    private let productCommissionDisplayText = Components().createNotAsLittleText(text: "Product Commission:", color: .mainLav);
    
    private let productCommissionBorder = Components().createBorder(height: 2, width: fullWidth * 0.44, color: .black);
    
    private let productCommissionText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    private let bottomBorder = Components().createBorder(height: 0.75, width: fullWidth, color: .gray);
    
    
    func config() {
        contentView.addSubview(employeeBorder);
        employeeBorder.padTop(from: contentView.topAnchor, num: 50);
        employeeBorder.padLeft(from: contentView.leftAnchor, num: fullWidth * 0.02);
        contentView.addSubview(employeeNameDisplayText);
        employeeNameDisplayText.padBottom(from: employeeBorder.topAnchor, num: 0);
        employeeNameDisplayText.centerTo(element: employeeBorder.centerXAnchor);
        contentView.addSubview(employeeNameTextField);
        employeeNameTextField.padTop(from: employeeBorder.bottomAnchor, num: 0);
        employeeNameTextField.centerTo(element: employeeBorder.centerXAnchor);
        contentView.addSubview(salaryBorder);
        salaryBorder.padTop(from: employeeBorder.topAnchor, num: 0);
        salaryBorder.padLeft(from: employeeBorder.rightAnchor, num: fullWidth * 0.03);
        contentView.addSubview(salaryDisplayText);
        salaryDisplayText.padBottom(from: salaryBorder.topAnchor, num: 0);
        salaryDisplayText.centerTo(element: salaryBorder.centerXAnchor);
        contentView.addSubview(salaryText);
        salaryText.padTop(from: salaryBorder.bottomAnchor, num: 0);
        salaryText.centerTo(element: salaryBorder.centerXAnchor);
        contentView.addSubview(hourlyBorder);
        hourlyBorder.padTop(from: salaryBorder.topAnchor, num: 0);
        hourlyBorder.padLeft(from: salaryBorder.rightAnchor, num: fullWidth * 0.03);
        contentView.addSubview(hourlyDisplayText);
        hourlyDisplayText.padBottom(from: hourlyBorder.topAnchor, num: 0);
        hourlyDisplayText.centerTo(element: hourlyBorder.centerXAnchor);
        contentView.addSubview(hourlyText);
        hourlyText.padTop(from: hourlyBorder.bottomAnchor, num: 0);
        hourlyText.centerTo(element: hourlyBorder.centerXAnchor);
        contentView.addSubview(serviceCommissionBorder);
        serviceCommissionBorder.padBottom(from: contentView.bottomAnchor, num: 60);
        serviceCommissionBorder.padLeft(from: contentView.leftAnchor, num: fullWidth * 0.02);
        contentView.addSubview(serviceCommissionDisplayText);
        serviceCommissionDisplayText.padBottom(from: serviceCommissionBorder.topAnchor, num: 0);
        serviceCommissionDisplayText.centerTo(element: serviceCommissionBorder.centerXAnchor);
        contentView.addSubview(serviceCommissionText);
        serviceCommissionText.padTop(from: serviceCommissionBorder.bottomAnchor, num: 0);
        serviceCommissionText.centerTo(element: serviceCommissionBorder.centerXAnchor);
        contentView.addSubview(productCommissionBorder);
        productCommissionBorder.padBottom(from: contentView.bottomAnchor, num: 60);
        productCommissionBorder.padRight(from: contentView.rightAnchor, num: fullWidth * 0.02);
        contentView.addSubview(productCommissionDisplayText);
        productCommissionDisplayText.padBottom(from: productCommissionBorder.topAnchor, num: 0);
        productCommissionDisplayText.centerTo(element: productCommissionBorder.centerXAnchor);
        contentView.addSubview(productCommissionText);
        productCommissionText.padTop(from: productCommissionBorder.bottomAnchor, num: 0);
        productCommissionText.centerTo(element: productCommissionBorder.centerXAnchor);
        contentView.addSubview(bottomBorder);
        bottomBorder.padBottom(from: contentView.bottomAnchor, num: 0);
        bottomBorder.centerTo(element: contentView.centerXAnchor);
    }
}
