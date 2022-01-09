//
//  EmployeePerformanceViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/17/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class AdminEmployeePerformanceViewController: UIViewController {
    
    private var startDay: String = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy";
        return df.string(from: Date());
    }()
    
    private var performanceData: [[String:Any]]? {
        didSet {
            performanceTableView.performanceData = self.performanceData;
        }
    }
    
    private var endDay: String = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy";
        return df.string(from: Date());
    }()
    
    private let sep = Components().createBorder(height: 1, width: fullWidth, color: .black);
    
    private let performanceTableView: EmployeePerformanceTableView = {
        let uicv = EmployeePerformanceTableView();
        return uicv;
    }()
    
    private let employeePerformanceTextView: UIView = {
        let uiv = UIView();
        let uitv = UITextView();
        uiv.setHeight(height: 80);
        uiv.setWidth(width: fullWidth);
        uiv.backgroundColor = .mainLav;
        uitv.text = "Employee Performance";
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
    
    let startText = Components().createLittleText(text: "Start Range:")
    
    let startDayPicker: UIDatePicker = {
        let uidp = UIDatePicker();
        uidp.addTarget(self, action: #selector(startChanged), for: .valueChanged);
        uidp.datePickerMode = .date;
        uidp.setHeight(height: 50)
        return uidp;
    }();
    
    @objc func startChanged() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyy";
        self.startDay = df.string(from: startDayPicker.date);
        configureEP()
    }
    
    let endText = Components().createLittleText(text: "End Range:")
    
    let endDayPicker: UIDatePicker = {
        let uidp = UIDatePicker();
        uidp.addTarget(self, action: #selector(endChanged), for: .valueChanged);
        uidp.datePickerMode = .date;
        uidp.setHeight(height: 50);
        return uidp;
    }();
    
    @objc func endChanged() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyy";
        self.endDay = df.string(from: endDayPicker.date);
        configureEP()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        configureEP()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        view.backgroundColor = .mainLav;
        view.addSubview(employeePerformanceTextView);
        employeePerformanceTextView.padTop(from: view.topAnchor, num: 10);
        employeePerformanceTextView.centerTo(element: view.centerXAnchor);
        view.addSubview(startText);
        startText.padLeft(from: view.leftAnchor, num: 20);
        startText.padTop(from: employeePerformanceTextView.bottomAnchor, num: 10)
        view.addSubview(startDayPicker);
        startDayPicker.padTop(from: startText.bottomAnchor, num: 5);
        startDayPicker.padLeft(from: view.leftAnchor, num: 20);
        view.addSubview(endText);
        endText.padRight(from: view.rightAnchor, num: 20);
        endText.padTop(from: startText.topAnchor, num: 0);
        view.addSubview(endDayPicker);
        endDayPicker.padTop(from: startDayPicker.topAnchor, num: 0);
        endDayPicker.padRight(from: view.rightAnchor, num: 20);
        view.addSubview(performanceTableView);
        performanceTableView.padTop(from: endDayPicker.bottomAnchor, num: 20);
        performanceTableView.centerTo(element: view.centerXAnchor);
        performanceTableView.setWidth(width: fullWidth);
        if view.frame.height > 800 {
            performanceTableView.setHeight(height: view.frame.height / 1.5);
        }
        else if view.frame.height > 600 && view.frame.height < 700 {
            performanceTableView.setHeight(height: view.frame.height / 1.7);
        }
    }
    
    
    func configureEP() {
        API().post(url: myURL + "business/employeePerformance", headerToSend: Utilities().getAdminToken(), dataToSend: ["startDay": startDay, "endDay": endDay]) { (res) in
            if let data = res["data"] as? [[String: Any]] {
                self.performanceData = data;
            }
            else if let statusCode = res["statusCode"] as? Int {
                if statusCode == 409 {
                    let alert = UIAlertController(title: "Error", message: "End range date should not be before the start range date.", preferredStyle: .alert);
                    let action = UIAlertAction(title: "Woops, okay!", style: .default, handler: nil);
                    alert.addAction(action);
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
            }
        }
    }
}


