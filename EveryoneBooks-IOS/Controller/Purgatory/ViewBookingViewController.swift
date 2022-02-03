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

protocol EditProductsDelegate: ViewBookingViewController {
    func removeProduct(product: Product, index: Int);
}

class ViewBookingViewController: UIViewController, EditServicesDelegate, EditProductsDelegate {
    
    func removeProduct(product: Product, index: Int) {
        let alertController = UIAlertController(title: "Remove Product:", message: "Please confirm that you would like to remove " + product.name + " from this booking.", preferredStyle: .alert);
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { UIAlertAction in
            self.productsInBooking?.remove(at: index);
            API().post(url: myURL + "products/removeProducts", dataToSend: ["bookingId": self.booking!.id, "productId": product.id]) { res in
                if let newCost = res["newCost"] as? String {
                    DispatchQueue.main.async {
                        self.costText.text = newCost;
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        alertController.addAction(cancelAction);
        alertController.addAction(confirmAction);
        self.present(alertController, animated: true, completion: nil);
    }
   
    func removeService(service: Service, index: Int) {
        if services!.count == 1 {
            let alert = Components().createActionAlert(title: "Service Removal Error", message: "Each booking needs at least one service. If you no longer want this booking to exist. Please click the delete button below.", buttonTitle: "Okay!", handler: nil);
            self.present(alert, animated: true, completion: nil);
            return;
        }
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
    
    // MARK: Product Properties
    
    // Product Already in Booking
    
    var productsInBooking: [Product]? {
        didSet {
            editProductsTable.products = productsInBooking;
        }
    }
    
    // Products that business has
    
    var products: [Product]? {
        didSet {
            productsTable.data = products;
        }
    }
    
    var booking: Booking? {
        didSet {
            API().post(url: myURL + "getBookings/moreBookingInfo", dataToSend: ["bookingId": booking!.id]) { (res) in
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
                if let productsComingBack = res["products"] as? [[String: Any]] {
                    var productsHereArray: [Product] = [];
                    for iProduct in productsComingBack {
                        let realProduct = Product(name: iProduct["name"] as! String, price: iProduct["cost"] as! String, idParam: iProduct["_id"] as! String);
                        productsHereArray.append(realProduct);
                    }
                    self.productsInBooking = productsHereArray;
                }
            }
            if Utilities().getToken() == "nil" {
                getServices(businessId: booking!.businessId!)
                getProducts(businessId: booking!.businessId!);
            }
        }
    }
    
    // MARK: Edit Products Services Table
    
    private let editProductsTable: EditProductsTable = {
        let ept = EditProductsTable();
        ept.backgroundColor = .mainLav;
        return ept;
    }();
    
    private let editServicesTable: EditServicesTable = {
        let est = EditServicesTable();
        est.backgroundColor = .mainLav;
        return est;
    }();
        
    
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
    
    private let employeeNameHeader = Components().createLittleText(text: "Employee Name:", color: .mainLav);
    
    private let employeeNameText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let customerNameHeader = Components().createLittleText(text: "Customer Name:", color: .mainLav);
    
    private let customerNameText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let customerPhoneHeader = Components().createLittleText(text: "Customer Phone:", color: .mainLav);
    
    private let customerPhoneText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let timeOfServiceHeader = Components().createLittleText(text: "Time of Serivce:", color: .mainLav);
    
    private let timeOfServiceText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let dateHeader = Components().createLittleText(text: "Date of Service:", color: .mainLav);
    
    private let dateText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let costHeader = Components().createLittleText(text: "Cost of Service:", color: .mainLav);
    
    private let costText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let servicesText = Components().createLittleText(text: "Services", color: .mainLav);
    
    private let productsText = Components().createLittleText(text: "Products", color: .mainLav)
    
    private let addServicesText = Components().createLittleText(text: "Add Services");
    
    private let addProductsText = Components().createLittleText(text: "Add Products");
    
    
    
    
    // MARK: BEBGIN BORDERS CREATING BOX
    
    private let middleBorder = Components().createBorder(height: 35, width: 1.5, color: .black);
    
    private let addServicesTopBorder = Components().createBorder(height: 1.5, width: 103, color: .black);
    
    private let addServicesLeftBorder = Components().createBorder(height: 35, width: 1.5, color: .black);
    
    private let addServicesBottomBorder = Components().createBorder(height: 1.5, width: 103, color: .black);
    
    private let addProductsTopBorder = Components().createBorder(height: 1.5, width: 117, color: .black);
    
    private let addProductsRightBorder = Components().createBorder(height: 35, width: 1.5, color: .black);
    
    private let addProductsBottomBorder = Components().createBorder(height: 1.5, width: 117, color: .black);

    private let leftBorder = Components().createBorder(height: 200, width: 1.5, color: .black);
    
    private let bottomBorder = Components().createBorder(height: 1.5, width: 220, color: .black);
    
    private let rightBorder = Components().createBorder(height: 200, width: 1.5, color: .black);
    
    
    // MARK: Set Up Borders Func
    
    func setUpBorders() {
        view.addSubview(middleBorder);
        middleBorder.padLeft(from: addServicesText.rightAnchor, num: 0);
        middleBorder.padTop(from: addServicesText.topAnchor, num: -5);
        view.addSubview(addServicesTopBorder);
        if Utilities().getToken() == "nil" {
            addServicesTopBorder.padBottom(from: addServicesText.topAnchor, num: 4);
            addServicesTopBorder.padRight(from: middleBorder.leftAnchor, num: 0);
            view.addSubview(addServicesLeftBorder);
            addServicesLeftBorder.padTop(from: addServicesTopBorder.bottomAnchor, num: 0);
            addServicesLeftBorder.padLeft(from: addServicesTopBorder.leftAnchor, num: 0);
            view.addSubview(addServicesBottomBorder);
            addServicesBottomBorder.padLeft(from: addServicesLeftBorder.rightAnchor, num: 0);
            addServicesBottomBorder.padBottom(from: addServicesLeftBorder.bottomAnchor, num: 0);
            addServicesBottomBorder.isHidden = true;
            view.addSubview(leftBorder);
            leftBorder.padTop(from: addServicesLeftBorder.bottomAnchor, num: 0);
            leftBorder.padLeft(from: addServicesLeftBorder.leftAnchor, num: 0);
            view.addSubview(bottomBorder);
            bottomBorder.padTop(from: leftBorder.bottomAnchor, num: 0);
            bottomBorder.padLeft(from: leftBorder.leftAnchor, num: 0);
            view.addSubview(rightBorder);
            rightBorder.padBottom(from: bottomBorder.topAnchor, num: 0);
            rightBorder.padRight(from: view.rightAnchor, num: 3);
            view.addSubview(addProductsBottomBorder);
            addProductsBottomBorder.padLeft(from: middleBorder.leftAnchor, num: 0)
            addProductsBottomBorder.padTop(from: middleBorder.bottomAnchor, num: 0);
            view.addSubview(addProductsRightBorder);
            addProductsRightBorder.padRight(from: view.rightAnchor, num: 3);
            addProductsRightBorder.padTop(from: addServicesTopBorder.bottomAnchor, num: 0);
            addProductsRightBorder.isHidden = true;
            view.addSubview(addProductsTopBorder);
            addProductsTopBorder.padTop(from: addServicesTopBorder.topAnchor, num: 0);
            addProductsTopBorder.padRight(from: addProductsRightBorder.rightAnchor, num: 0);
            addProductsTopBorder.isHidden = true;
        }
    }
    
    
    
    // MARK: Services Products Gestures
    
    func addServicesProductsGesture() {
        let tapServices = UITapGestureRecognizer(target: self, action: #selector(servicesTapped));
        addServicesText.addGestureRecognizer(tapServices);
        let tapProducts = UITapGestureRecognizer(target: self, action: #selector(productsTapped));
        addProductsText.addGestureRecognizer(tapProducts);
    }
    
    // MARK: Services Products Gestures
    
    @objc func servicesTapped(_ sender: UITapGestureRecognizer? = nil) {
        self.addProductsBottomBorder.isHidden = false;
        self.addProductsTopBorder.isHidden = true;
        self.addProductsRightBorder.isHidden = true;
        self.addServicesBottomBorder.isHidden = true;
        self.addServicesTopBorder.isHidden = false;
        self.addServicesLeftBorder.isHidden = false;
        productsTable.isHidden = true;
        servicesTable.isHidden = false;
        addProductsButton.isHidden = true;
        editProductsTable.isHidden = true;
        editServicesTable.isHidden = false;
        productsText.isHidden = true;
        servicesText.isHidden = false;
    }
    
    @objc func productsTapped(_ sender: UITapGestureRecognizer? = nil) {
        addProductsBottomBorder.isHidden = true;
        addProductsTopBorder.isHidden = false;
        addProductsRightBorder.isHidden = false;
        addServicesBottomBorder.isHidden = false;
        addServicesTopBorder.isHidden = true;
        addServicesLeftBorder.isHidden = true;
        servicesTable.isHidden = true;
        productsTable.isHidden = false;
        addProductsButton.isHidden = false;
        editServicesTable.isHidden = true;
        editProductsTable.isHidden = false;
        servicesText.isHidden = true;
        productsText.isHidden = false;
        
    }
    
    
    // MARK: Services And Prodcuts Table
    
    private let servicesTable: ServicesTable = {
        let st = ServicesTable();
        st.unselectedCellBackgroundColor = .mainLav;
        st.backgroundColor = .mainLav;
        return st;
    }()
    
    private let productsTable: ProductsTable = {
        let pt = ProductsTable();
        pt.unselectedCellBackgroundColor = .mainLav;
        pt.backgroundColor = .mainLav;
        return pt;
    }()
    
    // MARK: Add Services Products
    
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
    
    private let addProductsButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Add Products Selected", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]), for: .normal);
        uib.backgroundColor = .liteGray;
        uib.layer.borderColor = .CGBlack;
        uib.layer.borderWidth = 0.8;
        uib.layer.cornerRadius = 3;
        uib.setHeight(height: 40);
        uib.setWidth(width: fullWidth / 1.2);
        uib.addTarget(self, action: #selector(addProduct), for: .touchUpInside);
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
    
    // MARK: Button Functions ACP
    
    @objc func addProduct() {
        if productsTable.selectedProducts.count == 0 {
            let alert = Components().createActionAlert(title: "Product Error", message: "Please select a product to add.", buttonTitle: "Okay!", handler: nil);
            self.present(alert, animated: true, completion: nil);
        }
        else {
            for selectedProduct in productsTable.selectedProducts {
                var i = 0;
                while i < productsInBooking!.count {
                    if productsInBooking![i].id == selectedProduct.id {
                        let actionError = Components().createActionAlert(title: "Product Already Added", message: "One or more of the products that you attempted to add is already added in this booking.", buttonTitle: "Oops, okay!", handler: nil);
                        self.present(actionError, animated: true, completion: nil);
                        return;
                    }
                    i += 1;
                }
            }
            var productIds: [String] = [];
            for product in productsTable.selectedProducts {
                productIds.append(product.id!);
            }
            API().post(url: myURL + "products/addProducts", dataToSend: ["bookingId": booking!.id, "productIds": productIds]) { res in
                if res["statusCode"] as! Int == 200 {

                    for productsSelected in self.productsTable.selectedProducts {
                        self.productsInBooking?.append(productsSelected);
                    }
                    if let newCost = res["newCost"] as? String {
                        DispatchQueue.main.async {
                            self.costText.text = newCost;
                        }
                    }
                }
            }
        }
    }
    
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
        if Utilities().getToken() == "nil" {
            print("WHAT")
            if self.services!.count == 0 {
                let alert = Components().createActionAlert(title: "No Services Error", message: "Please add at least one service to this booking otherwise it will be deleted.", buttonTitle: "Woops, Okay!", handler: nil);
                self.present(alert, animated: true, completion: nil);
            }
            else {
                navigationController?.popViewController(animated: true);
            }
        }
        else {
            print("what");
            navigationController?.popViewController(animated: true);
        }
    }
    
    @objc func addService() {
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
                    if res["statusCode"] as! Int == 400 {
                        let alert = Components().createActionAlert(title: "Time Error", message: "Adding these service(s) to this booking will make the booking overlap with the next booking.", buttonTitle: "Okay!", handler: nil);
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil);
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.hidesBackButton = true;
        configureView();
        handleLogo();
        addServicesProductsGesture()
    }
    
    func configureView() {
        view.backgroundColor = .mainLav;
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exitButton);
        view.addSubview(employeeNameHeader);
        employeeNameHeader.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 12);
        employeeNameHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(employeeNameText);
        employeeNameText.padTop(from: employeeNameHeader.bottomAnchor, num: -10);
        employeeNameText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerNameHeader);
        customerNameHeader.padTop(from: employeeNameText.bottomAnchor, num: 16);
        customerNameHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerNameText);
        customerNameText.padTop(from: customerNameHeader.bottomAnchor, num: -10);
        customerNameText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerPhoneHeader);
        customerPhoneHeader.padTop(from: customerNameText.bottomAnchor, num: 16);
        customerPhoneHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(customerPhoneText);
        customerPhoneText.padTop(from: customerPhoneHeader.bottomAnchor, num: -10);
        customerPhoneText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(timeOfServiceHeader);
        timeOfServiceHeader.padTop(from: customerPhoneText.bottomAnchor, num: 16);
        timeOfServiceHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(timeOfServiceText);
        timeOfServiceText.padTop(from: timeOfServiceHeader.bottomAnchor, num: -10);
        timeOfServiceText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(dateHeader);
        dateHeader.padTop(from: timeOfServiceText.bottomAnchor, num: 16);
        dateHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(dateText);
        dateText.padTop(from: dateHeader.bottomAnchor, num: -10);
        dateText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(costHeader);
        costHeader.padTop(from: dateText.bottomAnchor, num: 16);
        costHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(costText);
        costText.padTop(from: costHeader.bottomAnchor, num: -10);
        costText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(servicesText)
        servicesText.padTop(from: employeeNameHeader.topAnchor, num: 0);
        servicesText.padRight(from: view.rightAnchor, num: 90);
        view.addSubview(productsText)
        productsText.padTop(from: employeeNameHeader.topAnchor, num: 0);
        productsText.padRight(from: view.rightAnchor, num: 90);
        productsText.isHidden = true;
        view.addSubview(editServicesTable);
        editServicesTable.otherDelegate = self;
        editServicesTable.setWidth(width: 200);
        editServicesTable.padRight(from: view.rightAnchor, num: 20);
        editServicesTable.padTop(from: servicesText.bottomAnchor, num: 0);
        editServicesTable.setHeight(height: 160);
        view.addSubview(editProductsTable);
        editProductsTable.otherDelegate = self;
        editProductsTable.setWidth(width: 200);
        editProductsTable.padRight(from: view.rightAnchor, num: 20);
        editProductsTable.padTop(from: servicesText.bottomAnchor, num: 0);
        editProductsTable.setHeight(height: 160);
        editProductsTable.isHidden = true;
        view.addSubview(addServicesText);
        addServicesText.padTop(from: editServicesTable.bottomAnchor, num: 20);
        addServicesText.padLeft(from: editServicesTable.leftAnchor, num: 0);
        view.addSubview(addProductsText);
        addProductsText.padTop(from: addServicesText.topAnchor, num: 0);
        addProductsText.padLeft(from: addServicesText.rightAnchor, num: 10);
        setUpBorders()
        view.addSubview(servicesTable);
        servicesTable.padTop(from: addServicesText.bottomAnchor, num: 0);
        servicesTable.padRight(from: view.rightAnchor, num: 5);
        servicesTable.setWidth(width: 217);
        servicesTable.setHeight(height: 195);
        view.addSubview(productsTable);
        productsTable.padTop(from: addServicesText.bottomAnchor, num: 0);
        productsTable.padRight(from: view.rightAnchor, num: 5);
        productsTable.setWidth(width: 217);
        productsTable.setHeight(height: 195);
        productsTable.isHidden = true;
        view.addSubview(addServicesButton);
        addServicesButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 10);
        addServicesButton.padRight(from: servicesTable.rightAnchor, num: 0);
        addServicesButton.setWidth(width: 175);
        view.addSubview(addProductsButton);
        addProductsButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 10);
        addProductsButton.padRight(from: servicesTable.rightAnchor, num: 0);
        addProductsButton.setWidth(width: 175);
        addProductsButton.isHidden = true;
        view.addSubview(cancelBookingButton);
        cancelBookingButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 10);
        cancelBookingButton.padLeft(from: view.leftAnchor, num: 4);
        cancelBookingButton.setWidth(width: 172);
        cancelBookingButton.setHeight(height: 160);
        addServicesProductsGesture()
    }
    
    func handleLogo() {
            navigationController?.navigationBar.backgroundColor = .mainLav;
            navigationController?.navigationBar.barTintColor = .mainLav;
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
                }
            }
        }
    }
    
    func getProducts(businessId: String) {
        API().post(url: myURL + "products", dataToSend: ["businessId": businessId]) { res in
    
            if let products = res["products"] as? [[String: Any]] {
                var productsArray: [Product] = [];
                for product in products {
                    productsArray.append(Product(name: product["name"] as! String, price: product["cost"] as! String, idParam: product["_id"] as! String))
                }
                self.products = productsArray;
               
            }
        }
    }
}
