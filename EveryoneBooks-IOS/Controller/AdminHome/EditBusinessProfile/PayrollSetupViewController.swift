//
//  PayrollSetupViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/12/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

protocol SelectEmployeeProtocol: PayrollSetupViewController {
    func chooseEmployee(employee: Employee);
}

class PayrollSetupViewController: UIViewController, SelectEmployeeProtocol {
    
    
    func chooseEmployee(employee: Employee) {
        API().post(url: myURL + "payroll/getEmployeePayroll", headerToSend: Utilities().getAdminToken(), dataToSend: ["employeeId": employee.id]) { res in
            if let employeeBack = res["emPayroll"] as? [String: Any] {
                let emPayroll = EmployeePayroll(dic: employeeBack);
                print(emPayroll)
                self.salaryBool = emPayroll.isSalary;
                self.hourlyBool = emPayroll.isHourlyWage;
                self.productCommission = emPayroll.isComissionProducts;
                self.serviceCommission = emPayroll.isCommissionServices;
                self.productPercent = emPayroll.productCommissionRate;
                self.servicePercent = emPayroll.serviceCommissionRate;
                self.salary = emPayroll.salary;
                self.hourly = emPayroll.hourlyWage;
            }
            else if res["statusCode"] as? Int == 400 {
                self.salaryBool = false;
                self.hourlyBool = false;
                self.productCommission = false;
                self.serviceCommission = false;
                self.productPercent = "nil"; // not sure
                self.servicePercent = "nil"; // same
                self.salary = "";
                self.hourly = "";
                self.productsCommissionDropdown.selectedItem = "% Earned";
                self.servicesCommissionDropdown.selectedItem = "% Earned";
                DispatchQueue.main.async {
                    self.productsCommissionDropdown.selectRow(0, inComponent: 0, animated: false);
                    self.servicesCommissionDropdown.selectRow(0, inComponent: 0, animated: false);
                    self.servicesCommissionDropdown.isHidden = true;
                    self.productsCommissionDropdown.isHidden = true;
                }
            }
        }
    }
    
    var hourly: String? {
        didSet {
            DispatchQueue.main.async {
                self.hourlyWageTextField.text = self.hourly;
                if self.hourly == "" {
                    self.hourlyWageInput.isHidden = true;
                }
                else {
                    self.hourlyWageInput.isHidden = false;
                }
            }
        }
    }
    
    var salary: String? {
        didSet {
            DispatchQueue.main.async {
                self.salaryTextField.text = self.salary;
                if self.salary == "" {
                    self.salaryInput.isHidden = true;
                }
                else {
                    self.salaryInput.isHidden = false;
                }
            }
        }
    }
    
    var salaryBool: Bool? {
        didSet {
            if salaryBool! {
                DispatchQueue.main.async {
                    self.yesSalaryButton.backgroundColor = .darkGray2;
                    self.yesSalaryButton.tintColor = .mainLav;
                    self.noSalaryButton.backgroundColor = .mainLav;
                    self.noSalaryButton.tintColor = .darkGray2;
                }
            }
            if !salaryBool! {
                DispatchQueue.main.async {
                    self.noSalaryButton.backgroundColor = .darkGray2;
                    self.noSalaryButton.tintColor = .mainLav;
                    self.yesSalaryButton.backgroundColor = .mainLav;
                    self.yesSalaryButton.tintColor = .darkGray2;
                }
            }
        }
    }
    
    var hourlyBool: Bool? {
        didSet {
            if hourlyBool! {
                DispatchQueue.main.async {
                    self.yesHourlyButton.backgroundColor = .darkGray2;
                    self.yesHourlyButton.tintColor = .mainLav;
                    self.noHourlyButton.backgroundColor = .mainLav;
                    self.noHourlyButton.tintColor = .darkGray2;
                }
            }
            if !hourlyBool! {
                DispatchQueue.main.async {
                    self.noHourlyButton.backgroundColor = .darkGray2;
                    self.noHourlyButton.tintColor = .mainLav;
                    self.yesHourlyButton.backgroundColor = .mainLav;
                    self.yesHourlyButton.tintColor = .darkGray2;
                }
            }
        }
    }
    
