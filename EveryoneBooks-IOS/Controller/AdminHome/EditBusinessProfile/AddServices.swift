//
//  AddServices.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/7/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol DeleteServiceProtocol: AddServices {
    func deleteService(service: Service, indexPath: [IndexPath], row: Int);
        
}

class AddServices: UIViewController, DeleteServiceProtocol {
    
    func deleteService(service: Service, indexPath: [IndexPath], row: Int) {
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you would like to delete " + service.serviceName + " as a service from your business?", preferredStyle: .alert);
        
        let action1 = UIAlertAction(title: "Oops, No!", style: .default, handler: nil);
        let action2 = UIAlertAction(title: "Yes!", style: .destructive) { (UIAlertAction) in
            API().post(url: "http://localhost:4000/api/services/delete",
                       headerToSend: Utilities().getAdminToken(), dataToSend: ["serviceId": service.id]) { (res) in
                if res["statusCode"] as? Int == 200 {
                    DispatchQueue.main.async {
                        self.services.remove(at: row);
                        self.removeServicesTable.deleteRows(at: indexPath, with: UITableView.RowAnimation.fade);
                    }
                }
            }
        }
        alert.addAction(action1);
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil);
    }
    
    var services: [Service] = [] {
        didSet{
            self.removeServicesTable.services = self.services;
        }
    }
    
    var removing: [String] = [];
    
    
    
    lazy var leftBarButton: UIButton = {
        let uib = Components().createHelpLeftButton();
        uib.addTarget(self, action: #selector(help), for: .touchUpInside)
        return uib;
    }()
    
    private let serviceNameTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Service Name", fontSize: 18);
        return uitf;
    }();
    
    lazy var serviceNameInput: UIView = {
        let uiv = Components().createInput(textField: serviceNameTextField, view: view);
        return uiv;
    }()
    
    private let serviceCostTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Cost", fontSize: 18);
        uitf.keyboardType = .decimalPad;
        return uitf;
    }();
    
    lazy var serviceCostInput: UIView = {
        let uiv = Components().createInput(textField: serviceCostTextField, view: view, width: 80);
        return uiv;
    }()
    
    private let timePicker: TimePicker = {
        let timePicker = TimePicker();
        timePicker.setHeight(height: 90);
        timePicker.setWidth(width: 210);
        return timePicker;
    }()
    
    private let dollarSign: UITextView = {
        let ds = UITextView();
        ds.isScrollEnabled = false;
        ds.text = "$";
        ds.isEditable = false;
        ds.font = .systemFont(ofSize: 24);
        ds.setWidth(width: 24);
        ds.setHeight(height: 32);
        ds.backgroundColor = .clear;
        return ds;
    }();
    
    private let addServiceButton: UIButton = {
        let uib = Components().createNormalButton(title: "Add Service");
        uib.addTarget(self, action: #selector(addService), for: .touchUpInside);
        return uib;
    }()
    
    private let removeServicesTable: RemoveServicesTable = {
        let rst = RemoveServicesTable();
        return rst;
    }()

    
    private let success: UIView = {
        let uiv = Components().createSuccess(text: "Services Successfully Deleted");
        return uiv;
    }();
    
    lazy var errorText: UITextView = {
        let uitv = Components().createError(view: view);
        return uitv;
    }()
    
    
    func deleteHit(serviceId: String) {
        API().post(url: "http://localhost:4000/api/services/delete", headerToSend: Utilities().getAdminToken(), dataToSend: ["serviceId": serviceId]) { (res) in
            if let status = res["statusCode"] as? Int {
                if status == 200 {
                    DispatchQueue.main.async {
                       
                    }
                }
            }
        }
    }
    
    
    @objc func addService() {
        let serviceName = serviceNameTextField.text!;
        let cost = serviceCostTextField.text!
        let duration = timePicker.getTimeSelected();
        for service in services {
            if serviceName == service.serviceName {
                let alert = Components().createActionAlert(title: "Service Name Already Exists", message: "To avoid confusion, we do not allow you to create two services with the same names!", buttonTitle: "Okay!", handler: nil);
                self.present(alert, animated: true, completion: nil);
                return;
            }
            
        }
        if serviceName != "" && cost != "" && duration != "" && duration != "serviceDuration" {
            let dts = ["serviceName": serviceName, "cost": cost, "timeDuration": duration]
            API().post(url: "http://localhost:4000/api/services/create", headerToSend: Utilities().getAdminToken(), dataToSend: dts) { (res) in
                if let status = res["statusCode"] as? Int {
                    if status == 201 || status == 200 {
                        
                        let nst = res["newServiceType"] as! [String: Any];
                        
                        let newService = Service(dic: nst);
                        
                        self.services.append(newService);
                    }
                }
            }
        }
        else {
            if serviceName == "" {
                errorText.text = "Please Enter Name of Service"
            }
            else if cost == "" {
                errorText.text = "Please Enter Cost of Service"
            }
            else {
                errorText.text = "Please Enter Service Duration"
            }
            errorText.isHidden = false;
        }
    }
    
    @objc func help() {
        let help = EditBusinessHelp(collectionViewLayout: UICollectionViewFlowLayout());
        help.modalPresentationStyle = .fullScreen;
        self.present(help, animated: true, completion: nil);
    }
    
    @objc func done() {
        self.dismiss(animated: true, completion: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
            // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getServices();
    }
    
    func getServices() {
        API().get(url: "http://localhost:4000/api/services", headerToSend: Utilities().getAdminToken()) { (res) in
            if let servicesBack = res["services"] as? [[String: Any]] {
                var newServices: [Service] = [];
                for serviceComingBack in servicesBack {
                    let service = Service(dic: serviceComingBack);
                    print(service);
                    print("DIDIWORK")
                    newServices.append(service);
                }
                self.services = newServices;
            }
        }
    }
    
    func configureView() {
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton);
        view.backgroundColor = .mainLav;
        navigationItem.title = "Add/Edit Services"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        view.addSubview(serviceNameInput);
        serviceNameInput.centerTo(element: view.centerXAnchor);
        serviceNameInput.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 7);
        view.addSubview(serviceCostInput);
        serviceCostInput.padTop(from: serviceNameInput.bottomAnchor, num: 40);
        serviceCostInput.padLeft(from: view.leftAnchor, num: view.frame.width / 7);
        view.addSubview(timePicker);
        timePicker.padTop(from: serviceNameInput.bottomAnchor, num: 10);
        timePicker.padRight(from: view.rightAnchor, num: view.frame.width / 10);
        view.addSubview(dollarSign);
        dollarSign.padRight(from: serviceCostInput.leftAnchor, num: -2);
        dollarSign.padTop(from: serviceCostInput.topAnchor, num: 2);
        view.addSubview(addServiceButton);
        addServiceButton.setHeight(height: 50);
        addServiceButton.setWidth(width: 200);
        addServiceButton.centerTo(element: view.centerXAnchor);
        addServiceButton.padTop(from: serviceCostInput.bottomAnchor, num: 40);
        view.addSubview(errorText);
        errorText.padTop(from: addServiceButton.bottomAnchor, num: 12);
        errorText.centerTo(element: view.centerXAnchor);
        errorText.isHidden = true;
        view.addSubview(removeServicesTable);
        removeServicesTable.padTop(from: addServiceButton.bottomAnchor, num: 30);
        removeServicesTable.centerTo(element: view.centerXAnchor);
        removeServicesTable.setHeight(height: view.frame.height / 3);
        removeServicesTable.setWidth(width: view.frame.width);
        removeServicesTable.deleteDelegate = self;
    }

    
}
