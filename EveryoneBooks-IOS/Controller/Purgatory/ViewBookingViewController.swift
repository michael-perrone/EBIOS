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
    func addService(service: Service);
}

class ViewBookingViewController: UIViewController, EditServicesDelegate {
   
    func addService(service: Service) {
        
    }
    
    func removeService(service: Service, index: Int) {
        let alertController = UIAlertController(title: "Remove Service:", message: "Please confirm that you would like to remove " + service.serviceName + " from this booking.", preferredStyle: .alert);
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (UIAlertAction) in
            self.services?.remove(at: index);
            API().post(url: myURL + "getBookings/removeService", dataToSend: ["bookingId": self.booking!.id, "serviceId": service.id]) { (res) in
                print(res);
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alertController.addAction(confirmAction);
        alertController.addAction(cancelAction);
        self.present(alertController, animated: true, completion: nil);
        
    }
    
  
    
    var booking: Booking? {
        didSet {
            print(booking);
            print("BOOKING IS ABOVE");
            API().post(url: myURL + "getBookings/moreBookingInfo", dataToSend: ["serviceIds" : booking?.serviceTypes, "customerId": booking!.customerId, "employeeId": booking?.employeeBooked]) { (res) in
                print("DID I REALLY RUN THREE TIMES")
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
            print(services)
            print("services is above")
            editServicesTable.services = self.services;
            DispatchQueue.main.async {
                self.editServicesTable.setHeight(height: CGFloat(self.services!.count) * 40);
            }
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
    
    
    @objc func exit() {
        print("HELLO");
        navigationController?.popViewController(animated: true);
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
        employeeNameHeader.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 8);
        employeeNameHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(employeeNameText);
        employeeNameText.padTop(from: employeeNameHeader.bottomAnchor, num: -10);
        employeeNameText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerNameHeader);
        customerNameHeader.padTop(from: employeeNameText.bottomAnchor, num: 8);
        customerNameHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerNameText);
        customerNameText.padTop(from: customerNameHeader.bottomAnchor, num: -10);
        customerNameText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerPhoneHeader);
        customerPhoneHeader.padTop(from: customerNameText.bottomAnchor, num: 8);
        customerPhoneHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerPhoneText);
        customerPhoneText.padTop(from: customerPhoneHeader.bottomAnchor, num: -10);
        customerPhoneText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(timeOfServiceHeader);
        timeOfServiceHeader.padTop(from: customerPhoneText.bottomAnchor, num: 8);
        timeOfServiceHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(timeOfServiceText);
        timeOfServiceText.padTop(from: timeOfServiceHeader.bottomAnchor, num: -10);
        timeOfServiceText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(dateHeader);
        dateHeader.padTop(from: timeOfServiceText.bottomAnchor, num: 8);
        dateHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(dateText);
        dateText.padTop(from: dateHeader.bottomAnchor, num: -10);
        dateText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(costHeader);
        costHeader.padTop(from: dateText.bottomAnchor, num: 8);
        costHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(costText);
        costText.padTop(from: costHeader.bottomAnchor, num: -10);
        costText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(servicesText)
        servicesText.padTop(from: employeeNameHeader.topAnchor, num: 0);
        servicesText.padRight(from: view.rightAnchor, num: fullWidth / 4 - 10);
        view.addSubview(editServicesTable);
        editServicesTable.otherDelegate = self;
        editServicesTable.setWidth(width: fullWidth / 2);
        editServicesTable.padRight(from: view.rightAnchor, num: 20);
        editServicesTable.padTop(from: servicesText.bottomAnchor, num: 0);
        
    }
    
 
    
    func handleLogo() {
        navigationController?.navigationBar.backgroundColor = .white;
        navigationController?.navigationBar.barTintColor = .white;
        navigationItem.title = "Booking Details"
    }
}
