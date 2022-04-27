import UIKit

protocol CustomerTableDelegateFromView: ViewGroupViewController {
    func delete(customerId: String, index: Int);
}

class ViewGroupViewController: UIViewController, CustomerTableDelegateFromView {
    
    func delete(customerId: String, index: Int) {
        customers?.remove(at: index);
        API().post(url: myURL + "groups/deleteCustomer", headerToSend: Utilities().getAdminToken(), dataToSend: ["customerId": customerId, "groupId": group?.id]) { res in
            if res["statusCode"] as! Int == 200 {
                print("great");
            }
        }
    }
    
    var group: Group? {
        didSet {
            API().post(url: myURL + "getBookings/moreGroupInfo", dataToSend: ["groupId": group!.id]) { (res) in
                if let employeeNameBack = res["employeeName"] as? String {
                    self.employeeName = employeeNameBack;
                }
                var customersArray: [Customer] = [];
                if let customersComingBack = res["customers"] as? [[String: Any]] {
                    for customer in customersComingBack {
                       var customer = Customer(dic: customer);
                        customersArray.append(customer);
                    }
                    self.customers = customersArray;
                    DispatchQueue.main.async {
                        self.costText.text = self.group?.price;
                        self.dateText.text = self.group?.date;
                        self.timeOfServiceText.text = self.group?.time;
                        self.employeeNameText.text = self.employeeName;
                    }
                }
            }
        }
    }
    
