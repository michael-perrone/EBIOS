//
//  Payroll Directions.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/12/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//


import UIKit

class PayrollDirections: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.addSubview(header);
        header.padTop(from: view.topAnchor, num: 20);
        header.centerTo(element: view.centerXAnchor);
        view.addSubview(xButton);
        xButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside);
        xButton.padRight(from: view.rightAnchor, num: 10);
        xButton.padTop(from: view.topAnchor, num: 10);
        view.addSubview(stepOne);
        stepOne.setWidth(width: view.frame.width / 1.2);
        stepOne.padTop(from: header.bottomAnchor, num: 20)
        stepOne.centerTo(element: view.centerXAnchor);
        view.backgroundColor = .mainLav;
    }
    
    @objc func dismissMe() {
        self.dismiss(animated: true, completion: nil);
    }
    
    private let xButton = Components().createXButton();
    
    private let header: UITextView = {
        let uitv = Components().createNotAsLittleText(text: "Payroll Setup Directions", color: .mainLav);
        uitv.font = .boldSystemFont(ofSize: 20);
        return uitv;
    }();
    
    private let stepOne = Components().createNotAsLittleText(text: "Welcome to the payroll suite setup. Here you will be able to setup how you would like your payroll to be conducted. To start, you will select each employee and enter if they are paid hourly, by comission, or both. If they are paid hourly, you will be asked to input their hourly wage. If they are paid by comission, you will be asked to input the percentage of comission they make off each service and product. You can come back at anytime and change this information. Please remember to save each employees information hitting the save button at the bottom of the payroll setup page. After you are done entering all of your employees information hit the finish up button below to enter some final details about how you would like your payroll to be conducted.", color: .mainLav);
    
}
