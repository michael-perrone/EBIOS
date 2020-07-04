//
//  AddEmployeesViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/7/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class AddEmployees: UIViewController {
    
    var employeeId: String?;
    
    var employeeName: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.employeeFound.isHidden = false;
                self.textForView.text = "Add " + self.employeeName + " to your business?";
            }
        }
    }
    
    var employeesHere: [[String: String]]? {
        didSet {
            DispatchQueue.main.async {
                self.employeesHereTable.employees = self.employeesHere;
                self.employeesHereTable.table.reloadData()
                self.employeesHereTable.url = "http://localhost:4000/api/businessProfile/employeeDeleteFromBusiness";
            }
        }
    }
    
    var employeesPending: [[String:String]]? {
        didSet {
            DispatchQueue.main.async {
                self.employeesPendingTable.employees = self.employeesPending;
                self.employeesPendingTable.table.reloadData();
                self.employeesPendingTable.url = "http://localhost:4000/api/businessProfile/removeFromPending";
                
            }
        }
    }
    
    private let employeeIdTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Enter Employee ID", fontSize: 20);
        return uitf;
    }();
    
    lazy var employeeIdInput: UIView = {
        let uiv = Components().createInput(textField: employeeIdTextField, view: view, width: view.frame.width / 1.5);
        return uiv;
    }()
    
    private let searchButton: UIButton = {
        let uib = Components().createAlternateButton(title: "Search")
        uib.addTarget(self, action: #selector(sendEmployeeId), for: .touchUpInside);
        return uib;
    }()
    
    lazy var textForView: UITextView = {
        let uitv = UITextView();
        uitv.text = "";
        uitv.font = .systemFont(ofSize: 16);
        uitv.isScrollEnabled = false;
        uitv.isEditable = false;
        uitv.setHeight(height: UIScreen.main.bounds.height / 10);
        uitv.backgroundColor = .white;
        uitv.setWidth(width: UIScreen.main.bounds.width / 1.05);
        uitv.textAlignment = .center;
        return uitv;
    }()
    
    lazy var employeeFound: UIView = {
        let uiv = Components().createWhiteUIView(width: 1.05, height: 7);
        uiv.addSubview(textForView);
        textForView.padTop(from: uiv.topAnchor, num: 0);
        textForView.centerTo(element: uiv.centerXAnchor);
        let uib = Components().createNormalButton(title: "Yes");
        uib.setHeight(height: 35);
        uib.setWidth(width: 70);
        uib.addTarget(self, action: #selector(addEmployee), for: .touchUpInside);
        let uib2 = Components().createNormalButton(title: "No");
        uib2.setHeight(height: 35);
        uib2.setWidth(width: 70);
        uib2.addTarget(self, action: #selector(noHit), for: .touchUpInside);
        let stack = UIStackView(arrangedSubviews: [uib, uib2]);
        stack.distribution = .equalSpacing;
        stack.alignment = .center;
        uiv.addSubview(stack);
        stack.centerTo(element: textForView.centerXAnchor);
        stack.setWidth(width: 200);
        stack.setHeight(height: 40);
        stack.padTop(from: textForView.bottomAnchor, num: -20);
        return uiv;
    }()
    
    private let success: UIView = {
        let uiv = Components().createSuccess(text: "Employee Succesfully Added");
        return uiv;
    }();
    
    lazy var leftBarButton: UIButton = {
        let uib = Components().createHelpLeftButton();
        uib.addTarget(self, action: #selector(help), for: .touchUpInside)
        return uib;
    }()
    
    lazy var employeesPendingTable: EmployeeAddTable = {
        let table = EmployeeAddTable();
        return table;
    }()
    
    lazy var employeesHereTable: EmployeeAddTable = {
        let table = EmployeeAddTable();
        return table;
    }()
    
    private let toggleEmployeesHere: UIButton = {
        let uib = Components().createTableToggleButtons(title: "Current Employees");
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(employeesHereToggled), for: .touchUpInside);
        return uib;
    }()
    
    private let toggleEmployeesPending: UIButton = {
        let uib = Components().createTableToggleButtons(title: "Pending Employees");
        uib.backgroundColor = .darkGray;
        uib.tintColor = .mainLav;
        uib.addTarget(self, action: #selector(employeesPendingToggled), for: .touchUpInside)
        return uib;
    }()
    
    lazy var errorText: UITextView = {
        let uitv = Components().createError(view: view);
        uitv.text = "Please Enter Employee Id"
        return uitv;
    }();
    
    @objc func employeesPendingToggled() {
        toggleEmployeesPending.tintColor = .mainLav;
        toggleEmployeesPending.backgroundColor = .darkGray;
        toggleEmployeesHere.tintColor = .black;
        toggleEmployeesHere.backgroundColor = .mainLav;
        employeesPendingTable.isHidden = false;
        employeesHereTable.isHidden = true;
    }
    
    @objc func employeesHereToggled() {
        toggleEmployeesPending.tintColor = .black;
        toggleEmployeesPending.backgroundColor = .mainLav;
        toggleEmployeesHere.backgroundColor = .darkGray;
        toggleEmployeesHere.tintColor = .mainLav;
        employeesPendingTable.isHidden = true;
        employeesHereTable.isHidden = false;
    }
    
    
    @objc func help() {
        
        let help = EditBusinessHelp(collectionViewLayout: UICollectionViewFlowLayout());
        help.modalPresentationStyle = .fullScreen;
        self.present(help, animated: true, completion: nil);
    }
    
    @objc func noHit() {
        employeeFound.isHidden = true;
    }
    
    @objc func addEmployee() {
        let dataToSend = ["employeeId": self.employeeId, "business": Utilities().getBusinessId()];
        let url = myURL + "businessProfile/addEmployeeToBusinessApp";
        API().post(url: url, dataToSend: dataToSend) { (res) in
            if res["statusCode"] as! Int != 406 {
                self.employeesPending?.append(["fullName": self.employeeName, "_id": self.employeeId!])
                DispatchQueue.main.async {
                   self.employeeFound.isHidden = true;
                   self.success.isHidden = false;
                }
            }
            else {
                DispatchQueue.main.async {
                    self.employeeFound.isHidden = true;
                    self.errorText.text = "Employee already is working or pending"
                    self.errorText.isHidden = false;
                }
            }
        }
    }
    
    @objc func done() {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    @objc func sendEmployeeId() {
        success.isHidden = true;
        if let eID = employeeIdTextField.text {
                if eID != "" {
                errorText.isHidden = true;
                let url = myURL + "employeeList";
                let dataToSend = ["employeeId": eID];
                API().post(url: url, dataToSend: dataToSend) { (res) in
                    
                    if let failure = res["fail"] {
                        if failure as! Bool{
                            DispatchQueue.main.async {
                                self.errorText.text = "ID is not registered on our app"
                                self.errorText.isHidden = false;
                            }
                            return;
                        }
                    }
                self.employeeId = res["id"] as? String
                self.employeeName = res["name"] as? String ?? "";
                }
            }
                else {
                    errorText.text = "Please enter the employee ID"
                    errorText.isHidden = false;
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getEmployees();
    }
    
    
    
    func configureView() {
        
        errorText.isHidden = true;
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton);
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        view.backgroundColor = .mainLav;
        navigationItem.title = "Add/Edit Employees";
        view.addSubview(employeeIdInput);
        employeeIdInput.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: view.frame.height / 50);
        employeeIdInput.padLeft(from: view.leftAnchor, num: 20);
        
        view.addSubview(searchButton);
        searchButton.padLeft(from: employeeIdInput.rightAnchor, num: 10);
        searchButton.padTop(from: employeeIdInput.topAnchor, num: -2);
        searchButton.setHeight(height: 46);
        searchButton.setWidth(width: 84);
        
        view.addSubview(employeeFound);
        employeeFound.padTop(from: employeeIdInput.bottomAnchor, num: 20);
        employeeFound.centerTo(element: view.centerXAnchor);
        employeeFound.isHidden = true;
        
        view.addSubview(success);
        success.padBottom(from: employeeFound.bottomAnchor, num: 0);
        success.centerTo(element: view.centerXAnchor);
        success.isHidden = true;
        
        
        view.addSubview(errorText);
        errorText.padTop(from: employeeFound.bottomAnchor, num: -20);
        
        view.addSubview(toggleEmployeesPending);
        toggleEmployeesPending.padTop(from: employeeFound.bottomAnchor, num: 15);
        toggleEmployeesPending.padLeft(from: view.leftAnchor, num: 7);
        
        view.addSubview(toggleEmployeesHere);
        toggleEmployeesHere.padTop(from: employeeFound.bottomAnchor, num: 15);
        toggleEmployeesHere.padLeft(from: toggleEmployeesPending.rightAnchor, num: -2);
        
        view.addSubview(employeesPendingTable);
        employeesPendingTable.padTop(from: toggleEmployeesPending.bottomAnchor, num: 15);
        employeesPendingTable.centerTo(element: view.centerXAnchor);
        employeesPendingTable.setWidth(width: view.frame.width);
        employeesPendingTable.setHeight(height: view.frame.height / 2.3);
        
        view.addSubview(employeesHereTable);
        employeesHereTable.padTop(from: toggleEmployeesPending.bottomAnchor, num: 15);
        employeesHereTable.centerTo(element: view.centerXAnchor);
        employeesHereTable.setWidth(width: view.frame.width);
        employeesHereTable.setHeight(height: view.frame.height / 2.3);
        employeesHereTable.isHidden = true;
    }
    
    func getEmployees() {
        let url = myURL + "businessProfile/myEmployees";
        API().get(url: url, headerToSend: Utilities().getAdminToken()) { (res) in
            let employeesHere = res["employeesHere"] as? [[String: String]];
            let employeesPending = res["employeesPending"] as? [[String: String]];
            self.employeesHere = employeesHere;
            self.employeesPending = employeesPending;
        }
    }

    

}
