//
//  UserBookingSomething.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/4/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol EmployeesTable: UserBookingSomething {
    func bookHit()
}

class UserBookingSomething: UIViewController, EmployeesTable {
    
    func bookHit() {
        let bookSuccess = UIAlertController(title: "Success!", message: "You're request has been received and accepted.", preferredStyle: .alert);
        let okayButton = UIAlertAction(title: "Exit!", style: .cancel) { (action: UIAlertAction) in
            UIView.animate(withDuration: 0.45) {
                self.popUp.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.6);
                self.backDrop.alpha = 0;
            }
        }
        bookSuccess.addAction(okayButton);
        DispatchQueue.main.async {
            self.present(bookSuccess, animated: true, completion: nil);
        }
    }
    
    func userNotiSent() {
        let actionAlert = Components().createActionAlert(title: "Booking Request Sent", message: "A request has been sent to the employee and business that you have specified to see if they are able to complete your requested services at this time. If they are able to, you will receive a notification confirming that your appointment has been scheduled.", buttonTitle: "Got it!") { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true);
        }
        DispatchQueue.main.async {
            self.present(actionAlert, animated: true, completion: nil);
        }
    }
    
    var employeesAvailable: [Employee]? {
        didSet {
            employeesTable.employees = self.employeesAvailable;
            employeesTable.dateChosen = self.dateChosen;
            employeesTable.timeChosen = self.choosePreferredTime.selectedItem;
            employeesTable.services = servicesTable.selectedServices;
            employeesTable.businessId = business!.id;
        }
    }
    
    private var eq: Bool? {
        didSet {
            employeesTable.eq = eq;
        }
    }
    
    var business: Business? {
        didSet {
            navigationItem.title = business!.nameOfBusiness;
            print(self.business!)
            print("business is above")
            self.eq = business!.eq;
        }
    }
    
    var services: [Service]? {
        didSet {
            servicesTable.data = services;
        }
    }
    
    var dateChosen: String?
    
    var comingFromBusinessPage: Bool?;
    
    var startNum: Int? {
        didSet {
            if let start = self.startNum, let close = self.closeNum {
                getAllTimes(start: start, close: close)
            }
        }
    }
    
    var closeNum: Int?;
    
    private let noServicesText: UITextView = {
        let uitv = Components().createLittleText(text: "This business has not listed any services they are able to perform at this time. You cannot book at this business until they list services they are able to perform.");
        uitv.setWidth(width: fullWidth / 1.25)
        return uitv;
    }()
    
    private let servicesTable: ServicesTable = {
        let st = ServicesTable();
        st.backgroundColor = .literGray;
        return st;
    }()
    
    private let chooseServiceText: UITextView = {
        let uitv = Components().createLittleText(text: "Choose services to book:");
        return uitv;
    }()
    
    let chooseDateText: UITextView = {
        let uitv = Components().createLittleText(text: "Choose your preferred date:");
        return uitv;
    }()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker();
        dp.datePickerMode = .date;
        dp.setHeight(height: 90);
        dp.addTarget(self, action: #selector(dateChanged), for: .valueChanged);
        return dp;
    }()
    
    @objc func dateChanged() {
        getStartCloseNum(date: datePicker.date);
        let formatter  = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy";
        dateChosen = formatter.string(from: datePicker.date);
        
    }
    
    private let chooseTimeText: UITextView = {
        let uitv = Components().createLittleText(text: "Choose your preferred time:");
        uitv.alpha = 1;
        return uitv;
    }();
    
    private let choosePreferredTime: GenericDropDown = {
        let tp = GenericDropDown();
        tp.setWidth(width: UIScreen.main.bounds.width / 1.3);
        tp.alpha = 1;
        return tp;
    }();
    
    lazy var continueButton: UIButton = {
        let uib = Components().createContinueBookingButton();
        uib.addTarget(self, action: #selector(continueHit), for: .touchUpInside);
        return uib;
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelB = Components().createXButton();
        cancelB.addTarget(self, action: #selector(hideView), for: .touchUpInside);
        return cancelB;
    }()
    
    @objc func hideView() {
          UIView.animate(withDuration: 0.45) {
            self.popUp.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.6);
              self.backDrop.alpha = 0;
          }
      }
      
    @objc func continueHit() {
        if servicesTable.selectedServices.count > 0 {
          getAvailableEmployees()
        }
        else {
            let noServicesSelected = UIAlertController(title: "No Services Selected", message: "Please select at least one service above that you would like performed.", preferredStyle: .alert);
            let okay = UIAlertAction(title: "Got it", style: .cancel, handler: nil);
            noServicesSelected.addAction(okay);
            DispatchQueue.main.async {
                self.present(noServicesSelected, animated: true, completion: nil);
            }
        }
    }
    
    private let popUp: UIView = {
        let uisv = UIScrollView();
        uisv.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        uisv.backgroundColor = .mainLav;
        return uisv;
    }()
    
    private let backDrop = Components().createBackDrop();
    
    
    lazy var employeesAvailableText: UITextView = {
        let uitv = Components().createSimpleText(text: "Employees Avaliable");
        uitv.backgroundColor = .mainLav;
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    private let servicesChosenText: UITextView = {
        let uitv = Components().createLittleText(text: "Services Chosen: ");
        uitv.backgroundColor = .mainLav;
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    private let timeDurationText: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.backgroundColor = .mainLav;
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    private let costText: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 16);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let servicesChosenTable: ServicesChosenTable = {
        let sct = ServicesChosenTable();
        sct.setWidth(width: UIScreen.main.bounds.width / 1.3);
        sct.setHeight(height: 150);
        sct.backgroundColor = .clear;
        return sct;
    }()
    
    private let employeesTable: EmployeesAvailableTable = {
        let eat = EmployeesAvailableTable();
        eat.backgroundColor = .literGray;
        return eat;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView();
        configureStartDate();
        getServices()
        getStartCloseNum(date: Date());
    }
    
    func configureStartDate() {
        let formatter  = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy";
        let myDate = formatter.string(from: Date());
        dateChosen = myDate;
    }
    
    func configureView() {
        employeesTable.otherDelegate = self;
        backDrop.alpha = 0;
        view.backgroundColor = .literGray;
        view.addSubview(chooseServiceText);
        chooseServiceText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 4);
        chooseServiceText.padLeft(from: view.leftAnchor, num: 30);
        view.addSubview(servicesTable);
        servicesTable.padTop(from: chooseServiceText.bottomAnchor, num: 6);
        servicesTable.centerTo(element: view.centerXAnchor);
        servicesTable.setHeight(height: 140);
        servicesTable.setWidth(width: fullWidth);
        view.addSubview(chooseDateText);
        chooseDateText.padTop(from: servicesTable.bottomAnchor, num: 12);
        chooseDateText.padLeft(from: view.leftAnchor, num: 30);
        view.addSubview(datePicker);
        datePicker.padTop(from: chooseDateText.bottomAnchor, num: 6);
        datePicker.centerTo(element: view.centerXAnchor);
        view.addSubview(chooseTimeText);
        chooseTimeText.padTop(from: datePicker.bottomAnchor, num: 12);
        chooseTimeText.padLeft(from: view.leftAnchor, num: 30);
        view.addSubview(choosePreferredTime);
        choosePreferredTime.centerTo(element: view.centerXAnchor);
        choosePreferredTime.padTop(from: chooseTimeText.bottomAnchor, num: 4);
        view.addSubview(continueButton);
        continueButton.centerTo(element: view.centerXAnchor);
        continueButton.padTop(from: choosePreferredTime.bottomAnchor, num: 20);
        view.addSubview(backDrop);
        view.addSubview(popUp);
        popUp.addSubview(timeDurationText);
        timeDurationText.padTop(from: popUp.topAnchor, num: 6);
        timeDurationText.padLeft(from: popUp.leftAnchor, num: 20);
        popUp.addSubview(costText);
        costText.padTop(from: timeDurationText.bottomAnchor, num: 10);
        costText.padLeft(from: popUp.leftAnchor, num: 20);
        popUp.addSubview(servicesChosenText);
        servicesChosenText.padTop(from: costText.bottomAnchor, num: 6);
        servicesChosenText.padLeft(from: popUp.leftAnchor, num: 20);
        popUp.addSubview(servicesChosenTable);
        servicesChosenTable.padTop(from: servicesChosenText.bottomAnchor, num: 6);
        servicesChosenTable.centerTo(element: popUp.centerXAnchor);
        popUp.addSubview(employeesAvailableText);
        employeesAvailableText.padTop(from: servicesChosenTable.bottomAnchor, num: 2);
        employeesAvailableText.centerTo(element: popUp.centerXAnchor);
        popUp.addSubview(cancelButton);
        cancelButton.padRight(from: view.rightAnchor, num: 10)
        cancelButton.padTop(from: popUp.topAnchor, num: 15);
        popUp.addSubview(employeesTable)
        employeesTable.backgroundColor = .mainLav;
        employeesTable.padTop(from: employeesAvailableText.bottomAnchor, num: 6);
        employeesTable.centerTo(element: popUp.centerXAnchor);
        employeesTable.setHeight(height: UIScreen.main.bounds.height / 3);
        employeesTable.setWidth(width: UIScreen.main.bounds.width);
        view.addSubview(noServicesText);
        noServicesText.padTop(from: chooseServiceText.bottomAnchor, num: 8);
        noServicesText.padLeft(from: view.leftAnchor, num: 30);
        noServicesText.isHidden = true;
    }
    
    func getServices() {
        API().post(url: myURL + "services/getServices", dataToSend: ["businessId": self.business?.id]) { (res) in
            if let servicess = res["services"] as? [[String: Any]] {
                if servicess.count == 0 {
                    DispatchQueue.main.async {
                        self.servicesTable.isHidden = true;
                        self.noServicesText.isHidden = false;
                    }
                    return;
                }
            var newServicesArray: [Service] = [];
            for service in servicess {
                newServicesArray.append(Service(dic: service));
            }
            self.services = newServicesArray;
            }
        }
    }

    
    func getStartCloseNum(date: Date? = nil) {
        if let date = date {
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: date)
            
            if weekDay == 1 {
                self.closeNum = Utilities.stit[business!.schedule!.sunClose];
                self.startNum = Utilities.stit[business!.schedule!.sunOpen]!;
            }
            else if weekDay == 2 {
                self.closeNum = Utilities.stit[business!.schedule!.monClose];
                self.startNum = Utilities.stit[business!.schedule!.monOpen]!;
            }
            else if weekDay == 3 {
                self.closeNum = Utilities.stit[business!.schedule!.tueClose];
                self.startNum = Utilities.stit[business!.schedule!.tueOpen]!;
            }
            else if weekDay == 4 {
                self.closeNum = Utilities.stit[business!.schedule!.wedClose];
                self.startNum = Utilities.stit[business!.schedule!.wedOpen]!;
                
            }
            else if weekDay == 5 {
                self.closeNum = Utilities.stit[business!.schedule!.thuClose];
                self.startNum = Utilities.stit[business!.schedule!.thuOpen]!;
            }
            else if weekDay == 6 {
                self.closeNum = Utilities.stit[business!.schedule!.friClose];
                self.startNum = Utilities.stit[business!.schedule!.friOpen]!;
            }
            else if weekDay == 7 {
                self.closeNum = Utilities.stit[business!.schedule!.satClose];
                self.startNum = Utilities.stit[business!.schedule!.satOpen]!;
                
            }
        }
    }
    
    func getAllTimes(start: Int, close: Int) {
        var newStart = start;
        var times: [String] = [];
        while newStart < close {
            times.append(Utilities.itst[newStart]!)
            newStart += 1;
        }
        choosePreferredTime.data = times;
    }
    
    func getAvailableEmployees() {
        var serviceIds: [String] = [];
        var serviceNames: [String] = []
        var timeDurationNum = 0;
        var cost: Double = 0;
        for selectedService in servicesTable.selectedServices {
            serviceIds.append(selectedService.id);
            serviceNames.append(selectedService.serviceName);
            timeDurationNum = timeDurationNum + Utilities.timeDurationStringToInt[selectedService.timeDuration]!;
            cost = cost + selectedService.cost;
        }
        let costString = String(cost);
        let closeTime = Utilities.itst[Utilities.stit[choosePreferredTime.selectedItem!]! + timeDurationNum];
        API().post(url: myURL + "getBookings", dataToSend: ["businessId": business!.id!, "date": dateChosen, "serviceIds": serviceIds, "timeChosen": choosePreferredTime.selectedItem]) { (res) in
            if res["statusCode"] as! Int == 409 {
                let alert = UIAlertController(title: "Invalid Date", message: "The date or time you have chosen has already passed and cannot be scheduled.", preferredStyle: .alert);
                let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                alert.addAction(woops);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
            if let employees = res["employees"] as? [[String: String]] {
                var newEmployeesArray: [Employee] = [];
                for employee in employees {
                    let newEmployee = Employee(dic: employee);
                    newEmployeesArray.append(newEmployee);
                }
                self.employeesAvailable = newEmployeesArray;
                self.servicesChosenTable.servicesChosen = serviceNames;
                if newEmployeesArray.count > 0 {
                    DispatchQueue.main.async {
                        self.timeDurationText.text = "From: " + self.choosePreferredTime.selectedItem! + "-" + closeTime!;
                        var costStringArray = costString.components(separatedBy: ".");
                        if costStringArray[1].count == 1 {
                            costStringArray[1] = costStringArray[1] + "0";
                            self.costText.text = "Cost: " + "$" + costStringArray[0] + "." +  costStringArray[1];
                        }
                        else {
                            self.costText.text = "Cost: " + "$" + costString;
                        }
                        UIView.animate(withDuration: 0.4) {
                            self.popUp.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height / 1.10, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.10);
                            self.backDrop.alpha = 1;
                        }
                    }
                }
            }
            else if res["statusCode"] as! Int == 406 {
                // do the alert here
                let alert = UIAlertController(title: "Time Unavailable", message: self.business!.nameOfBusiness! + " does not have any availability at this time. Want us to check for other nearby times on this date?", preferredStyle: .alert);
                let searchOthers = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
                    print("gotta go find the others")
                }
                alert.addAction(searchOthers);
                let noThanks = UIAlertAction(title: "Nope", style: .cancel) { (action: UIAlertAction) in
                    print("lol")
                }
                alert.addAction(noThanks)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }
}
