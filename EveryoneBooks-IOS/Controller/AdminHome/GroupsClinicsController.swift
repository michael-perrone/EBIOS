import UIKit

protocol CustomerTableDelegate: GroupsClinicsController {
    func deleteCustomer(customerId: String, index: Int);
}

class GroupsClinicsController: UIViewController, CustomerTableDelegate {
    
    func deleteCustomer(customerId: String, index: Int) {
        customers?.remove(at: index);
    }
    
    func addCustomerToTable(phoneNumber: String) {
        print(dateChosen)
        API().post(url: myURL + "getCustomers/addNewCustomer", headerToSend: Utilities().getAdminToken(), dataToSend: ["phoneNumber": phoneNumber, "date": dateChosen]) { res in
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
                    print(customer)
                    let customerHere = Customer(dic: customer);
                    print(customerHere)
                    print("below customer here");
                    self.customers?.append(customerHere);
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
    
    var customers: [Customer]? = [] {
        didSet {
            if let customers = customers {
                customerTable.customers = self.customers;
            }
        }
    }
    
    var dateChosen: String?;
    
    private let createGroupText = Components().createNotAsLittleText(text: "Create Group", color: .mainLav);
    
    private let employeeText = Components().createNotAsLittleText(text: "Employee:", color: .mainLav);
    
    private let timePicker1 = GenericDropDown();
    
    
    @objc func changedVal() {
        print("hello")
    }
    
    private let timePicker2 = GenericDropDown();
    
    private let customerTable: CustomerTable = {
        let customerTable = CustomerTable(frame: CGRect.zero, style: UITableView.Style.insetGrouped);
        customerTable.setHeight(height: fullHeight / 6);
        customerTable.setWidth(width: fullWidth / 1.3);
        customerTable.backgroundColor = .mainLav;
        return customerTable;
    }()
    
    private let datePicker: UIDatePicker = {
        let uidp = UIDatePicker();
        uidp.datePickerMode = .date;
        uidp.addTarget(self, action: #selector(dateChanged), for: .valueChanged);
        uidp.setHeight(height: 110);
        return uidp;
    }()
    
    private let employeesCollection: GenericCollectionHorizontal = {
        let employeesCollection = GenericCollectionHorizontal();
        return employeesCollection;
    }()
    
    private let bcnCollection: GenericCollectionHorizontal = {
        let employeesCollection = GenericCollectionHorizontal();
        return employeesCollection;
    }()
    
    
    @objc func dateChanged() {
        getTimes(date: datePicker.date);
    }
    
    var bcn: String? {
        didSet {
            var i = 1;
            var bcnArray: [HorItem] = [];
            while i <= Int(bcn!)! {
                bcnArray.append(HorItem(title: String(i), id: String(i)));
                i += 1;
            }
            bcnCollection.data = bcnArray;
        }
    }
    
    var bct: String? {
        didSet {
            DispatchQueue.main.async {
                self.bctText.text = self.bct! + ":";
            }
        }
    }
    
    var bctText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    
    var start: Int?;
    
    var closed = false;
    
    var closedTodayText = Components().createNotAsLittleText(text: "Business Closed", color: .mainLav);
    
    var close: Int? {
        didSet {
            var dataComing: [String] = [];
            guard var start = start, let close = close else {
                closed = true;
                DispatchQueue.main.async {
                    self.closedTodayText.isHidden = false;
                    self.timePicker1.isHidden = true;
                    self.timePicker2.isHidden = true;
                    self.dashText.isHidden = true;
                }
                return;
            }
            if closed {
                closed = false;
                DispatchQueue.main.async {
                    self.closedTodayText.isHidden = true;
                    self.timePicker1.isHidden = false;
                    self.timePicker2.isHidden = false;
                    self.dashText.isHidden = false;
                }

            }

            while start <= close {
                dataComing.append(Utilities.itst[start]!);
                start = start + 1;
            }
            timePicker1.data = dataComing;
            timePicker2.data = dataComing;
        }
    }
    
    func getTimes(date: Date) {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        self.dateChosen = df.string(from: date);
        API().post(url: myURL + "business/startEndTime", headerToSend: Utilities().getAdminToken(), dataToSend: ["date" : self.dateChosen]) { (res) in
            self.start = res["open"] as? Int;
            self.close = res["close"] as? Int;
        }
    }
    
    lazy var groupNameInput: UIView = {
        let uiv = Components().createInput(textField: groupNameTextField, view: view);
        return uiv;
    }()
    
    private let groupNameTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Enter Group Name", fontSize: 18);
        uitf.addTarget(self, action: #selector(sendGroupName), for: .editingChanged);
        return uitf;
    }()
    
    lazy var customerPhoneInput: UIView = {
        let uiv = Components().createInput(textField: customerPhoneTextField, view: view, width: fullWidth / 1.3);
        return uiv;
    }()
    
    private let customerPhoneTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Enter Customer Phone", fontSize: 18);
        uitf.addTarget(self, action: #selector(sendPhone), for: .editingChanged);
        return uitf;
    }()
    
    @objc func sendPhone() {
        phone = customerPhoneTextField.text;
    }
    
    lazy var priceInput: UIView = {
        let uiv = Components().createInput(textField: priceTextField, view: view);
        return uiv;
    }()
    
    private let priceTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Enter Group Price", fontSize: 18);
        uitf.addTarget(self, action: #selector(sendCost), for: .editingChanged);
        return uitf;
    }()
    
    @objc func sendCost() {
        self.price = priceTextField.text;
    }
    
    var price: String?;
    
    var phone: String?;
    
    var groupName: String?;
    
    @objc func sendGroupName() {
        groupName = groupNameTextField.text;
    }
    
    private let timeText = Components().createNotAsLittleText(text: "Time:", color: .mainLav);
    private let dateText = Components().createNotAsLittleText(text: "Date:", color: .mainLav);
    
    private let dollar = Components().createNotAsLittleText(text: "$", color: .mainLav);
    
    private let createButton: UIButton = {
        let uib = Components().createCoolButton(title: "Create Group");
        uib.addTarget(self, action: #selector(createGroup), for: .touchUpInside);
        return uib;
    }()
    
    @objc func createGroup() {
        guard let adminToken = Utilities().decodeAdminToken() else {
            Utilities().globalError(view: self);
            return;
        }
        if closed {
            let alert = Components().createActionAlert(title: "Business Closed", message: "Your business is closed today.", buttonTitle: "Okay!", handler: nil);
            self.present(alert, animated: true, completion: nil);
        }
        
        guard let businessId = adminToken["businessId"] as? String else { return };
        
        guard let price = price else {
            let alert = Components().createActionAlert(title: "Price Error", message: "Please fill out the price of this group and make sure it is a number.", buttonTitle: "Okay", handler: nil);
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil);
            }
            return;
        }
        guard let priceDouble = Double(price) else {
            let alert = Components().createActionAlert(title: "Price Error", message: "Please fill out the price of this group and make sure it is a number.", buttonTitle: "Okay", handler: nil);
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil);
            }
            return;
        }
        
        var customerIds: [String] = [];
        guard let customers = customers else {
            let alert = Components().createActionAlert(title: "No Customers", message: "Please add at least 1 customer to this group.", buttonTitle: "Okay!", handler: nil);
            present(alert, animated: true, completion: nil);
            return;
        }
        if customers.count > 0 {
            for customer in customers {
                customerIds.append(customer.id!);
            }
        }
        else {
            let alert = Components().createActionAlert(title: "No Customers", message: "Please add at least 1 customer to this group.", buttonTitle: "Okay!", handler: nil);
            present(alert, animated: true, completion: nil);
            return;
        }
        guard let employeeBooked = employeesCollection.selectedItem?.id else {
            let alert = Components().createActionAlert(title: "Employee Error", message: "Please choose the employee for this group.", buttonTitle: "Okay!", handler: nil);
            present(alert, animated: true, completion: nil);
            return;
        }
        guard let bcnSelected = bcnCollection.selectedItem?.title else {
            let alert = Components().createActionAlert(title: bct! +  " Error", message: "Please choose the " + bct! + " number for this group.", buttonTitle: "Okay!", handler: nil);
            present(alert, animated: true, completion: nil);
            return;
        }
        guard let groupName = groupName else {
            let alert = Components().createActionAlert(title: "Group Name Error", message: "Please enter the group name.", buttonTitle: "Okay!", handler: nil);
            present(alert, animated: true, completion: nil);
            return;
        }
        if Utilities.stit[timePicker1.selectedItem!]! >= Utilities.stit[timePicker2.selectedItem!]! {
            let alert = Components().createActionAlert(title: "Time Error", message: "Please adjust the group times with the first time being the start time of the group and the second time being the end time of the group.", buttonTitle: "Okay!", handler: nil);
            present(alert, animated: true, completion: nil);
            return;
        }
        let data = ["price": String(priceDouble), "startTime": timePicker1.selectedItem, "endTime": timePicker2.selectedItem, "businessId": businessId, "date": dateChosen, "employeeBooked": employeeBooked, "type": groupName, "customers": customerIds, "bcn": bcnSelected] as [String : Any];
        API().post(url: myURL + "groups/create", headerToSend: Utilities().getAdminToken(), dataToSend: data) { res in
            if res["statusCode"] as? Int == 200 {
                DispatchQueue.main.async {
                    let alert = Components().createActionAlert(title: "Group Created", message: "This group has been created. It will be visible in your schedule.", buttonTitle: "Okay!", handler: nil)
                    self.present(alert, animated: true, completion: nil);
                    self.groupNameTextField.text = "";
                    self.priceTextField.text = "";
                    self.customerPhoneTextField.text = "";
                    self.customers = [];
                }
            }
            if res["statusCode"] as? Int == 403 {
                if let bcnArray = res["bcnArray"] as? [Int] {
                    var helper1 = " are ";
                    var helper2 = "'s"
                    var string = " ";
                    var i = 0;
                    
                    if bcnArray.count == 1 {
                        helper1 = "is "
                        helper2 = "";
                    }
                    while i < bcnArray.count {
                        if (bcnArray[i] != bcnArray[bcnArray.count - 1]) {
                            string = string + String(bcnArray[i]) + ", ";
                        }
                        else {
                            string = string + String(bcnArray[i]);
                        }
                        i = i + 1;
                    }
                    if let bct = res["bct"] as? String {
                        let alert = Components().createActionAlert(title: bct + " available error", message: "The " + bct + " you are trying to book is not available at this time. " + bct + helper2 + string + helper1 + "available at this time.", buttonTitle: "Got it!", handler: nil)
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil);
                        }
                    }
                }
            }
            if res["statusCode"] as? Int == 404 {
                let alert = Components().createActionAlert(title: "Employee Error", message: "This employee already is scheduled at this time.", buttonTitle: "Okay!", handler: nil);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
            if res["statusCode"] as? Int == 403 {
                guard let cName = res["cName"] as? String else {return};
                let alert = Components().createActionAlert(title: "Customer Error", message: cName  + " is already scheduled for a booking at this time.", buttonTitle: "Okay!", handler: nil);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }

        }
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
    
