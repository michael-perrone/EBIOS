import UIKit

protocol EditingProtocol: AdminShifts {
    func editShift(shift: Shift);
}

class AdminShifts: UIViewController, EditingProtocol {
    
    func editShift(shift: Shift) {
        nowEditing = true;
        self.editingShift = shift;
        UIView.animate(withDuration: 0.45) {
            self.viewAdd.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height / 1.038, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.038 );
        }
        UIView.animate(withDuration: 1.3) {
            self.cancelButton.alpha = 1.0;
        }
        let startRow = fromTimePicker.data.firstIndex(where: {$0 == shift.timeStart});
        let endRow = fromTimePicker.data.firstIndex { any in
            any == shift.timeEnd
        }
        fromTimePicker.selectRow(Int(startRow!), inComponent: 0, animated: true);
        toTimePicker.selectRow(Int(endRow!), inComponent: 0, animated: true);
        let employeeRow = employeePicker.employees?.firstIndex(where: { any in
           return any["fullName"] == shift.employeeName;
        })
        employeePicker.selectRow(Int(employeeRow!), inComponent: 0, animated: true);
        employeePicker.selectedEmployee = employeePicker.employees![employeeRow!]
        let df = DateFormatter()
        df.dateFormat = "MMM dd yyyy"
        var shiftDateArray = shift.date.components(separatedBy: " ");
        shiftDateArray.remove(at: 0);
        let correctDate = shiftDateArray.joined(separator: " ");
        let realDate = df.date(from: correctDate);
        datePickerForShiftAdd.date = realDate!;
        datePicker.setDate(realDate!, animated: true);
        if shift.breakStart != "" && shift.breakStart != nil && shift.breakEnd != "" && shift.breakEnd != nil {
            let breakStartTimePickerRow = breakFromTimePicker.data.firstIndex(where: {$0 == shift.breakStart});
            breakFromTimePicker.selectRow(Int(breakStartTimePickerRow!), inComponent: 0, animated: true);
            let breakEndTimePickerRow = breakToTimePicker.data.firstIndex(where: {$0 == shift.breakEnd});
            breakToTimePicker.selectRow(Int(breakEndTimePickerRow!), inComponent: 0, animated: true);
            breakFromTimePicker.selectedItem = breakFromTimePicker.data[Int(breakStartTimePickerRow!)]
            breakToTimePicker.selectedItem = breakToTimePicker.data[Int(breakEndTimePickerRow!)]
            self.isBreak = true;
        }
        cloneShift = false;
        yesCloneButton.backgroundColor = .mainLav;
        noCloneButton.backgroundColor = .mainLav;
        
    }
    
    var schedule: Schedule? {
        didSet {
            getStartCloseNum(date: Date())
        }
    }
    
    var editingShift: Shift?;
    
    var closeNum: Int?
    
    var nowEditing = false {
        didSet {
            if nowEditing {
                headerText.text = "Edit Shift";
                let stringy = NSAttributedString(string: "Finish", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]);
                createShiftOnHit.setAttributedTitle(stringy, for: .normal);
            }
            else if !nowEditing && headerText.text == "Edit Shift" {
                headerText.text = "Create Shift"
                let stringy = NSAttributedString(string: "Create Shift", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]);
                createShiftOnHit.setAttributedTitle(stringy, for: .normal);
            }
        }
    }
    
    var startNum: Int? {
        didSet {
            if let start = self.startNum, let close = self.closeNum {
                getAllTimes(start: start, close: close)
            }
        }
    }
 
    var isBreak: Bool? {
        didSet {
            if isBreak! {
                DispatchQueue.main.async {
                    self.yesBreakButton.backgroundColor = .darkGray;
                    self.yesBreakButton.tintColor = .mainLav;
                    self.noBreakButton.tintColor = .black;
                    self.noBreakButton.backgroundColor = .white;
                    self.breakTimeText.isHidden = false;
                    self.breakToTimePicker.isHidden = false;
                    self.breakFromTimePicker.isHidden = false;
                    self.dashText2.isHidden = false
                }
                
            }
            else {
                DispatchQueue.main.async {
                    self.noBreakButton.backgroundColor = .darkGray;
                    self.noBreakButton.tintColor = .mainLav;
                    self.yesBreakButton.tintColor = .black;
                    self.yesBreakButton.backgroundColor = .white;
                    self.breakTimeText.isHidden = true;
                    self.breakToTimePicker.isHidden = true;
                    self.breakFromTimePicker.isHidden = true;
                    self.dashText2.isHidden = true;
                }
            }
        }
    }
    
    var cloneShift: Bool? {
        didSet {
            if cloneShift! {
                DispatchQueue.main.async {
                    self.yesCloneButton.backgroundColor = .darkGray;
                    self.yesCloneButton.tintColor = .mainLav;
                    self.noCloneButton.tintColor = .black;
                    self.noCloneButton.backgroundColor = .white;
                    self.cloneNumberText.isHidden = false;
                    self.oneThroughFiftyClone.isHidden = false;
                }
                
            }
            else {
                DispatchQueue.main.async {
                    self.noCloneButton.backgroundColor = .darkGray;
                    self.noCloneButton.tintColor = .mainLav;
                    self.yesCloneButton.tintColor = .black;
                    self.yesCloneButton.backgroundColor = .white;
                    self.cloneNumberText.isHidden = true;
                    self.oneThroughFiftyClone.isHidden = true;
                }
            }
        }
    }
    
    var shifts: [Shift]? {
        didSet {
            specialTable.shifts = self.shifts;
        }
    }
    
    var scheduleDate: String? {
        didSet {
            getShifts()
        }
    }
    
    var shiftAddDate: String?
    
    private let specialTable = ShiftsTableView();
    
    lazy var businessEditButton: UIButton = {
        let uib = Components().createGoToBusinessEdit()
        uib.addTarget(self, action: #selector(editBusiness), for: .touchUpInside);
        return uib;
    }()
    
    private let scheduleText: UITextView = {
        let uitv = Components().createSimpleText(text: "Schedule for: ");
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let datePicker: MyDatePicker = {
        let dp = MyDatePicker();
        dp.addTarget(self, action: #selector(dateChanged), for: .valueChanged);
        return dp;
    }();
    
    private let otherDp: UIDatePicker = {
        let dp = UIDatePicker();
        return dp;
    }()
    
    lazy var datePickerForShiftAdd: MyDatePicker = {
           let dp = MyDatePicker();
        if #available(iOS 14, *) {
            dp.preferredDatePickerStyle = .wheels;
        }
        dp.setHeight(height: 110);
           dp.addTarget(self, action: #selector(dateAddChanged), for: .valueChanged);
           return dp;
       }();
    
    private let createShiftButton: UIButton = {
        let uib = Components().createNormalButton(title: "Create New Shift");
        uib.setHeight(height: 50);
        uib.setWidth(width: 240);
        uib.addTarget(self, action: #selector(showView), for: .touchUpInside);
        return uib;
    }()
    
    private let breakText: UITextView = {
        let uiv = Components().createSimpleText(text: "Break?");
        uiv.font = .boldSystemFont(ofSize: 16);
        return uiv;
    }()
    
    @objc func showView() {
        nowEditing = false;
        employeePicker.selectRow(0, inComponent: 0, animated: true);
        fromTimePicker.selectRow(0, inComponent: 0, animated: true);
        toTimePicker.selectRow(0, inComponent: 0, animated: true);
        breakFromTimePicker.selectRow(0, inComponent: 0, animated: true);
        breakToTimePicker.selectRow(0, inComponent: 0, animated: true);
        datePicker.setDate(Date(), animated: true);
        
        UIView.animate(withDuration: 0.45) {
            self.viewAdd.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height / 1.038, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.038 );
        }
        UIView.animate(withDuration: 1.3) {
            self.cancelButton.alpha = 1.0;
        }
    }
    
    private let viewAdd: UIScrollView = {
        let uisv = UIScrollView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.04));
        uisv.backgroundColor = .mainLav;
        uisv.contentInset = .zero;
        uisv.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 950);
        return uisv;
    }()
    
    private let employeePicker: EmployeePickerView = {
        let ep = EmployeePickerView();
        return ep;
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelB = UIButton(type: .system);
        cancelB.addTarget(self, action: #selector(hideView), for: .touchUpInside);
        let title = NSAttributedString(string: "X", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]);
        cancelB.setAttributedTitle(title, for: .normal);
        cancelB.tintColor = .black;
        cancelB.alpha = 0.0;
        return cancelB;
    }();
    
    private let chooseDateText: UITextView = {
        let uitv = Components().createSimpleText(text: "Choose Date");
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }();
    
    private let cloneText: UITextView = {
          let uitv = Components().createSimpleText(text: "Clone?");
          uitv.font = .boldSystemFont(ofSize: 16);
          return uitv;
      }();
    
    private let chooseEmployeeText: UITextView = {
          let uitv = Components().createSimpleText(text: "Choose Employee");
          uitv.font = .boldSystemFont(ofSize: 16);
          return uitv;
      }();
    
    private let cloneNumberText: UITextView = {
        let uitv = Components().createSimpleText(text: "Number of Shifts to Clone");
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    private let bctText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }();
    
    private let shiftStartEndText: UITextView = {
        let uitv = Components().createSimpleText(text: "Shift Start/End");
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    private let dashText = Components().createSimpleText(text: "-");
    private let dashText2 = Components().createSimpleText(text: "-");
    
    private let fromTimePicker: GenericDropDown = {
        let ftp = GenericDropDown();
        ftp.setWidth(width: 150);
        return ftp
    }()
    
    private let toTimePicker: GenericDropDown = {
        let ftp = GenericDropDown();
        ftp.setWidth(width: 150);
        return ftp
    }()
    
    private let breakFromTimePicker: GenericDropDown = {
        let ftp = GenericDropDown();
        ftp.setWidth(width: 150);
        return ftp
    }()
    
    private let breakToTimePicker: GenericDropDown = {
        let ftp = GenericDropDown();
        ftp.setWidth(width: 150);
        return ftp
    }()
    
    private let oneThroughFifty = CustomNumberPicker();
    
    private let oneThroughFiftyClone = BookingItemPicker();
    
   lazy var yesBreakButton: UIButton = {
        let uib = Components().createGoodButton(title: "Yes");
        uib.addTarget(self, action: #selector(switcherYes), for: .touchUpInside);
        return uib;
    }()
    
    lazy var noBreakButton: UIButton = {
        let uib = Components().createGoodButton(title: "No");
        uib.addTarget(self, action: #selector(switcherNo), for: .touchUpInside);
        return uib;
    }()
    
    lazy var yesCloneButton: UIButton = {
           let uib = Components().createGoodButton(title: "Yes");
           uib.addTarget(self, action: #selector(switcherCloneYes), for: .touchUpInside);
           return uib;
    }()
       
    lazy var noCloneButton: UIButton = {
           let uib = Components().createGoodButton(title: "No");
           uib.addTarget(self, action: #selector(switcherCloneNo), for: .touchUpInside);
           return uib;
    }()
    
    private let breakTimeText: UITextView = {
        let uitv = Components().createSimpleText(text: "Break Start/End");
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    lazy var createShiftOnHit: UIButton = {
        let uib = UIButton(type: .system);
        uib.addTarget(self, action: #selector(createShift), for: .touchUpInside);
        uib.setHeight(height: 60);
        uib.layer.borderColor = .CGBlack;
        uib.layer.borderWidth = 1.0;
        uib.backgroundColor = .lightGray;
        uib.tintColor = .mainLav;
        uib.setWidth(width: UIScreen.main.bounds.width / 1.3);
        let stringy = NSAttributedString(string: "Create", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]);
        uib.setAttributedTitle(stringy, for: .normal);
        uib.showsTouchWhenHighlighted = true;
        return uib;
    }()
    
    @objc func createShift() {
        if !nowEditing {
            var data: [String: Any];
            if let employeePicked = employeePicker.selectedEmployee {
                if let isBreak = self.isBreak, let cloneShift = self.cloneShift {
                    let time1: Int = Utilities.stit[fromTimePicker.selectedItem!]!;
                    let time2: Int = Utilities.stit[toTimePicker.selectedItem!]!
                    if time1 >= time2 {
                        let alert = Components().createActionAlert(title: "Shift Time Error", message: "The time the shift ends needs to be later than the time the shift starts.", buttonTitle: "Okay!", handler: nil);
                        self.present(alert, animated: true, completion: nil);
                        return;
                    }
                    else {
                        if isBreak {
                            let num1: Int = Utilities.stit[breakFromTimePicker.selectedItem!]!;
                            let num2: Int = Utilities.stit[breakToTimePicker.selectedItem!]!
                            if num1 >= num2 {
                                let alert = Components().createActionAlert(title: "Shift Time Error", message: "The time the break ends needs to be later than the time the break starts.", buttonTitle: "Okay!", handler: nil);
                                self.present(alert, animated: true, completion: nil);
                                return;
                            }
                            else {
                                if cloneShift {
                                    data = ["shiftDate": self.shiftAddDate!, "timeStart": fromTimePicker.selectedItem, "timeEnd": toTimePicker.selectedItem, "businessId": Utilities().decodeAdminToken()!["businessId"]!, "employeeName": employeePicked["fullName"]!, "isBreak": isBreak, "breakStart": breakFromTimePicker.selectedItem, "breakEnd": breakToTimePicker.selectedItem, "employeeId": employeePicker.selectedEmployee!["_id"] as Any, "cloneNumber": oneThroughFiftyClone.selected, "bookingColumnNumber": oneThroughFifty.selected]
                                    createMultipleShifts(data: data);
                                }
                                else {
                                    data = ["shiftDate": self.shiftAddDate!, "timeStart": fromTimePicker.selectedItem, "timeEnd": toTimePicker.selectedItem, "businessId": Utilities().decodeAdminToken()!["businessId"]!, "employeeName": employeePicker.selectedEmployee!["fullName"]!, "isBreak": isBreak, "breakStart": breakFromTimePicker.selectedItem, "breakEnd": breakToTimePicker.selectedItem, "employeeId": employeePicker.selectedEmployee!["_id"] as Any, "bookingColumnNumber": oneThroughFifty.selected]
                                    createShiftCall(data: data);
                                }
                            }
                        }
                        else {
                            if cloneShift {
                                data = ["shiftDate": self.shiftAddDate!, "timeStart": fromTimePicker.selectedItem, "timeEnd": toTimePicker.selectedItem, "businessId": Utilities().decodeAdminToken()!["businessId"]!, "employeeName": employeePicker.selectedEmployee!["fullName"]!, "isBreak": isBreak, "breakStart": breakFromTimePicker.selectedItem, "breakEnd": breakToTimePicker.selectedItem, "employeeId": employeePicker.selectedEmployee!["_id"] as Any, "cloneNumber": oneThroughFiftyClone.selected, "bookingColumnNumber": oneThroughFifty.selected]
                                createMultipleShifts(data: data)
                            }
                            else {
                                data = ["shiftDate": self.shiftAddDate!, "timeStart": fromTimePicker.selectedItem, "timeEnd": toTimePicker.selectedItem, "businessId": Utilities().decodeAdminToken()!["businessId"]!, "employeeName": employeePicker.selectedEmployee!["fullName"]!, "isBreak": isBreak, "employeeId": employeePicker.selectedEmployee!["_id"] as Any, "bookingColumnNumber": oneThroughFifty.selected]
                                createShiftCall(data: data);
                            }
                        }
                    }
                }
                else {
                    let dataAlertError = Components().createActionAlert(title: "Information Error", message: "Please choose if the employee selected selected will have a break and if this shift will be cloned(repeated on the same weekday at the same time in the future). ", buttonTitle: "Woops, okay!", handler: nil);
                    DispatchQueue.main.async {
                        self.present(dataAlertError, animated: true, completion: nil);
                    }
                }
            }
            else {
                let alert = Components().createActionAlert(title: "Employee Error", message: "Your business has not added any employees yet! Please do this in the edit business menu.", buttonTitle: "Okay!", handler: nil);
                self.present(alert, animated: true, completion: nil);
            }
        }
        else {
            if !isBreak! {
                var data: [String: Any];
                data = ["shiftDate": self.shiftAddDate!, "timeStart": fromTimePicker.selectedItem, "timeEnd": toTimePicker.selectedItem, "businessId": Utilities().decodeAdminToken()!["businessId"]!, "employeeName": employeePicker.selectedEmployee!["fullName"]!, "isBreak": isBreak, "employeeId": employeePicker.selectedEmployee!["_id"] as Any, "shiftId": editingShift?.id, "bookingColumnNumber": oneThroughFifty.selected]
                editShifts(data: data)
                
            }
            else {
                var otherData: [String: Any]
                otherData = ["shiftDate": self.shiftAddDate!, "timeStart": fromTimePicker.selectedItem, "timeEnd": toTimePicker.selectedItem, "businessId": Utilities().decodeAdminToken()!["businessId"]!, "employeeName": employeePicker.selectedEmployee!["fullName"]!, "isBreak": isBreak, "breakStart": breakFromTimePicker.selectedItem, "breakEnd": breakToTimePicker.selectedItem, "employeeId": employeePicker.selectedEmployee!["_id"] as Any, "shiftId": editingShift?.id, "bookingColumnNumber": oneThroughFifty.selected];
                editShifts(data: otherData)
            }
        }
    }
    
    
    
    func editShifts(data: [String: Any]) {
        API().post(url: myURL + "shifts/edit", dataToSend: data) { (res) in
            if let statusCode = res["statusCode"] as? Int {
                if statusCode == 200 {
                    self.getShifts()
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
                            self.viewAdd.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.032);
                            self.cancelButton.alpha = 0;
                        }, completion: nil)
                    }
                }
                else if statusCode == 406 {
                    if let error = res["error"] as? String, let date = res["date"] as? String {
                        var message: String = "";
                        if error == "ee" {
                            message = "This employee has a shift conflict on " + date + ".";
                        }
                        else if error == "ebcn" {
                            message = "There is a booking area/column conflict on " + date + ". (The area which you are trying to book this employee in is already scheduled to be used.)"
                        }
                        let alertError = Components().createActionAlert(title: "Shift Creation Error", message: message, buttonTitle: "Oops, okay!", handler: nil);
                        DispatchQueue.main.async {
                            self.present(alertError, animated: true, completion: nil);
                        }
                    }
                }
            }
        }
    }
    
    
    func createShiftCall(data: [String: Any]) {
        API().post(url: myURL + "shifts/create", dataToSend: data) { (res) in
            if let statusCode = res["statusCode"] as? Int {
                if statusCode == 201 {
                    self.getShifts()
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
                            self.viewAdd.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.032);
                            self.cancelButton.alpha = 0;
                        }, completion: nil)
                    }
                    
                }
                else if statusCode == 406 {
                    if let error = res["error"] as? String, let date = res["date"] as? String {
                        var message: String = "";
                        if error == "ee" {
                            message = "This employee has a shift conflict on " + date + ".";
                        }
                        else if error == "ebcn" {
                            message = "There is a booking area/column conflict on " + date + ". (The area which you are trying to book this employee in is already scheduled to be used.)"
                        }
                        let alertError = Components().createActionAlert(title: "Shift Creation Error", message: message, buttonTitle: "Oops, okay!", handler: nil);
                        DispatchQueue.main.async {
                            self.present(alertError, animated: true, completion: nil);
                        }
                    }
                }
            }
        }
    }
    
    func createMultipleShifts(data: [String: Any]) {
        API().post(url: myURL + "shifts/multiplecreate", dataToSend: data) { (res) in
            if let statusCode = res["statusCode"] as? Int {
                if statusCode == 201 {
                    self.getShifts()
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
                            self.viewAdd.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.032);
                            self.cancelButton.alpha = 0;
                        }, completion: nil)
                    }
                }
                else if statusCode == 406 {
                    if let error = res["error"] as? String, let date = res["date"] as? String {
                        var message: String = "";
                        if error == "ee" {
                            message = "This employee has a shift conflict on " + date + ".";
                        }
                        else if error == "ebcn" {
                            message = "There is a booking area/column conflict on " + date + ". (The area which you are trying to book this employee in is already scheduled to be used.)"
                        }
                        let alertError = Components().createActionAlert(title: "Shift Creation Error", message: message, buttonTitle: "Oops, okay!", handler: nil);
                        DispatchQueue.main.async {
                            self.present(alertError, animated: true, completion: nil);
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    @objc func switcherYes() {
        isBreak = true;
    }
    
    
    
    @objc func switcherNo() {
        isBreak = false;
    }
    
    
    
    @objc func switcherCloneYes() {
        if nowEditing {
            cloneError()
            return;
        }
        cloneShift = true;
    }
    
    @objc func switcherCloneNo() {
        if nowEditing {
            cloneError()
            return;
        }
        cloneShift = false;
    }
    
    
    
    @objc func hideView() {
        UIView.animate(withDuration: 0.45) {
            self.viewAdd.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.032);
            self.cancelButton.alpha = 0;
        }
        self.editingShift = nil;
        self.nowEditing = false;
    }
    
    @objc func dateChanged() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        self.scheduleDate = df.string(from: datePicker.date);
    }
    
    @objc func dateAddChanged() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        self.shiftAddDate = df.string(from: datePickerForShiftAdd.date);
        getStartCloseNum(date: datePickerForShiftAdd.date);
    }
    
    
    @objc func editBusiness() {
        let editBusiness = EditBusinessProfile();
        editBusiness.modalPresentationStyle = .fullScreen;
        self.present(editBusiness, animated: true, completion: nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        getEmployees()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployees()
        getBookingColumnItem()
        configureUI();
    }
    
    
    func getEmployees() {
        API().get(url: myURL + "getEmployees", headerToSend: Utilities().getAdminToken()) { (res) in
            self.employeePicker.employees = res["employees"] as? [[String: String]]
        }
    }
    
    private let headerText: UITextView = {
        let uitv = Components().createSimpleText(text: "Create Shift");
        uitv.font = .boldSystemFont(ofSize: 18);
        return uitv;
    }();
    
    func configureUI() {
        specialTable.editingDelegate = self;
        navigationItem.title = "Shifts";
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: businessEditButton);
        view.addSubview(scheduleText);
        scheduleText.centerTo(element: view.centerXAnchor);
        scheduleText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        view.addSubview(datePicker);
        datePicker.centerTo(element: view.centerXAnchor);
        datePicker.padTop(from: scheduleText.bottomAnchor, num: 7);
        view.addSubview(specialTable);
        specialTable.setHeight(height: 300);
        specialTable.setWidth(width: view.frame.width);
        specialTable.centerTo(element: view.centerXAnchor);
        specialTable.padTop(from: datePicker.bottomAnchor, num: 10);
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        self.scheduleDate = df.string(from: Date());
        self.shiftAddDate = df.string(from: Date());
        view.addSubview(createShiftButton);
        createShiftButton.padTop(from: specialTable.bottomAnchor, num: 50);
        createShiftButton.centerTo(element: view.centerXAnchor);
        let window = UIApplication.shared.keyWindow!;
        window.addSubview(viewAdd);
        window.addSubview(cancelButton);
        window.addSubview(cancelButton);
        cancelButton.padTop(from: viewAdd.topAnchor, num: 20);
        cancelButton.padRight(from: viewAdd.rightAnchor, num: 10);
        cancelButton.setHeight(height: 20);
        cancelButton.setWidth(width: 20);
        viewAdd.addSubview(headerText);
        headerText.padTop(from: viewAdd.topAnchor, num: 10);
        headerText.centerTo(element: viewAdd.centerXAnchor);
        viewAdd.addSubview(chooseEmployeeText);
        chooseEmployeeText.padTop(from: headerText.bottomAnchor, num: 20);
        viewAdd.addSubview(employeePicker);
        employeePicker.setHeight(height: 100);
        employeePicker.setWidth(width: 350);
        employeePicker.padTop(from: chooseEmployeeText.bottomAnchor, num: -5);
        employeePicker.centerTo(element: viewAdd.centerXAnchor);
        chooseEmployeeText.padLeft(from: employeePicker.leftAnchor, num: 0);
        viewAdd.addSubview(chooseDateText);
        chooseDateText.padLeft(from: employeePicker.leftAnchor, num: 0)
        chooseDateText.padTop(from: employeePicker.bottomAnchor, num: 0);
        viewAdd.addSubview(datePickerForShiftAdd);
        datePickerForShiftAdd.padTop(from: chooseDateText.bottomAnchor, num: 5);
        datePickerForShiftAdd.centerTo(element: viewAdd.centerXAnchor);
        viewAdd.addSubview(shiftStartEndText);
        shiftStartEndText.padTop(from: datePickerForShiftAdd.bottomAnchor, num: 10);
        shiftStartEndText.padLeft(from: employeePicker.leftAnchor, num: 0);
        viewAdd.addSubview(fromTimePicker);
        fromTimePicker.padLeft(from: employeePicker.leftAnchor, num: 0);
        fromTimePicker.padTop(from: shiftStartEndText.bottomAnchor, num: 0);
        fromTimePicker.setHeight(height: 50);
        fromTimePicker.setWidth(width: 200);
        viewAdd.addSubview(dashText);
        dashText.padLeft(from: fromTimePicker.rightAnchor, num: 0);
        dashText.padTop(from: fromTimePicker.topAnchor, num: 0);
        viewAdd.addSubview(toTimePicker);
        toTimePicker.padLeft(from: dashText.rightAnchor, num: 0);
        toTimePicker.padTop(from: fromTimePicker.topAnchor, num: 0);
        toTimePicker.setWidth(width: 200);
        toTimePicker.setHeight(height: 50);
        viewAdd.addSubview(bctText);
        bctText.padTop(from: fromTimePicker.bottomAnchor, num: 15);
        bctText.padLeft(from: fromTimePicker.leftAnchor, num: 0);
        viewAdd.addSubview(oneThroughFifty);
        oneThroughFifty.padLeft(from: fromTimePicker.leftAnchor, num: 0);
        oneThroughFifty.padTop(from: bctText.bottomAnchor, num: 0);
        oneThroughFifty.setHeight(height: 40);
        oneThroughFifty.setWidth(width: 300);
        viewAdd.addSubview(cloneText);
        cloneText.padTop(from: oneThroughFifty.bottomAnchor, num: 15);
        cloneText.padLeft(from: fromTimePicker.leftAnchor, num: 0);
        viewAdd.addSubview(yesCloneButton)
        yesCloneButton.padLeft(from: cloneText.rightAnchor, num: 30);
        yesCloneButton.padTop(from: cloneText.topAnchor, num: 5);
        viewAdd.addSubview(noCloneButton)
        noCloneButton.padLeft(from: yesCloneButton.rightAnchor, num: 40);
        noCloneButton.padTop(from: cloneText.topAnchor, num: 5);
        viewAdd.addSubview(cloneNumberText);
        cloneNumberText.padTop(from: cloneText.bottomAnchor, num: 15);
        cloneNumberText.padLeft(from: employeePicker.leftAnchor, num: 0);
        viewAdd.addSubview(oneThroughFiftyClone);
        oneThroughFiftyClone.padLeft(from: fromTimePicker.leftAnchor, num: 0);
        oneThroughFiftyClone.padTop(from: cloneNumberText.bottomAnchor, num: 0);
        oneThroughFiftyClone.setHeight(height: 40);
        oneThroughFiftyClone.setWidth(width: 300);
        oneThroughFiftyClone.isHidden = true;
        cloneNumberText.isHidden = true;
        viewAdd.addSubview(breakText);
        breakText.padTop(from: oneThroughFiftyClone.bottomAnchor, num: 15);
        breakText.padLeft(from: fromTimePicker.leftAnchor, num: 0);
        viewAdd.addSubview(yesBreakButton)
        yesBreakButton.padLeft(from: breakText.rightAnchor, num: 30);
        yesBreakButton.padTop(from: breakText.topAnchor, num: 5);
        viewAdd.addSubview(noBreakButton)
        noBreakButton.padLeft(from: yesBreakButton.rightAnchor, num: 40);
        noBreakButton.padTop(from: breakText.topAnchor, num: 5);
        viewAdd.addSubview(breakTimeText);
        breakTimeText.padTop(from: breakText.bottomAnchor, num: 15);
        breakTimeText.padLeft(from: employeePicker.leftAnchor, num: 0);
        viewAdd.addSubview(breakFromTimePicker);
        breakFromTimePicker.padLeft(from: employeePicker.leftAnchor, num: 0);
        breakFromTimePicker.padTop(from: breakTimeText.bottomAnchor, num: 0);
        breakFromTimePicker.setHeight(height: 50);
        breakFromTimePicker.setWidth(width: 150);
        viewAdd.addSubview(dashText2);
        dashText2.padLeft(from: breakFromTimePicker.rightAnchor, num: 20);
        dashText2.padTop(from: breakFromTimePicker.topAnchor, num: 0);
        viewAdd.addSubview(breakToTimePicker);
        breakToTimePicker.padLeft(from: dashText2.rightAnchor, num: 20);
        breakToTimePicker.padTop(from: breakFromTimePicker.topAnchor, num: 0);
        breakToTimePicker.setWidth(width: 150);
        breakToTimePicker.setHeight(height: 50);
        breakTimeText.isHidden = true;
        breakToTimePicker.isHidden = true;
        breakFromTimePicker.isHidden = true;
        dashText2.isHidden = true;
        viewAdd.addSubview(createShiftOnHit);
        createShiftOnHit.centerTo(element: viewAdd.centerXAnchor);
        createShiftOnHit.padTop(from: breakToTimePicker.bottomAnchor, num: 20);
    }
    
    var bct: String? {
        didSet {
            specialTable.bct = bct;
        }
    }
    
    func getBookingColumnItem() {
        API().post(url: myURL + "business/bct", dataToSend: ["id": Utilities().decodeAdminToken()!["businessId"]]) { (res) in
            if let soonToBeSchedule = res["schedule"] as? [[String: String]] {
                self.schedule = Schedule(dic: soonToBeSchedule)
            }
            if let bct = res["bct"] as? String {
                self.bct = bct;
                DispatchQueue.main.async {
                    self.bctText.text = bct + " Number";
                }
            }
            if let bcn = res["bcn"] as? String {
                self.oneThroughFifty.bcn = Int(bcn);
            }
            else {
               print("DID NOT WORK")
            }
        }
    }
    
    func getShifts() {
        API().post(url: myURL + "shifts/get", dataToSend: ["shiftDate": self.scheduleDate!, "businessId": Utilities().decodeAdminToken()!["businessId"]]) { (res) in
            var shiftsArray: [Shift] = [];
            if let shifts = res["shifts"] as? [[String: String]] {
                for shift in shifts {
                    shiftsArray.append(Shift(dic: shift))
                }
            }
                else {
                    shiftsArray = [];
            }
            self.shifts = shiftsArray;
            print(shiftsArray);
        }
    }
    
    func cloneError() {
        let createActionAlert = Components().createActionAlert(title: "Edit Shift Error", message: "Clone Shifts cannot be created while editing a shift.", buttonTitle: "Okay!", handler: nil);
        
        self.present(createActionAlert, animated: true, completion: nil);
    }
    
    func getStartCloseNum(date: Date? = nil) {
        if let date = date {
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: date)
            if weekDay == 1 {
                if schedule!.sunOpen != "Closed" && schedule!.sunClose != "Closed" {
                    self.closeNum = Utilities.stit[schedule!.sunClose];
                    self.startNum = Utilities.stit[schedule!.sunOpen]!;
                }
            }
            else if weekDay == 2 {
                if schedule!.monOpen != "Closed" && schedule!.monClose != "Closed" {
                    self.closeNum = Utilities.stit[schedule!.monClose];
                    self.startNum = Utilities.stit[schedule!.monOpen]!;
                }
            }
            else if weekDay == 3 {
                if schedule!.tueOpen != "Closed" && schedule!.tueClose != "Closed" {
                    self.closeNum = Utilities.stit[schedule!.tueClose];
                    self.startNum = Utilities.stit[schedule!.tueOpen]!;
                }
            }
            else if weekDay == 4 {
                if schedule!.wedOpen != "Closed" && schedule!.wedClose != "Closed" {
                    self.closeNum = Utilities.stit[schedule!.wedClose];
                    self.startNum = Utilities.stit[schedule!.wedOpen]!;
                }
            }
            else if weekDay == 5 {
                if schedule!.thuOpen != "Closed" && schedule!.thuClose != "Closed" {
                    self.closeNum = Utilities.stit[schedule!.thuClose];
                    self.startNum = Utilities.stit[schedule!.thuOpen]!;
                }
                
            }
            else if weekDay == 6 {
                if schedule!.friOpen != "Closed" && schedule!.friClose != "Closed" {
                    self.closeNum = Utilities.stit[schedule!.friClose];
                    self.startNum = Utilities.stit[schedule!.friOpen]!;
                }
            }
            else if weekDay == 7 {
                if schedule!.satOpen != "Closed" && schedule!.satClose != "Closed" {
                    self.closeNum = Utilities.stit[schedule!.satClose];
                    self.startNum = Utilities.stit[schedule!.satOpen]!;
                }
            }
        }
    }
    
    func getAllTimes(start: Int, close: Int) {
        var newStart = start;
        var times: [String] = [];
        while newStart <= close {
            times.append(Utilities.itst[newStart]!)
            newStart += 1;
        }
        fromTimePicker.data = times;
        toTimePicker.data = times;
        breakFromTimePicker.data = times;
        breakToTimePicker.data = times;
    }
}

