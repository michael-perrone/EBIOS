//
//  PayrollViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/12/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class PayrollViewController: UIViewController {
    
    private var dateOne: String? {
        didSet {
            getPayrollInfo()
        }
    }
    private var dateTwo: String? {
        didSet {
            getPayrollInfo();
        }
    }
    
    private let payrollCollection = PayrollCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout());
    
    private let xButton: UIButton = {
        let x = Components().createXButton();
        x.addTarget(self, action: #selector(xOut), for: .touchUpInside);
        return x;
    }()
    
    @objc func xOut() {
        self.dismiss(animated: true, completion: nil);
    }
    
    private let headerText = Components().createNotAsLittleText(text: "Payroll Suite", color: .mainLav);
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        getStringDateOne();
        getStringDateTwo();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = .mainLav;
        config();
    }
    
    private let datePickerOne: MyDatePicker = {
        let dp = MyDatePicker();
        dp.addTarget(self, action: #selector(dateChangedOne), for: .valueChanged);
        return dp;
    }();
    
    @objc func dateChangedOne() {
        getStringDateOne()
    }
    
    func getBoth() {
        
    }
    
    func getStringDateOne() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        self.dateOne = df.string(from: datePickerOne.date);
    }
    
    private let datePickerTwo: MyDatePicker = {
        let dp = MyDatePicker();
        dp.addTarget(self, action: #selector(dateChangedTwo), for: .valueChanged);
        return dp;
    }();
    
    @objc func dateChangedTwo() {
        getStringDateTwo()
    }
    
    func getStringDateTwo() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        self.dateTwo = df.string(from: datePickerTwo.date);
    }
    
    
    private let startText = Components().createNotAsLittleText(text: "Start:", color: .mainLav);
    
    private let endText = Components().createNotAsLittleText(text: "End:", color: .mainLav);
    
    
    func config() {
        view.addSubview(xButton);
        xButton.padRight(from: view.rightAnchor, num: 10);
        xButton.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 0);
        view.addSubview(headerText);
        headerText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 0);
        headerText.centerTo(element: view.centerXAnchor);
        view.addSubview(startText);
        startText.padTop(from: headerText.bottomAnchor, num: 8);
        startText.padLeft(from: view.leftAnchor, num: fullWidth * 0.22);
        view.addSubview(datePickerOne);
        datePickerOne.padTop(from: startText.bottomAnchor, num: 6);
        datePickerOne.centerTo(element: startText.centerXAnchor);
        view.addSubview(endText);
        endText.padRight(from: view.rightAnchor, num: fullWidth * 0.22);
        endText.padTop(from: headerText.bottomAnchor, num: 8);
        view.addSubview(datePickerTwo);
        datePickerTwo.padTop(from: endText.bottomAnchor, num: 6);
        datePickerTwo.centerTo(element: endText.centerXAnchor);
        view.addSubview(payrollCollection);
        payrollCollection.padTop(from: datePickerTwo.bottomAnchor, num: 20);
        payrollCollection.padLeft(from: view.leftAnchor, num: 0);
        payrollCollection.padRight(from: view.rightAnchor, num: 0);
        payrollCollection.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 0);
    }
    
    func getPayrollInfo() {
        API().post(url: myURL + "payroll/getPayrollInfo", headerToSend: Utilities().getAdminToken(), dataToSend: ["startDate": dateOne, "endDate": dateTwo ]) { res in
            if let payrollNums = res["payrollNums"] as? [[String: String]] {
                print(payrollNums)
                var payrollNumsArray: [PayrollNumbers] = [];
                for payrollNum in payrollNums {
                    let newPayrollNums = PayrollNumbers(dic: payrollNum);
                    payrollNumsArray.append(newPayrollNums);
                }
                self.payrollCollection.payrollNums = payrollNumsArray;
            }
        }
    }
    
 
}
