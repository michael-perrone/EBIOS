//
//  AddServices.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/7/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class AddServices: UIViewController, UITableViewDataSource {
    
    var services: [[String: Any]] = [] {
        didSet{
            DispatchQueue.main.async {
                self.servicesList.reloadData();
            }
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
    
    private let servicesList: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: UITableView.Style.insetGrouped);
        table.backgroundColor = .clear;
        return table;
    }()
    
    lazy var deleteButton: UIButton = {
          let uib = Components().createNormalButton(title: "Confirm Delete")
          uib.addTarget(self, action: #selector(deleteHit), for: .touchUpInside);
          return uib;
      }()
    
    private let success: UIView = {
        let uiv = Components().createSuccess(text: "Services Successfully Deleted");
        return uiv;
    }();
    
    lazy var errorText: UITextView = {
        let uitv = Components().createError(view: view);
        return uitv;
    }()
    
    
    @objc func deleteHit() {
        
        let data = ["removing": removing]
        API().post(url: "http://localhost:4000/api/services/delete", headerToSend: Utilities().getAdminToken(), dataToSend: data) { (res) in
            if let status = res["statusCode"] as? Int {
                if status == 200 {
                    DispatchQueue.main.async {
                       self.success.isHidden = false;
                       self.deleteButton.isHidden = true;
                    }
                }
            }
        }
    }
    
    
    @objc func addService() {
        let serviceName = serviceNameTextField.text!;
        let cost = serviceCostTextField.text!
        let duration = timePicker.getTimeSelected();
        if serviceName != "" && cost != "" && duration != "" && duration != "serviceDuration" {
            let dts = ["serviceName": serviceName, "cost": cost, "timeDuration": duration]
            API().post(url: "http://localhost:4000/api/services/create", headerToSend: Utilities().getAdminToken(), dataToSend: dts) { (res) in
                if let status = res["statusCode"] as? Int {
                    if status == 201 || status == 200 {
                        
                        let nst = res["newServiceType"] as! [String: Any];
                        
                        self.services.append(nst);
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
                self.services = servicesBack;
            }
        }
    }
    
    func configureView() {
        servicesList.dataSource = self;
        servicesList.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
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
        view.addSubview(servicesList);
        servicesList.padTop(from: addServiceButton.bottomAnchor, num: 30);
        servicesList.centerTo(element: view.centerXAnchor);
        servicesList.setHeight(height: view.frame.height / 3);
        servicesList.setWidth(width: view.frame.width);
        view.addSubview(deleteButton);
        deleteButton.setHeight(height: 45);
        deleteButton.setWidth(width: 200);
        deleteButton.centerTo(element: view.centerXAnchor);
        deleteButton.padTop(from: servicesList.bottomAnchor , num: 10);
        deleteButton.isHidden = true;
        view.addSubview(success);
        success.padLeft(from: view.leftAnchor, num: 20);
        success.padTop(from: servicesList.bottomAnchor, num: 10);
        success.isHidden = true;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
               if services.count > 0 {
                cell.textLabel?.text = services[indexPath.row]["serviceName"] as? String;
               }
           return cell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if services.count > 0 {
            if editingStyle == .delete {
                removing.append(services[indexPath.row]["_id"]! as! String)
                services.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                deleteButton.isHidden = false;
                success.isHidden = true;
               
            }
        }
    }
    
    
    
}