    var productCommission: Bool? {
        didSet {
            if let serviceCommission = serviceCommission, let productCommission = productCommission {
                if !serviceCommission && !productCommission {
                    DispatchQueue.main.async {
                        self.noCommissionButton.backgroundColor = .darkGray2;
                        self.noCommissionButton.tintColor = .mainLav;
                        self.yesCommissionButton.backgroundColor = .mainLav;
                        self.yesCommissionButton.tintColor = .darkGray2;
                        self.productButton.tintColor = .black;
                        self.productButton.backgroundColor = .mainLav;
                        self.serviceButton.tintColor = .black;
                        self.serviceButton.backgroundColor = .mainLav;
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.productButton.isHidden = false;
                        self.serviceButton.isHidden = false;
                        self.noCommissionButton.tintColor = .black;
                        self.noCommissionButton.backgroundColor = .mainLav;
                    }
                }
            }
            if productCommission! {
                DispatchQueue.main.async {
                    self.productButton.backgroundColor = .darkGray2;
                    self.productButton.tintColor = .mainLav;
                    self.yesCommissionButton.backgroundColor = .darkGray2;
                    self.yesCommissionButton.tintColor = .mainLav;
                    self.productButton.isHidden = false;
                }
            }
            if !productCommission! {
                DispatchQueue.main.async {
                    self.productButton.backgroundColor = .mainLav;
                    self.productButton.tintColor = .darkGray2;
                }
            }
            if let serviceCommission = serviceCommission, let productCommission = productCommission {
                if !serviceCommission && !productCommission {
                    DispatchQueue.main.async {
                        self.noCommissionButton.backgroundColor = .darkGray2;
                        self.noCommissionButton.tintColor = .mainLav;
                    }
                }
                else {
                    
                }
            }
        }
    }
    
    var serviceCommission: Bool? {
        didSet {
            if let serviceCommission = serviceCommission, let productCommission = productCommission {
                if !serviceCommission && !productCommission {
                    DispatchQueue.main.async {
                        self.noCommissionButton.backgroundColor = .darkGray2;
                        self.noCommissionButton.tintColor = .mainLav;
                        self.yesCommissionButton.backgroundColor = .mainLav;
                        self.yesCommissionButton.tintColor = .black;
                        self.productButton.tintColor = .black;
                        self.productButton.backgroundColor = .mainLav;
                        self.serviceButton.tintColor = .black;
                        self.serviceButton.backgroundColor = .mainLav;
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.productButton.isHidden = false;
                        self.serviceButton.isHidden = false;
                        self.noCommissionButton.tintColor = .black;
                        self.noCommissionButton.backgroundColor = .mainLav;
                    }
                }
            }
            if serviceCommission! {
                DispatchQueue.main.async {
                    self.serviceButton.backgroundColor = .darkGray2;
                    self.serviceButton.tintColor = .mainLav;
                    self.yesCommissionButton.backgroundColor = .darkGray2;
                    self.yesCommissionButton.tintColor = .mainLav;
                    self.serviceButton.isHidden = false;
                }
            }
            if !serviceCommission! {
                DispatchQueue.main.async {
                    self.serviceButton.backgroundColor = .mainLav;
                    self.serviceButton.tintColor = .darkGray2;
                }
            }
            if let serviceCommission = serviceCommission, let productCommission = productCommission {
                if !serviceCommission && !productCommission {
                    DispatchQueue.main.async {
                        self.noCommissionButton.backgroundColor = .darkGray2;
                        self.noCommissionButton.tintColor = .mainLav;
                    }
                }
            }
        }
    }
    
    var productPercent: String? {
        didSet {
            if productPercent! != "nil" {
                DispatchQueue.main.async {
                    self.productsCommissionDropdown.isHidden = false;
                    self.productsCommissionDropdown.selectedItem = self.productsCommissionDropdown.data[Int(self.productPercent!)!]
                    self.productsCommissionDropdown.selectRow(Int(self.productPercent!)!, inComponent: 0, animated: true);
                }
            }
            else {
                DispatchQueue.main.async {
                    self.productsCommissionDropdown.isHidden = true;
                    self.productsCommissionDropdown.selectedItem = self.productsCommissionDropdown.data[0];
                    self.productsCommissionDropdown.selectRow(0, inComponent: 0, animated: true);
                    self.productButton.isHidden = true;
                }
            }
        }
    }
    
    var servicePercent: String? {
        didSet {
            if servicePercent! != "nil" {
                DispatchQueue.main.async {
                    self.servicesCommissionDropdown.isHidden = false;
                    self.servicesCommissionDropdown.selectedItem = self.productsCommissionDropdown.data[Int(self.productPercent!)!]
                    self.servicesCommissionDropdown.selectRow(Int(self.servicePercent!)!, inComponent: 0, animated: true);
                }
            }
            else {
                DispatchQueue.main.async {
                    self.servicesCommissionDropdown.isHidden = true;
                    self.servicesCommissionDropdown.selectedItem = self.productsCommissionDropdown.data[0];
                    self.servicesCommissionDropdown.selectRow(0, inComponent: 0, animated: true);
                    self.serviceButton.isHidden = true;
                }
            }
        }
    }
    

    
    private let salaryQuestion = Components().createNotAsLittleText(text: "Get paid by salary?", color: .mainLav);
    