    private let dashText = Components().createNotAsLittleText(text: "-", color: .mainLav);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getTimes(date: Date())
        view.backgroundColor = .mainLav;
        navigationItem.title = "Create Groups/Clinics";
    }
    
    func setUpView() {
        view.addSubview(groupNameInput);
        groupNameInput.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 2);
        groupNameInput.padLeft(from: view.leftAnchor, num: fullWidth / 12);
        view.addSubview(priceInput);
        priceInput.padTop(from: groupNameInput.bottomAnchor, num: 6);
        priceInput.padLeft(from: view.leftAnchor, num: fullWidth / 12);
        view.addSubview(customerPhoneInput);
        customerPhoneInput.padTop(from: priceInput.bottomAnchor, num: 6);
        customerPhoneInput.padLeft(from: view.leftAnchor, num: fullWidth / 12);
        view.addSubview(plusButton);
        plusButton.padLeft(from: customerPhoneInput.rightAnchor, num: 2);
        plusButton.padTop(from: customerPhoneInput.topAnchor, num: -10);
        view.addSubview(dollar);
        dollar.padTop(from: priceInput.topAnchor, num: 2);
        dollar.padRight(from: priceInput.leftAnchor, num: 0);
        view.addSubview(customerTable);
        customerTable.padTop(from: customerPhoneInput.bottomAnchor, num: 8);
        customerTable.padLeft(from: view.leftAnchor, num: fullWidth / 12);
        customerTable.del = self;
        view.addSubview(timeText);
        timeText.padTop(from: customerTable.bottomAnchor, num: 23);
        timeText.padLeft(from: view.leftAnchor, num: 15);
        view.addSubview(timePicker1);
        timePicker1.padTop(from: customerTable.bottomAnchor, num: 12);
        timePicker1.padLeft(from: timeText.rightAnchor, num: 0);
        view.addSubview(dashText);
        dashText.padLeft(from: timePicker1.rightAnchor, num: 0);
        dashText.padTop(from: timePicker1.topAnchor, num: 12);
        view.addSubview(timePicker2);
        timePicker2.padLeft(from: dashText.rightAnchor, num: 0);
        timePicker2.padTop(from: timePicker1.topAnchor, num: 0);
        view.addSubview(dateText);
        dateText.padTop(from: timeText.bottomAnchor, num: 30);
        dateText.padLeft(from: view.leftAnchor, num: 15);
        view.addSubview(datePicker);
        datePicker.padLeft(from: dateText.rightAnchor, num: 15);
        datePicker.padTop(from: timePicker1.bottomAnchor, num: 15);
        datePicker.setHeight(height: 40)
        timePicker1.setWidth(width: 140);
        timePicker1.setHeight(height: 60);
        timePicker2.setHeight(height: 60);
        timePicker2.setWidth(width: 140);
        view.addSubview(closedTodayText);
        closedTodayText.padTop(from: timeText.topAnchor, num: 0);
        closedTodayText.padLeft(from: timeText.rightAnchor, num: 10);
        closedTodayText.isHidden = true;
        view.addSubview(employeeText);
        employeeText.padLeft(from: view.leftAnchor, num: 15);
        employeeText.padTop(from: datePicker.bottomAnchor, num: 24);
        view.addSubview(employeesCollection);
        employeesCollection.padLeft(from: employeeText.rightAnchor, num: 0);
        employeesCollection.padTop(from: datePicker.bottomAnchor, num: 24);
        employeesCollection.setHeight(height: 40);
        employeesCollection.setWidth(width: fullWidth  - 130);
        view.addSubview(bctText);
        bctText.padLeft(from: view.leftAnchor, num: 15);
        bctText.padTop(from: employeeText.bottomAnchor, num: 25);
        view.addSubview(bcnCollection);
        bcnCollection.padTop(from: employeesCollection.bottomAnchor, num: 20);
        bcnCollection.padLeft(from: bctText.rightAnchor, num: 10);
        bcnCollection.setHeight(height: 40);
        bcnCollection.setWidth(width: fullWidth  - 100);
        view.addSubview(createButton);
        createButton.padTop(from: bcnCollection.bottomAnchor, num: 15);
        createButton.centerTo(element: view.centerXAnchor);
        getEmployees()
    }
    
    func getEmployees() {
        API().get(url: myURL + "getEmployees/plusBcn", headerToSend: Utilities().getAdminToken()) { res in
            if res["statusCode"] as! Int == 200 {
                print(res)
                var employeesArray: [Employee] = [];
                if let employees = res["employees"] as? [[String: String]] {
                    for employee in employees {
                        let employee = Employee(dic: employee);
                        employeesArray.append(employee);
                    }
                    if employeesArray.count > 0 {
                        var horItems: [HorItem] = [];
                        for realEmployee in employeesArray {
                            horItems.append(HorItem(title: realEmployee.fullName, id: realEmployee.id));
                        }
                        self.employeesCollection.data = horItems;
                    }
                }
                if let bcn = res["bcn"] as? String {
                    self.bcn = bcn;
                }
                if let bct = res["bct"] as? String {
                    self.bct = bct;
                }
            }
        }
    }
}