    lazy var exitButton: UIButton = {
        let uib = Components().createXButton();
        uib.addTarget(self, action: #selector(exit), for: .touchUpInside);
        return uib;
    }()
    
    // MARK: - Properties for Interface
    
    var customers: [Customer]? {
        didSet {
            customersTable.customers = self.customers;
        }
    }

    
    var employeeName: String?
    
    
    // MARK: - Interface
    
    private let employeeNameHeader = Components().createLittleText(text: "Employee Name:", color: .mainLav);
    
    private let employeeNameText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let timeOfServiceHeader = Components().createLittleText(text: "Time of Group:", color: .mainLav);
    
    private let timeOfServiceText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let dateHeader = Components().createLittleText(text: "Date of Group:", color: .mainLav);
    
    private let dateText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let costHeader = Components().createLittleText(text: "Cost of Group:", color: .mainLav);
    
    private let costText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let customersTable = CustomerTable();
    
    private let customersToAddTable = CustomerTable();
    
    var phone: String?;
    
    var newCustomers: [Customer] = [] {
        didSet {
            if newCustomers.count > 0 {
                DispatchQueue.main.async {
                    self.saveNewCustomersButton.isHidden = false;
                }
            }
        }
    }
    
    lazy var customerPhoneInput: UIView = {
        let uiv = Components().createInput(textField: customerPhoneTextField, view: view, width: fullWidth / 2.1);
        return uiv;
    }()
    
    private let customerPhoneTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Customer Phone", fontSize: 18);
        uitf.addTarget(self, action: #selector(sendPhone), for: .editingChanged);
        return uitf;
    }()
    
    @objc func sendPhone() {
        phone = customerPhoneTextField.text;
    }
    
    private let plusButton: UIButton = {
        let uib = UIButton(type: .system);
        let title = NSAttributedString(string: "+", attributes: [.font: UIFont.boldSystemFont(ofSize: 32), .foregroundColor: UIColor.black]);
        uib.setAttributedTitle(title, for: .normal);
        uib.addTarget(self, action: #selector(addCustomer), for: .touchUpInside);
        return uib;
    }();
    
    @objc func addCustomer() {
        if let phone = customerPhoneTextField.text {
            addCustomerToTable(phoneNumber: phone);
        }
    }
    
    func addCustomerToTable(phoneNumber: String) {
        API().post(url: myURL + "getCustomers/addNewCustomer", headerToSend: Utilities().getAdminToken(), dataToSend: ["phoneNumber": phoneNumber, "date": group?.date]) { res in
            if res["statusCode"] as? Int == 200 {
                if let customer = res["user"] as? [String: Any] {
                    if let customers = self.customers {
                        for customerInArray in customers {
                            if customerInArray.id == customer["_id"] as! String {
                                let alert = Components().createActionAlert(title: "Employee Error", message: "The employee you are trying to add has already been added.", buttonTitle: "Okay!", handler: nil);
                                DispatchQueue.main.async {
                                    self.present(alert, animated: true, completion: nil);
                                }
                                return;
                            }
                        }
                    }
                    let customerHere = Customer(dic: customer);
                    self.customers?.append(customerHere);
                    self.newCustomers.append(customerHere);
                }
            }
            else if res["statusCode"] as? Int == 400 || res["statusCode"] as? Int == 406 {
                let alert = Components().createActionAlert(title: "Phone Number Error", message: "We were not able to find any users linked to that phone number.", buttonTitle: "Okay!", handler: nil);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }

    private let customersText: UITextView = {
        let uitv = Components().createLittleText(text: "Customers:");
        uitv.textAlignment = .center;
        uitv.setWidth(width: fullWidth / 2.1);
        return uitv;
    }();
    
    private let addCustomersText: UITextView = {
        let uitv = Components().createLittleText(text: "Add Customer:");
        uitv.textAlignment = .center;
        uitv.setWidth(width: fullWidth / 2.1);
        return uitv;
    }();
    
    
    private let cancelGroupButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Cancel Booking", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal);
        uib.backgroundColor = UIColor(red: 1 , green: 0 , blue: 0, alpha: 0.45)
        uib.layer.borderColor = .CGBlack;
        uib.layer.borderWidth = 0.8;
        uib.layer.cornerRadius = 3;
        uib.setHeight(height: 40);
        uib.setWidth(width: fullWidth / 2);
        uib.addTarget(self, action: #selector(cancelBooking), for: .touchUpInside);
        return uib;
    }()
    
    private let saveNewCustomersButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Save New Customers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal);
        uib.backgroundColor = .literGray;
        uib.layer.borderColor = .CGBlack;
        uib.layer.borderWidth = 0.8;
        uib.layer.cornerRadius = 3;
        uib.setHeight(height: 40);
        uib.setWidth(width: fullWidth / 2.1 + 24);
        uib.addTarget(self, action: #selector(saveNewCustomas), for: .touchUpInside);
        return uib;
    }()
    
    @objc func saveNewCustomas() {
        if newCustomers.count == 0 {
            return;
        }
        var customersToSend: [String] = [];
        for customerToSend in newCustomers {
            customersToSend.append(customerToSend.id!);
        }
        API().post(url: myURL + "groups/newCustomersAdded", headerToSend: Utilities().getAdminToken(), dataToSend: ["customersArray": customersToSend, "groupId": group!.id]) { res in
            if res["statusCode"] as! Int == 200 {
                let alert = Components().createActionAlert(title: "Customers added!", message: "The new customers have been successfully added.", buttonTitle: "Okay!") { UIAlertAction in
                    self.saveNewCustomersButton.isHidden = true;
                    self.newCustomers = [];
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }
    
    
    
    
    // MARK: Button Functions ACP
    

    @objc func cancelBooking() {
        let alert = Components().createActionAlert(title: "Cancel Booking?", message: "Click okay to cancel this booking. This action is not reverisble!", buttonTitle: "Okay") { (UIAlertAction) in
            API().post(url: myURL + "groups/delete", headerToSend: Utilities().getAdminToken(), dataToSend: ["groupId": self.group!.id]) { (res) in
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
        navigationController?.popViewController(animated: true);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.hidesBackButton = true;
        configureView();
        handleLogo();
    }
    
    func configureView() {
        view.backgroundColor = .mainLav;
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exitButton);
        view.addSubview(employeeNameHeader);
        employeeNameHeader.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        employeeNameHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(employeeNameText);
        employeeNameText.padTop(from: employeeNameHeader.bottomAnchor, num: -10);
        employeeNameText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(timeOfServiceHeader);
        timeOfServiceHeader.padTop(from: employeeNameText.bottomAnchor, num: 10);
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
        view.addSubview(customersText);
        customersText.padRight(from: view.rightAnchor, num: 20);
        customersText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        view.addSubview(customersTable);
        customersTable.otherDel = self;
        customersTable.padTop(from: customersText.bottomAnchor, num: 0);
        customersTable.padRight(from: view.rightAnchor, num: 20);
        customersTable.setHeight(height: 140);
        customersTable.setWidth(width: view.frame.width / 2.1);
        customersTable.backgroundColor = .mainLav;
        view.addSubview(addCustomersText);
        addCustomersText.padRight(from: view.rightAnchor, num: 20);
        addCustomersText.padTop(from: customersTable.bottomAnchor, num: 4);
        view.addSubview(plusButton);
        plusButton.padRight(from: view.rightAnchor, num: 8);
        plusButton.padTop(from: addCustomersText.bottomAnchor, num: 0)
        view.addSubview(customerPhoneInput);
        customerPhoneInput.padRight(from: plusButton.leftAnchor, num: 4);
        customerPhoneInput.padTop(from: addCustomersText.bottomAnchor, num: 4);
        view.addSubview(saveNewCustomersButton);
        saveNewCustomersButton.isHidden = true;
        saveNewCustomersButton.padTop(from: customerPhoneInput.bottomAnchor, num: 10);
        saveNewCustomersButton.padRight(from: view.rightAnchor, num: 20);
        view.addSubview(cancelGroupButton);
        cancelGroupButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 20);
        cancelGroupButton.centerTo(element: view.centerXAnchor);
    }
    
    func handleLogo() {
            navigationController?.navigationBar.backgroundColor = .mainLav;
            navigationController?.navigationBar.barTintColor = .mainLav;
            navigationItem.title = "Group Details"
    }
}