    private let salaryTextField = Components().createTextField(placeHolder: "Employee Salary", fontSize: 18);
    
    lazy var salaryInput = Components().createInput(textField: salaryTextField, view: view, width: fullWidth / 1.8);
    
    lazy var yesSalaryButton: UIButton = {
           let uib = Components().createGoodButton(title: "Yes");
           uib.addTarget(self, action: #selector(yesSalaryHit), for: .touchUpInside);
           return uib;
    }()
       
    lazy var noSalaryButton: UIButton = {
           let uib = Components().createGoodButton(title: "No");
           uib.addTarget(self, action: #selector(noSalaryHit), for: .touchUpInside);
           return uib;
    }()
    
    private let doesEmployeeText: UITextView = {
        let uitv = Components().createNotAsLittleText(text: "Does this employee...", color: .mainLav);
        return uitv;
    }();
    
    
    @objc func yesSalaryHit() {
        dollar1.isHidden = false;
        salaryInput.isHidden = false;
        salaryBool = true;
    }
    
    @objc func noSalaryHit() {
        dollar1.isHidden = true;
        salaryInput.isHidden = true;
        salaryBool = false;
    }
    
    private let hourlyWageQuestion = Components().createNotAsLittleText(text: "Get paid hourly?", color: .mainLav);
    
    private let hourlyWageTextField = Components().createTextField(placeHolder: "Employee Hourly Wage", fontSize: 18);
    
    private let dollar = Components().createNotAsLittleText(text: "$", color: .mainLav);
    
    private let dollar1 = Components().createNotAsLittleText(text: "$", color: .mainLav);
    
    lazy var hourlyWageInput = Components().createInput(textField: hourlyWageTextField, view: view, width: fullWidth / 1.85);
    
    lazy var yesHourlyButton: UIButton = {
           let uib = Components().createGoodButton(title: "Yes");
           uib.addTarget(self, action: #selector(yesHourlyHit), for: .touchUpInside);
           return uib;
    }()
       
    lazy var noHourlyButton: UIButton = {
           let uib = Components().createGoodButton(title: "No");
           uib.addTarget(self, action: #selector(noHourlyHit), for: .touchUpInside);
           return uib;
    }()
    
    
    @objc func yesHourlyHit() {
        dollar.isHidden = false;
        hourlyWageInput.isHidden = false;
        hourlyBool = true;
     
    }
    
    @objc func noHourlyHit() {
        dollar.isHidden = true;
        hourlyWageInput.isHidden = true;
        hourlyBool = false;
        
    }
    
    private let commissionQuestion = Components().createNotAsLittleText(text: "Earn commission?", color: .mainLav);
    
    private let servicesCommissionPercentText = Components().createNotAsLittleText(text: "Service percent:", color: .mainLav);
    
    private let servicesCommissionDropdown: GenericDropDown = {
        let gdd = GenericDropDown();
        gdd.data = ["% Earned","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100"];
        gdd.setWidth(width: 160);
        gdd.setHeight(height: 75);
        return gdd;
    }()
    
    private let productsCommissionPercentText = Components().createNotAsLittleText(text: "Product Percent", color: .mainLav);
    
    private let productsCommissionDropdown: GenericDropDown = {
        let gdd = GenericDropDown();
        gdd.data = ["% Earned","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100"];
        gdd.setWidth(width: 160);
        gdd.setHeight(height: 75);
        return gdd;
    }()
    
    lazy var yesCommissionButton: UIButton = {
           let uib = Components().createGoodButton(title: "Yes");
           uib.addTarget(self, action: #selector(yesCommissionHit), for: .touchUpInside);
           return uib;
    }()
       
    lazy var noCommissionButton: UIButton = {
           let uib = Components().createGoodButton(title: "No");
           uib.addTarget(self, action: #selector(noCommissionHit), for: .touchUpInside);
           return uib;
    }()
    
    
    @objc func yesCommissionHit() {
        yesCommissionButton.tintColor = .mainLav;
        yesCommissionButton.backgroundColor = .darkGray2;
        noCommissionButton.tintColor = .darkGray2;
        noCommissionButton.backgroundColor = .mainLav;
        productButton.isHidden = false;
        serviceButton.isHidden = false;
    }
    
    @objc func noCommissionHit() {
        noCommissionButton.tintColor = .mainLav;
        noCommissionButton.backgroundColor = .darkGray2;
        yesCommissionButton.tintColor = .darkGray2;
        yesCommissionButton.backgroundColor = .mainLav;
        productButton.isHidden = true;
        serviceButton.isHidden = true;
        productCommission = false;
        serviceCommission = false;
        servicesCommissionDropdown.isHidden = true;
        productsCommissionDropdown.isHidden = true;
    }
    
    lazy var productButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.layer.borderColor = CGColor.CGBlack;
        uib.layer.borderWidth = 1.0;
        uib.setHeight(height: 30);
        uib.setWidth(width: 155);
        uib.setTitle("Product Commission?", for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(productHit), for: .touchUpInside);
        return uib;
    }()
       
    lazy var serviceButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.layer.borderColor = CGColor.CGBlack;
        uib.layer.borderWidth = 1.0;
        uib.setHeight(height: 30);
        uib.setWidth(width: 155);
        uib.setTitle("Service Commission?", for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(serviceHit), for: .touchUpInside);
        return uib;
    }()
    
    
    @objc func productHit() {
        if productCommission == nil || productCommission == false {
            productsCommissionDropdown.isHidden = false;
            productCommission = true;
            productButton.backgroundColor = .darkGray2;
            productButton.tintColor = .mainLav;
        }
        else {
            productsCommissionDropdown.isHidden = true;
            productCommission = false;
            productButton.backgroundColor = .mainLav;
            productButton.tintColor = .darkGray2;
        }
    }
    
    @objc func serviceHit() {
        if serviceCommission == nil || serviceCommission == false {
            servicesCommissionDropdown.isHidden = false;
            serviceCommission = true;
            serviceButton.backgroundColor = .darkGray2;
            serviceButton.tintColor = .mainLav;
        }
        else {
            servicesCommissionDropdown.isHidden = true;
            serviceCommission = false;
            serviceButton.backgroundColor = .mainLav;
            serviceButton.tintColor = .darkGray2;
        }
    }
    
    
       

    private var employees: [Employee]? {
        didSet {
            guard let employees = employees else {
                return
            }
            employeeDropDown.employees = employees;
        }
    }
    
    private let employeeDropDown = EmployeeDropdown();
    
    private let selectEmployeeText = Components().createNotAsLittleText(text: "Select Employee:", color: .mainLav);
    
    lazy var directionsButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setTitle("Directions", for: .normal);
        uib.addTarget(self, action: #selector(goToDirections), for: .touchUpInside);
        return uib;
    }();
    
    @objc func goToDirections() {
        print("YOOOOO")
        self.present(PayrollDirections(), animated: true, completion: nil);
        getEmployees();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        config();
        getEmployees();
    }
    
    @objc func done() {
        self.dismiss(animated: true, completion: nil);
    }
    
    private let saveInfoButton: UIButton = {
        let uib = Components().createIncredibleButton(title: "Save Employee Info", width: 166, fontSize: 18, height: 40);
        uib.addTarget(self, action: #selector(saveEmployeeInfo), for: .touchUpInside);
        return uib;
    }()
    
    @objc func saveEmployeeInfo() {
        API().post(url: myURL + "payroll/createEditEmployee", headerToSend: Utilities().getAdminToken(), dataToSend: ["paidSalary": self.salaryBool, "paidHourly": self.hourlyBool, "salary": salaryTextField.text, "hourly": hourlyWageTextField.text, "pcp": productsCommissionDropdown.selectedItem, "scp": servicesCommissionDropdown.selectedItem, "productCommission": productCommission, "serviceCommission": serviceCommission, "employeeId": employeeDropDown.selectedItem?.id]) { res in
            if res["statusCode"] as? Int == 200 {
                let alert = Components().createActionAlert(title: "Employee Info Saved!", message: "The employee payroll information has been saved!", buttonTitle: "Awesome", handler: nil);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }
    
    func config() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done));
        navigationItem.title = "Payroll Suite Setup";
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: directionsButton);
        view.addSubview(selectEmployeeText);
        selectEmployeeText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 20);
        selectEmployeeText.padLeft(from: view.leftAnchor, num: 10);
        view.addSubview(employeeDropDown);
        employeeDropDown.padLeft(from: selectEmployeeText.rightAnchor, num: 20);
        employeeDropDown.padTop(from: selectEmployeeText.topAnchor, num: -22);
        employeeDropDown.setHeight(height: 80);
        employeeDropDown.setWidth(width: 200);
        employeeDropDown.chooseEmployeeDelegate = self;
        view.addSubview(doesEmployeeText);
        doesEmployeeText.padTop(from: selectEmployeeText.bottomAnchor, num: 15);
        doesEmployeeText.padLeft(from: view.leftAnchor, num: 10);
        view.addSubview(hourlyWageQuestion);
        hourlyWageQuestion.padTop(from: doesEmployeeText.bottomAnchor, num: 15);
        hourlyWageQuestion.padLeft(from: view.leftAnchor, num: 10);
        view.addSubview(noHourlyButton);
        noHourlyButton.padTop(from: hourlyWageQuestion.topAnchor, num: 5);
        noHourlyButton.padLeft(from: hourlyWageQuestion.rightAnchor, num: 40);
        view.addSubview(yesHourlyButton);
        yesHourlyButton.padTop(from: noHourlyButton.topAnchor, num: 0);
        yesHourlyButton.padLeft(from: noHourlyButton.rightAnchor, num: 20);
        view.addSubview(hourlyWageInput);
        hourlyWageInput.isHidden = true;
        hourlyWageInput.padTop(from: hourlyWageQuestion.bottomAnchor, num: 8);
        hourlyWageInput.padLeft(from: view.leftAnchor, num: 32);
        view.addSubview(dollar);
        dollar.isHidden = true;
        dollar.padTop(from: hourlyWageInput.topAnchor, num: 2);
        dollar.padRight(from: hourlyWageInput.leftAnchor, num: -2);
        view.addSubview(salaryQuestion);
        salaryQuestion.padTop(from: hourlyWageInput.bottomAnchor, num: 15);
        salaryQuestion.padLeft(from: view.leftAnchor, num: 10);
        view.addSubview(noSalaryButton);
        noSalaryButton.padTop(from: salaryQuestion.topAnchor, num: 5);
        noSalaryButton.padLeft(from: noHourlyButton.leftAnchor, num: 0);
        view.addSubview(yesSalaryButton);
        yesSalaryButton.padTop(from: noSalaryButton.topAnchor, num: 0);
        yesSalaryButton.padLeft(from: noSalaryButton.rightAnchor, num: 20);
        view.addSubview(salaryInput);
        salaryInput.isHidden = true;
        salaryInput.padTop(from: salaryQuestion.bottomAnchor, num: 10);
        salaryInput.padLeft(from: view.leftAnchor, num: 32);
        view.addSubview(dollar1);
        dollar1.isHidden = true;
        dollar1.padTop(from: salaryInput.topAnchor, num: 2);
        dollar1.padRight(from: salaryInput.leftAnchor, num: -2);
        view.addSubview(commissionQuestion);
        commissionQuestion.padTop(from: salaryInput.bottomAnchor, num: 15);
        commissionQuestion.padLeft(from: view.leftAnchor, num: 10);
        view.addSubview(noCommissionButton);
        noCommissionButton.padTop(from: commissionQuestion.topAnchor, num: 5);
        noCommissionButton.padLeft(from: noHourlyButton.leftAnchor, num: 0);
        view.addSubview(yesCommissionButton);
        yesCommissionButton.padTop(from: noCommissionButton.topAnchor, num: 0);
        yesCommissionButton.padLeft(from: noCommissionButton.rightAnchor, num: 20);
        view.addSubview(productButton);
        productButton.isHidden = true;
        productButton.padTop(from: commissionQuestion.bottomAnchor, num: 15);
        productButton.padLeft(from: view.leftAnchor, num: fullWidth * 0.05);
        view.addSubview(serviceButton);
        serviceButton.isHidden = true;
        serviceButton.padTop(from: productButton.topAnchor, num: 0);
        serviceButton.padRight(from: view.rightAnchor, num: fullWidth * 0.05);
        view.addSubview(productsCommissionDropdown);
        productsCommissionDropdown.isHidden = true;
        productsCommissionDropdown.padLeft(from: productButton.leftAnchor, num: 0);
        productsCommissionDropdown.padTop(from: productButton.bottomAnchor, num: 5);
        view.addSubview(servicesCommissionDropdown);
        servicesCommissionDropdown.isHidden = true;
        servicesCommissionDropdown.padRight(from: serviceButton.rightAnchor, num: 0);
        servicesCommissionDropdown.padTop(from: serviceButton.bottomAnchor, num: 5);
        view.addSubview(saveInfoButton);
        saveInfoButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 30);
        saveInfoButton.centerTo(element: view.centerXAnchor);

    }
    
    func getEmployees() {
        API().get(url: myURL + "getEmployees", headerToSend: Utilities().getAdminToken()) { res in
            if let employeesBack = res["employees"] as? [[String: String]] {
                var employeeArray: [Employee] = [];
                for employee in employeesBack {
                    employeeArray.append(Employee(dic: employee));
                }
                self.employees = employeeArray;
            }
        }
    }

}
