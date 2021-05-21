//
//  ViewBookingViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/8/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol EditServicesDelegate: ViewBookingViewController {
    func removeService(service: Service, index: Int);
}

class ViewBookingViewController: UIViewController, EditServicesDelegate {
   
    func removeService(service: Service, index: Int) {
        let alertController = UIAlertController(title: "Remove Service:", message: "Please confirm that you would like to remove " + service.serviceName + " from this booking.", preferredStyle: .alert);
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (UIAlertAction) in
            self.services?.remove(at: index);
            API().post(url: myURL + "getBookings/removeService", dataToSend: ["bookingId": self.booking!.id, "serviceId": service.id]) { (res) in
                if let newCost = res["cost"] as? String {
                    DispatchQueue.main.async {
                        self.costText.text = newCost;
                    }
                }
                if let newTime = res["time"] as? String {
                    DispatchQueue.main.async {
                        self.timeOfServiceText.text = newTime;
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alertController.addAction(confirmAction);
        alertController.addAction(cancelAction);
        self.present(alertController, animated: true, completion: nil);
    }
    
  
    
    var booking: Booking? {
        didSet {
            API().post(url: myURL + "getBookings/moreBookingInfo", dataToSend: ["serviceIds" : booking?.serviceTypes, "customerId": booking!.customerId, "employeeId": booking?.employeeBooked]) { (res) in
                if let services = res["services"] as? [[String: Any]] {
                    var servicesArray: [Service] = [];
                    for service in services {
                        let actualService = Service(dic: service);
                        servicesArray.append(actualService);
                    }
                    self.services = servicesArray;
                }
                if let employeeNameBack = res["employeeName"] as? String {
                    self.employeeName = employeeNameBack;
                }
                if let customerComingBack = res["customer"] as? [String: Any] {
                    self.customer = Customer(dic: customerComingBack);
                    DispatchQueue.main.async {
                        self.costText.text = self.booking?.cost;
                        self.dateText.text = self.booking?.date;
                        self.timeOfServiceText.text = self.booking?.time;
                        self.customerNameText.text = self.customer?.name;
                        self.customerPhoneText.text = self.customer?.phone;
                        self.employeeNameText.text = self.employeeName;
                    }
                }
            }
            getServices(businessId: booking!.businessId!)
        }
    }
    
    private let editServicesTable = EditServicesTable();
        
    
    lazy var exitButton: UIButton = {
        let uib = Components().createXButton();
        uib.addTarget(self, action: #selector(exit), for: .touchUpInside);
        return uib;
    }()
    
    
    // MARK: - Properties for Interface
    
    var customer: Customer?;
    

    var services: [Service]? {
        didSet {
            editServicesTable.services = self.services;
        }
    }
    
    var addableServices: [Service]? {
        didSet {
            servicesTable.data = addableServices!;
        }
    }
    
    var employeeName: String?
    
    
    // MARK: - Interface
    
    private let employeeNameHeader = Components().createLittleText(text: "Employee Name:");
    
    private let employeeNameText = Components().createNotAsSmallText(text: "");
    
    private let customerNameHeader = Components().createLittleText(text: "Customer Name:");
    
    private let customerNameText = Components().createNotAsSmallText(text: "");
    
    private let customerPhoneHeader = Components().createLittleText(text: "Customer Phone:");
    
    private let customerPhoneText = Components().createNotAsSmallText(text: "");
    
    private let timeOfServiceHeader = Components().createLittleText(text: "Time of Serivce:");
    
    private let timeOfServiceText = Components().createNotAsSmallText(text: "");
    
    private let dateHeader = Components().createLittleText(text: "Date of Service:");
    
    private let dateText = Components().createNotAsSmallText(text: "");
    
    private let costHeader = Components().createLittleText(text: "Cost of Service:");
    
    private let costText = Components().createNotAsSmallText(text: "");
    
    private let servicesText = Components().createLittleText(text: "Services");
    
    private let addServicesText = Components().createLittleText(text: "Add Services");
    
    private let servicesTable: ServicesTable = {
        let st = ServicesTable();
        st.backgroundColor = .literGray;
        return st;
    }()
    
    private let addServicesButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Add Services Selected", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]), for: .normal);
        uib.backgroundColor = .liteGray;
        uib.layer.borderColor = .CGBlack;
        uib.layer.borderWidth = 0.8;
        uib.layer.cornerRadius = 3;
        uib.setHeight(height: 40);
        uib.setWidth(width: fullWidth / 1.2);
        uib.addTarget(self, action: #selector(addService), for: .touchUpInside);
        return uib;
    }()
    
    private let cancelBookingButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Cancel Booking", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal);
        uib.backgroundColor = UIColor(red: 1 , green: 0 , blue: 0, alpha: 0.45)
        uib.layer.borderColor = .CGBlack;
        uib.layer.borderWidth = 0.8;
        uib.layer.cornerRadius = 3;
        uib.setHeight(height: 40);
        uib.setWidth(width: fullWidth / 1.2);
        uib.addTarget(self, action: #selector(cancelBooking), for: .touchUpInside);
        return uib;
    }()
    
    @objc func cancelBooking() {
        let alert = Components().createActionAlert(title: "Cancel Booking?", message: "Click okay to cancel this booking. This action is not reverisble!", buttonTitle: "Okay") { (UIAlertAction) in
            API().post(url: myURL + "iosBooking/delete", headerToSend: Utilities().getAdminToken(), dataToSend: ["bookingId": self.booking!.id]) { (res) in
                if res["statusCode"] as! Int == 200 {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true);
                    }
                }
            }
        }
        let noButton = UIAlertAction(title: "Go Back", style: .cancel, handler: nil);
        alert.addAction(noButton)
        self.present(alert, animated: true, completion: nil);
    }
    
    @objc func exit() {
        if self.services!.count == 0 {
            let alert = Components().createActionAlert(title: "No Services Error", message: "Please add at least one service to this booking otherwise it will be deleted.", buttonTitle: "Woops, Okay!", handler: nil);
            self.present(alert, animated: true, completion: nil);
        }
        else {
            navigationController?.popViewController(animated: true);
        }
    }
    
    @objc func addService() {
        print(servicesTable.selectedServices)
        if servicesTable.selectedServices.count == 0 {
            let actionError = Components().createActionAlert(title: "Please Select a Service", message: "Please choose at least one service above to add to this booking.", buttonTitle: "Got it!", handler: nil);
            self.present(actionError, animated: true, completion: nil);
        }
        else {
            for selectedService in servicesTable.selectedServices {
                var i = 0;
                while i < services!.count {
                    if services![i].id == selectedService.id {
                        let actionError = Components().createActionAlert(title: "Service Already Scheduled", message: "One or more of the services that you attempted to add is already scheduled in this booking.", buttonTitle: "Oops, okay!", handler: nil);
                        self.present(actionError, animated: true, completion: nil);
                        return;
                    }
                    i += 1;
                }
            }
            var serviceIdsArray: [String] = [];
            for service in servicesTable.selectedServices {
                serviceIdsArray.append(service.id);
            }
            API().post(url: myURL + "getBookings/editBooking", dataToSend: ["bookingId": booking!.id, "servicesToAdd": serviceIdsArray ]) { (res) in
                if res["statusCode"] as! Int == 200 {
                    var newEditServicesArray = self.services!;
                    for service in self.servicesTable.selectedServices {
                        newEditServicesArray.append(service);
                    }
                    self.services = newEditServicesArray;
                    if let newCost = res["cost"] as? String {
                        DispatchQueue.main.async {
                            self.costText.text = newCost;
                        }
                    }
                    if let newTime = res["time"] as? String {
                        DispatchQueue.main.async {
                            self.timeOfServiceText.text = newTime;
                        }
                    }
                }
                else {
                    print(res["statusCode"] as! Int)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.hidesBackButton = true;
        configureView();
        handleLogo();
    }
    
    func configureView() {
        view.backgroundColor = .literGray;
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exitButton);
        view.addSubview(employeeNameHeader);
        employeeNameHeader.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 12);
        employeeNameHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(employeeNameText);
        employeeNameText.padTop(from: employeeNameHeader.bottomAnchor, num: -10);
        employeeNameText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerNameHeader);
        customerNameHeader.padTop(from: employeeNameText.bottomAnchor, num: 24);
        customerNameHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerNameText);
        customerNameText.padTop(from: customerNameHeader.bottomAnchor, num: -10);
        customerNameText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerPhoneHeader);
        customerPhoneHeader.padTop(from: customerNameText.bottomAnchor, num:24);
        customerPhoneHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerPhoneText);
        customerPhoneText.padTop(from: customerPhoneHeader.bottomAnchor, num: -10);
        customerPhoneText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(timeOfServiceHeader);
        timeOfServiceHeader.padTop(from: customerPhoneText.bottomAnchor, num: 24);
        timeOfServiceHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(timeOfServiceText);
        timeOfServiceText.padTop(from: timeOfServiceHeader.bottomAnchor, num: -10);
        timeOfServiceText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(dateHeader);
        dateHeader.padTop(from: timeOfServiceText.bottomAnchor, num: 24);
        dateHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(dateText);
        dateText.padTop(from: dateHeader.bottomAnchor, num: -10);
        dateText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(costHeader);
        costHeader.padTop(from: dateText.bottomAnchor, num: 24);
        costHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(costText);
        costText.padTop(from: costHeader.bottomAnchor, num: -10);
        costText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(servicesText)
        servicesText.padTop(from: employeeNameHeader.topAnchor, num: 0);
        servicesText.padRight(from: view.rightAnchor, num: 90);
        view.addSubview(editServicesTable);
        editServicesTable.otherDelegate = self;
        editServicesTable.setWidth(width: 200);
        editServicesTable.padRight(from: view.rightAnchor, num: 20);
        editServicesTable.padTop(from: servicesText.bottomAnchor, num: 0);
        view.addSubview(addServicesText);
        addServicesText.padTop(from: editServicesTable.bottomAnchor, num: 20);
        addServicesText.padRight(from: view.rightAnchor, num: 77);
        view.addSubview(servicesTable);
        servicesTable.padTop(from: addServicesText.bottomAnchor, num: 10);
        servicesTable.padRight(from: view.rightAnchor, num: 20);
        servicesTable.setWidth(width: 200);
        view.addSubview(addServicesButton);
        addServicesButton.padTop(from: servicesTable.bottomAnchor, num: 40);
        addServicesButton.padRight(from: servicesTable.rightAnchor, num: 0);
        addServicesButton.setWidth(width: 172);
        editServicesTable.setHeight(height: 160);
        view.addSubview(cancelBookingButton);
        cancelBookingButton.padTop(from: costText.bottomAnchor, num: 40);
        cancelBookingButton.padLeft(from: view.leftAnchor, num: 4);
        cancelBookingButton.setWidth(width: 172);
        cancelBookingButton.setHeight(height: 160);
    }
    
    func handleLogo() {
        if let eToken = Utilities().getEmployeeId() {
            navigationController?.navigationBar.backgroundColor = .mainLav;
            navigationController?.navigationBar.barTintColor = .mainLav;
        }
        else {
            navigationController?.navigationBar.backgroundColor = .white;
            navigationController?.navigationBar.barTintColor = .white;
        }
        navigationItem.title = "Booking Details"
    }
    
    func getServices(businessId: String) {
        if Utilities().decodeAdminToken() != nil || Utilities().decodeEmployeeToken() != nil {
            API().post(url: myURL + "services/getServices", dataToSend: ["businessId": businessId]) { (res) in
                if let services = res["services"] as? [[String: Any]] {
                    var newServicesArray: [Service] = [];
                    for service in services {
                        newServicesArray.append(Service(dic: service));
                    }
                    self.addableServices = newServicesArray;
                    DispatchQueue.main.async {
                        self.servicesTable.setHeight(height: CGFloat(self.addableServices!.count) * 40);
                    }
                }
            }
        }
    }
}
