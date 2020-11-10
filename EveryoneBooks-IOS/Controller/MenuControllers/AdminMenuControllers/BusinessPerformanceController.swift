//
//  PerformanceController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/14/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class BusinessPerformanceController: UIViewController {
    
    private var moneyPerformance: String? {
        didSet {
            DispatchQueue.main.async {
                self.moneyPerformanceText.text = self.moneyPerformance;
            }
        }
    }
    
    private var servicesPerDay: String? {
        didSet {
            DispatchQueue.main.async {
                self.actualServicesPerDay.text = self.servicesPerDay;
            }
        }
    }
    
    private var incomePerDay: String? {
        didSet {
            DispatchQueue.main.async {
                self.actualIncomePerDay.text = self.incomePerDay;
            }
        }
    }
    
    private let servicesPerDayText: UITextView = {
        let uitv = Components().createSimpleText(text: "Services Per Day: ");
        uitv.font = .systemFont(ofSize: 16);
        return uitv;
    }()
    
    private let actualServicesPerDay: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        return uitv;
    }()
    
    private let incomePerDayText: UITextView = {
        let uitv = Components().createSimpleText(text: "Income Per Day: ");
        uitv.font = .systemFont(ofSize: 16);
        return uitv;
    }()
    
    private var actualIncomePerDay: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        return uitv;
    }()
    
    
    private let moneyPerformanceText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        return uitv;
    }()
    
    private var serviceCount: String? {
        didSet {
            DispatchQueue.main.async {
                self.serviceCountText.text = self.serviceCount;
            }
        }
    }
    
    private let serviceCountText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        return uitv;
    }()
    
    private var startDay: String = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy";
        return df.string(from: Date());
    }()
    
    private var endDay: String = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy";
        return df.string(from: Date());
    }()
    
    private let totalNet: UITextView = {
        let uitv = Components().createSimpleText(text: "Total Income:");
        uitv.font = .systemFont(ofSize: 16);
        return uitv;
    }()
    
    private let scrollView: UIScrollView = {
        let uisv = UIScrollView();
        uisv.contentSize = CGSize(width: fullWidth, height: 675 * 1.3);
        return uisv;
    }()
    
    private let totalNetBorder = Components().createBorder(height: 1, width: 140, color: .black);
    
    private let totalServices: UITextView = {
        let uitv = Components().createSimpleText(text: "Total Services:");
        uitv.font = .systemFont(ofSize: 16);
        return uitv;
    }()
    
    private let servicesPerDayBorder = Components().createBorder(height: 1, width: 140, color: .black);
    
    private let sep = Components().createBorder(height: 1, width: fullWidth, color: .black);
    
    private let totalServicesBorder = Components().createBorder(height: 1, width: 140, color: .black);
    
    private let incomePerDayBorder = Components().createBorder(height: 1, width: 140, color: .black);
    
    private let businessPerformanceTextView: UIView = {
        let uiv = UIView();
        let uitv = UITextView();
        uiv.setHeight(height: 80);
        uiv.setWidth(width: fullWidth);
        uiv.backgroundColor = .mainLav;
        uitv.text = "Business Performance";
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
        configureBP()
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
        configureBP()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true);
        configureBP();
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        configureView();
    }
    
    
    func configureView() {
        view.backgroundColor = .literGray;
        view.addSubview(businessPerformanceTextView);
        businessPerformanceTextView.padTop(from: view.topAnchor, num: 0);
        businessPerformanceTextView.centerTo(element: view.centerXAnchor);
        view.addSubview(startDayPicker);
        startDayPicker.padTop(from: businessPerformanceTextView.bottomAnchor, num: 40);
        startDayPicker.centerTo(element: view.centerXAnchor);
        view.addSubview(startText);
        startText.padLeft(from: startDayPicker.leftAnchor, num: 0);
        startText.padBottom(from: startDayPicker.topAnchor, num: -5)
        view.addSubview(endDayPicker);
        endDayPicker.padTop(from: startDayPicker.bottomAnchor, num: 30);
        endDayPicker.centerTo(element: view.centerXAnchor);
        view.addSubview(endText);
        endText.padLeft(from: endDayPicker.leftAnchor, num: 0);
        endText.padBottom(from: endDayPicker.topAnchor, num: -5);
        configureOtherViews();
    }
    
    func configureOtherViews() {
        view.addSubview(sep);
        sep.padTop(from: endDayPicker.bottomAnchor, num: 18);
        sep.centerTo(element: view.centerXAnchor);
        view.addSubview(scrollView);
        scrollView.padTop(from: endDayPicker.bottomAnchor, num: 20);
        scrollView.padLeft(from: view.leftAnchor, num: 0);
        scrollView.padRight(from: view.rightAnchor, num: 0);
        scrollView.padBottom(from: view.bottomAnchor, num: 0);
        scrollView.addSubview(totalNet);
        totalNet.padTop(from: scrollView.topAnchor, num: 18);
        totalNet.padLeft(from: scrollView.leftAnchor, num: fullWidth / 12);
        scrollView.addSubview(totalNetBorder)
        totalNetBorder.padLeft(from: scrollView.leftAnchor, num: fullWidth / 14);
        totalNetBorder.padTop(from: totalNet.bottomAnchor, num: 0);
        scrollView.addSubview(totalServices);
        totalServices.padTop(from: scrollView.topAnchor, num: 18);
        totalServices.padRight(from: view.rightAnchor, num: 36);
        scrollView.addSubview(totalServicesBorder);
        totalServicesBorder.padRight(from: view.rightAnchor, num: 30);
        totalServicesBorder.padTop(from: totalServices.bottomAnchor, num: 0);
        scrollView.addSubview(moneyPerformanceText);
        moneyPerformanceText.padTop(from: totalNetBorder.bottomAnchor, num: 0);
        moneyPerformanceText.padLeft(from: totalNet.leftAnchor, num: 0);
        scrollView.addSubview(serviceCountText)
        serviceCountText.padTop(from: totalServicesBorder.bottomAnchor, num: 0);
        serviceCountText.padLeft(from: totalServices.leftAnchor, num: 0);
        scrollView.addSubview(servicesPerDayText);
        servicesPerDayText.padTop(from: serviceCountText.bottomAnchor, num: 6);
        servicesPerDayText.padLeft(from: totalNet.leftAnchor, num: 0);
        scrollView.addSubview(servicesPerDayBorder);
        servicesPerDayBorder.padLeft(from: scrollView.leftAnchor, num: 30);
        servicesPerDayBorder.padTop(from: servicesPerDayText.bottomAnchor, num: 0);
        scrollView.addSubview(actualServicesPerDay);
        actualServicesPerDay.padLeft(from: servicesPerDayText.leftAnchor, num: 0)
        actualServicesPerDay.padTop(from: servicesPerDayText.bottomAnchor, num: 1);
        scrollView.addSubview(incomePerDayText);
        incomePerDayText.padRight(from: view.rightAnchor, num: 30);
        incomePerDayText.padTop(from: serviceCountText.bottomAnchor, num: 6);
        scrollView.addSubview(incomePerDayBorder);
        incomePerDayBorder.padRight(from: view.rightAnchor, num: 30);
        incomePerDayBorder.padTop(from: incomePerDayText.bottomAnchor, num: 1);
        scrollView.addSubview(actualIncomePerDay);
        actualIncomePerDay.padLeft(from: incomePerDayText.leftAnchor, num: 0);
        actualIncomePerDay.padTop(from: incomePerDayBorder.bottomAnchor, num: 0);
    }
    
    func configureBP() {
        API().post(url: myURL + "business/performance", headerToSend: Utilities().getAdminToken(), dataToSend: ["startDay": startDay, "endDay": endDay]) { (res) in
            print(res)
            if let sc = res["sc"] as? String, let mp = res["mp"] as? String, let spd = res["spd"] as? String, let ipd = res["ipd"] as? String {
                self.serviceCount = sc;
                self.moneyPerformance = mp;
                self.servicesPerDay = spd;
                self.incomePerDay = ipd;
            }
        }
    }
}
