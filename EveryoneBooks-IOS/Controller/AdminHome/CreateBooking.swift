import UIKit
import MobileCoreServices

protocol BookingHit: CreateBooking {
    func bookHit();
    func noPhone();
    func badPhone();
    func alreadyRegisted();
    func notFinished();
    func selectBcn(num: Int);
    func bcnNotSelected();
}

protocol ServiceChosenProtocol: CreateBooking {
    func serviceChosen(service: Service);
    func servicesRemoved();
}

class CreateBooking: UIViewController, BookingHit, ServiceChosenProtocol {
    
    func serviceChosen(service: Service) {
        if let bookingRequiresEmployeeAlreadySet = self.bookingRequiresEmployee {
            if bookingRequiresEmployeeAlreadySet {
                if !service.requiresEmployee {
                    let alert = Components().createActionAlert(title: "Services Issue", message: service.serviceName + " can not be booked with the other services you've selected because this service does not use an employee. Only services that use an employee can be booked together." , buttonTitle: "Okay!") { UIAlertAction in
                        DispatchQueue.main.async {
                            self.servicesTable.selectedServices = [];
                            self.servicesTable.reloadData();
                            self.bookingRequiresEmployee = nil;
                        }
                    };
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
            }
            else {
                if service.requiresEmployee {
                    let alert = Components().createActionAlert(title: "Services Issue", message: service.serviceName + " can not be booked with the other services you've selected because this service uses an employee and other selected services do not. Only services that use an employee can be booked together." , buttonTitle: "Okay!") { UIAlertAction in
                        DispatchQueue.main.async {
                            self.servicesTable.selectedServices = [];
                            self.servicesTable.reloadData();
                            self.bookingRequiresEmployee = nil;
                        }
                    };
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
            }
        }
        self.bookingRequiresEmployee = service.requiresEmployee;
    }
    func servicesRemoved() {
        self.bookingRequiresEmployee = nil;
    }
    
    func bcnNotSelected() {
        let alert = Components().createActionAlert(title: "Column Number Not Selected", message: "Please choose the number area/column you would like this booking to take place.", buttonTitle: "Okay!", handler: nil);
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    func selectBcn(num: Int) {
        self.selectedBcn = num;
    }
    
    func alreadyRegisted() {
        let alreadyRegisteredAlert = Components().createActionAlert(title: "Error", message: "This guest is already registered within our app! Please cancel the process of registering a new guest.", buttonTitle: "Okay!", handler: nil);
        DispatchQueue.main.async {
            self.present(alreadyRegisteredAlert, animated: true, completion: nil);
        }
    }
    
    func notFinished() {
        let notFinishedAlert = Components().createActionAlert(title: "Error", message: "Please finish entering the new guest's info!", buttonTitle: "Okay!", handler: nil);
        DispatchQueue.main.async {
            self.present(notFinishedAlert, animated: true, completion: nil);
        }
    }
    
    func bookHit() {
        let bookSuccess = UIAlertController(title: "Success!", message: "You're request has been received and created.", preferredStyle: .alert);
        let okayButton = UIAlertAction(title: "Exit!", style: .cancel) { (action: UIAlertAction) in
            UIView.animate(withDuration: 0.45) {
                self.popUp.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.6);
                self.dismiss(animated: true, completion: nil);
                self.delegate?.reloadTable();
            }
        }
        bookSuccess.addAction(okayButton);
        DispatchQueue.main.async {
            self.present(bookSuccess, animated: true) {
                
            }
        }
    }
    
    func noPhone() {
        let phoneNotFilled = UIAlertController(title: "Oops!", message: "Please enter phone number above.", preferredStyle: .alert);
        let okayB = UIAlertAction(title: "Got it!", style: .default, handler: nil);
        phoneNotFilled.addAction(okayB)
        DispatchQueue.main.async {
            self.present(phoneNotFilled, animated: true, completion: nil);
        }
    }
    
    func badPhone() {
        let alert = UIAlertController(title: "Error!", message: "The phone number you have entered is not registered to any users on our app. Would you like to add them as a one time guest?", preferredStyle: .actionSheet);
        let okayButton = UIAlertAction(title: "Yes!", style: .default) { (UIAlertAction) in
            self.startGuestRegister();
        }
        let noButton = UIAlertAction(title: "Oops, no!", style: .default, handler: nil);
        alert.addAction(okayButton);
        alert.addAction(noButton);
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    func startGuestRegister() {
        DispatchQueue.main.async {
            self.timeDurationText.isHidden = true;
            self.costText.isHidden = true;
            self.startGuestRegisterButton.isHidden = true;
            self.cancelNewGuestRegisterButton.isHidden = false;
            self.datesCollectionView.isHidden = true;
            self.saveButton.isHidden = false;
            self.newGuestNameInput.isHidden = false;
            if self.editButton.isHidden == false {
                self.editButton.isHidden = true;
            }
        }
        self.isNewGuestBeingRegistered = true;
    }
    
    lazy var bookIfEmployeeNotNeededButton: UIButton = {
        let uib = Components().createNormalButton(title: "Book");
        uib.setHeight(height: 45);
        uib.setWidth(width: 100);
        uib.addTarget(self, action: #selector(bookIfEmployeeNotNeeded), for: .touchUpInside);
        return uib;
    }()
    
    @objc func bookIfEmployeeNotNeeded() {
        if cloneBooking == "n" {
            bookButtonHitSingle()
        }
        else if cloneBooking == "y" {
            bookButtonHitClone()
        }
    }
    
    var bookingRequiresEmployee: Bool? {
        didSet {
            if bookingRequiresEmployee == nil || bookingRequiresEmployee == false {
                DispatchQueue.main.async {
                    self.employeesTable.isHidden = true;
                    self.employeesAvailableText.isHidden = true;
                    self.bookIfEmployeeNotNeededButton.isHidden = false;
                }
            }
            else {
                DispatchQueue.main.async {
                    self.employeesTable.isHidden = false;
                    self.employeesAvailableText.isHidden = false;
                    self.bookIfEmployeeNotNeededButton.isHidden = true;
                }
            }
        }
    }
    
    private var datesForCollectionView: [String]? {
        didSet {
            datesCollectionView.dates = datesForCollectionView;
            DispatchQueue.main.async {
                self.datesCollectionView.reloadData();
            }
        }
    }
    
    private let datesCollectionView: DatesCollectionView = {
        let dcv = DatesCollectionView();
        dcv.setHeight(height: 45);
        dcv.setWidth(width: fullWidth / 2);
        return dcv;
    }()
    
    var bct: String? {
        didSet {
            bctText.text = bct! + ":";
        }
    }
    
    var datesForClone: [String]?
    
    private let bctText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    var selectedBcn: Int? {
        didSet {
            bcnSelectorCV.selectedBcn = self.selectedBcn!;
            employeesTable.selectedBcn = selectedBcn!;
        }
    }
    
    var isNewGuestBeingRegistered = false {
        didSet {
            employeesTable.isNewGuestBeingRegistered = self.isNewGuestBeingRegistered;
        }
    }
    
    var newGuestInfoSaved = false {
        didSet {
            employeesTable.newGuestInfoSaved = self.newGuestInfoSaved;
        }
    }
    
    private let startGuestRegisterButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setHeight(height: 26);
        uib.setWidth(width: 170);
        let attributedTitle = NSAttributedString(string: "Register New Guest", attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18)]);
        uib.setAttributedTitle(attributedTitle, for: .normal);
        uib.backgroundColor = .white;
        uib.showsTouchWhenHighlighted = true;
        uib.layer.borderColor = CGColor.CGBlack;
        uib.layer.borderWidth = 1.2;
        uib.addTarget(self, action: #selector(startGuestRegisterHit), for: .touchUpInside);
        return uib;
    }()
    
    private let saveButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setHeight(height: 26);
        uib.setWidth(width: 70);
        let attributedTitle = NSAttributedString(string: "Save", attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18)]);
        uib.setAttributedTitle(attributedTitle, for: .normal);
        uib.backgroundColor = .white;
        uib.showsTouchWhenHighlighted = true;
        uib.layer.borderColor = CGColor.CGBlack;
        uib.layer.borderWidth = 1.2;
        uib.addTarget(self, action: #selector(saveHit), for: .touchUpInside);
        return uib;
    }()
    
    @objc func saveHit() {
        if newGuestNameTextField.text!.count != 0 && customerPhoneTextField.text!.count != 0 {
            self.isNewGuestBeingRegistered = false;
            self.customerPhoneTextField.isUserInteractionEnabled = false;
            self.newGuestNameTextField.isUserInteractionEnabled = false;
            self.saveButton.isHidden = true;
            self.savedText.isHidden = false;
            self.editButton.isHidden = false;
            self.newGuestInfoSaved = true;
            self.employeesTable.fullName = newGuestNameTextField.text!;
        }
        else {
            let alert = Components().createActionAlert(title: "Error", message: "Please enter name and phone number of new guest before trying to save new guest information.", buttonTitle: "Okay!", handler: nil);
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil);
            }
        }
    }
    
    private let savedText: UITextView = {
        let uitv = Components().createSimpleText(text: "Guest Info Saved");
        uitv.font = .systemFont(ofSize: 18);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let editButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setHeight(height: 26);
        uib.setWidth(width: 70);
        let attributedTitle = NSAttributedString(string: "Edit", attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18)]);
        uib.setAttributedTitle(attributedTitle, for: .normal);
        uib.backgroundColor = .white;
        uib.showsTouchWhenHighlighted = true;
        uib.layer.borderColor = CGColor.CGBlack;
        uib.layer.borderWidth = 1.2;
        uib.addTarget(self, action: #selector(editNewGuestInfo), for: .touchUpInside);
        return uib;
    }()
    
    @objc func editNewGuestInfo() {
        startGuestRegister()
        self.customerPhoneTextField.isUserInteractionEnabled = true;
        self.newGuestNameTextField.isUserInteractionEnabled = true;
        self.savedText.isHidden = true;
        self.newGuestInfoSaved = false;
    }

    private let cancelNewGuestRegisterButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setHeight(height: 26);
        uib.setWidth(width: 70);
        let attributedTitle = NSAttributedString(string: "Cancel", attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18)]);
        uib.setAttributedTitle(attributedTitle, for: .normal);
        uib.backgroundColor = .white;
        uib.showsTouchWhenHighlighted = true;
        uib.layer.borderColor = CGColor.CGBlack;
        uib.layer.borderWidth = 1.2;
        uib.addTarget(self, action: #selector(cancelNewGuestRegister), for: .touchUpInside);
        return uib;
    }()
    
    private let newGuestNameTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Enter New Customer Name", fontSize: 18);
        return uitf;
    }()
    
    lazy var newGuestNameInput: UIView = {
        let uiv = Components().createInput(textField: newGuestNameTextField, view: view);
        return uiv;
    }()
    
    @objc func startGuestRegisterHit() {
        startGuestRegister();
    }
    
    @objc func cancelNewGuestRegister() {
        self.cancelNewGuestRegisterButton.isHidden = true;
        self.saveButton.isHidden = true;
        self.costText.isHidden = false;
        self.datesCollectionView.isHidden = false;
        self.timeDurationText.isHidden = false;
        self.startGuestRegisterButton.isHidden = false;
        self.newGuestNameInput.isHidden = true;
        self.isNewGuestBeingRegistered = false;
    }
    
    weak var delegate: ReloadTableAfterBooking?;
    
    var start: Int?;
    
    var closed = false;
    
    var closedTodayText = Components().createNotAsLittleText(text: "Business Closed");
    
    var close: Int? {
        didSet {
            var dataComing: [String] = [];
            guard var start = start, let close = close else {
                closed = true;
                DispatchQueue.main.async {
                    self.closedTodayText.isHidden = false;
                    self.timePicker.isHidden = true;
                }
                return;
            }
            if closed {
                closed = false;
                DispatchQueue.main.async {
                    self.closedTodayText.isHidden = true;
                    self.timePicker.isHidden = false;
                }
            }

            while start <= close {
                dataComing.append(Utilities.itst[start]!);
                start = start + 1;
            }
            timePicker.data = dataComing;
        }
    }
    
    var services: [Service]? {
        didSet {
            servicesTable.data = self.services;
        }
    }
    
    var dateChosen: String?;
    
    var bcn: Int? {
        didSet {
            var i = 1;
            var bcnArray: [Int] = [];
            while i <= bcn! {
                bcnArray.append(i);
                i+=1;
            }
           // bcnSelectorCV.bcns = bcnArray;
        }
    }
    
    var bcnArray: [Int]? {
        didSet {
            bcnSelectorCV.bcns = self.bcnArray;
        }
    }
    
    var eq: String? ;
    
    var employeesAvailable: [Employee]? {
        didSet {
            employeesTable.employees = self.employeesAvailable;
            employeesTable.dateChosen = self.dateChosen;
            employeesTable.timeChosen = self.timePicker.selectedItem;
            employeesTable.services = servicesTable.selectedServices;
            employeesTable.businessId = Utilities().decodeAdminToken()!["businessId"] as! String;
            employeesTable.dates = datesForCollectionView;
            employeesTable.cost = self.costForTable;
        }
    }
    
    var costForTable: String = "";
    
    lazy var customerPhoneInput: UIView = {
        let uiv = Components().createInput(textField: customerPhoneTextField, view: view);
        return uiv;
    }()
    
    private let customerPhoneTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Enter Customer Phone", fontSize: 18);
        uitf.addTarget(self, action: #selector(sendPhone), for: .editingChanged);
        return uitf;
    }()
    
    @objc func sendPhone() {
        employeesTable.phone = customerPhoneTextField.text;
    }
    
    private let datePickerText = Components().createNotAsLittleText(text: "Choose Date:");
    
    
    private let servicesChosenTable: ServicesChosenTable = {
        let sct = ServicesChosenTable();
        sct.setWidth(width: UIScreen.main.bounds.width / 1.3);
        sct.setHeight(height: 110);
        sct.backgroundColor = .clear;
        return sct;
    }()
    
    private let employeesTable: EmployeesAvailableTable = {
        let eat = EmployeesAvailableTable();
        eat.fromBusiness = true;
        eat.backgroundColor = .literGray;
        return eat;
    }()
    
    private let bcnSelectorCV = BcnSelectorCollectionView();
    
    private let costText: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 16);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let datePicker: UIDatePicker = {
        let uidp = UIDatePicker();
        uidp.datePickerMode = .date;
        uidp.addTarget(self, action: #selector(dateChanged), for: .valueChanged);
        uidp.setHeight(height: 110);
        return uidp;
    }()
    
    private let dismissButton: UIButton = {
        let uib = Components().createXButton();
        uib.addTarget(self, action: #selector(dismissCreateBooking), for: .touchUpInside);
        return uib;
    }();
    
    private let popUp: UIView = {
        let uisv = UIScrollView();
        uisv.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        uisv.backgroundColor = .mainLav;
        return uisv;
    }()
    
    private let clonePopUp: UIView = {
        let uisv = UIScrollView();
        uisv.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.7);
        uisv.backgroundColor = .mainLav;
        return uisv;
    }()
    
    private let timePickerText = Components().createNotAsLittleText(text: "Choose Time:");
    
    private let timePicker = GenericDropDown();
    
    private let servicesText = Components().createNotAsLittleText(text: "Choose Services:");
    
    private let servicesTable: ServicesTable = {
        let st = ServicesTable();
        st.numForChars = 30;
        st.unselectedCellTextColor = .literGray;
        return st;
    }();
    
    private let noServicesText = Components().createNotAsLittleText(text: "Please add services that can be booked in the Edit Business Menu.");
    
    private let timeDurationText: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.backgroundColor = .mainLav;
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    private let continueButton: UIButton = {
        let uib = Components().createContinueBookingButton()
        uib.addTarget(self, action: #selector(continueHit), for: .touchUpInside);
        return uib;
    }();
    
    private let servicesChosenText: UITextView = {
        let uitv = Components().createLittleText(text: "Services Chosen: ");
        uitv.backgroundColor = .mainLav;
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    lazy var employeesAvailableText: UITextView = {
        let uitv = Components().createSimpleText(text: "Employees Avaliable");
        uitv.backgroundColor = .mainLav;
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    private let chooseServiceText: UITextView = {
        let uitv = Components().createLittleText(text: "Choose services to book:");
        return uitv;
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelB = Components().createXButton();
        cancelB.addTarget(self, action: #selector(hideView), for: .touchUpInside);
        return cancelB;
    }()
    
    @objc func hideView() {
        UIView.animate(withDuration: 0.45) {
            self.popUp.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.6);
        }
    }
    
    
    @objc func continueHit() {
        if cloneBooking == "y" && servicesTable.selectedServices.count > 0 {
            let dateFormatter = DateFormatter();
            let realDate = "Feb 12, 2022 5:00 AM"
            dateFormatter.dateFormat = "MMM dd, yyyy h:mm a";
            let date = dateFormatter.date(from: dateChosen! + " " + timePicker.selectedItem!)
            if date! < Date() {
                let alert = Components().createActionAlert(title: "Invalid Date", message: "The date or time you have chosen has already passed and cannot be scheduled.", buttonTitle: "Woops, Got it!", handler: nil);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
                return;
            }
            UIView.animate(withDuration: 1.1) {
                self.clonePopUp.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height / 1.5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5);
                self.newView.isHidden = false;
            }
            return;
        }
        if servicesTable.selectedServices.count > 0 && cloneBooking == "n" && bookingRequiresEmployee == false {
            getAvailableAreas();
            return;
        }
        
        if servicesTable.selectedServices.count > 0 && cloneBooking == "n" {
            getAvailableEmployees();
        }
        else if servicesTable.selectedServices.count > 0 && cloneBooking == "q" {
            let noCloneOptionSelected = UIAlertController(title: "No Clone Option Selected", message: "Please choose if you would like to clone this booking for multiple instances so that you can save time by avoiding putting in repeat bookings.", preferredStyle: .alert);
            let okay = UIAlertAction(title: "Got it", style: .cancel, handler: nil);
            noCloneOptionSelected.addAction(okay);
            DispatchQueue.main.async {
                self.present(noCloneOptionSelected, animated: true, completion: nil);
            }
        }
        else {
            let noServicesSelected = UIAlertController(title: "No Services Selected", message: "Please select at least one service above that you would like performed.", preferredStyle: .alert);
            let okay = UIAlertAction(title: "Got it", style: .cancel, handler: nil);
            noServicesSelected.addAction(okay);
            DispatchQueue.main.async {
                self.present(noServicesSelected, animated: true, completion: nil);
            }
        }
    }
    
    private let continueButton2: UIButton = {
        let uib = Components().createContinueBookingButton()
        uib.addTarget(self, action: #selector(continueHit2), for: .touchUpInside);
        return uib;
    }();
    
    @objc func continueHit2() {
        if bookingRequiresEmployee == true {
            getAvailableEmployeesClone();
        }
        else if bookingRequiresEmployee == false {
            getAvailableAreasClone();
        }
    }
    
    @objc func dismissCreateBooking() {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    @objc func dateChanged() {
        getTimes(date: datePicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureView()
        getTimes(date: Date())
        getServices()
        setUpDrag()
    }
    
    
    private let cloneBookingText = Components().createNotAsLittleText(text: "Clone Booking?");
    
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
    
    @objc func switcherCloneYes() {
        cloneBooking = "y";
        noCloneButton.backgroundColor = .literGray;
        noCloneButton.tintColor = .darkGray2;
        yesCloneButton.backgroundColor = .darkGray2;
        yesCloneButton.tintColor = .literGray;
     
    }
    
    @objc func switcherCloneNo() {
        cloneBooking = "n";
        noCloneButton.backgroundColor = .darkGray2;
        noCloneButton.tintColor = .literGray;
        yesCloneButton.backgroundColor = .literGray;
        yesCloneButton.tintColor = .darkGray2;
    }
    
    var cloneBooking: String = "q";
    
    private let newView: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: UIScreen.main.bounds.height);
        uiv.setWidth(width: fullWidth);
        uiv.backgroundColor = .black;
        uiv.alpha = 0.8;
        return uiv;
    }()
    
    private let topBorder = Components().createBorder(height: 4, width: fullWidth / 1.3, color: .black);
    
    var dragGesture = UIPanGestureRecognizer()
    
    func setUpDrag() {
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView));
        clonePopUp.isUserInteractionEnabled = true;
        clonePopUp.addGestureRecognizer(dragGesture);
    }
    
    @objc func dragView(_ sender:UIPanGestureRecognizer) {

        if clonePopUp.center.y + 1 > view.frame.height / 1.5 {
            let translation = sender.translation(in: self.view);
            clonePopUp.center = CGPoint(x: clonePopUp.center.x, y: clonePopUp.center.y + translation.y);
            sender.setTranslation(CGPoint.zero, in: self.view);
        }
        else  {
            clonePopUp.center = CGPoint(x: clonePopUp.center.x, y: view.frame.height / 1.5)
        }
        if clonePopUp.center.y + 1 > view.frame.height - 40 {
            UIView.animate(withDuration: 0.4) {
                self.clonePopUp.frame = CGRect(x: 0, y: fullHeight, width: fullWidth, height: fullHeight / 1.5);
                self.newView.isHidden = true;
            }
        }
    }
    
    private let cloneOptionsText = Components().createNotAsLittleText(text: "Booking Clone Options", color: .mainLav);
    
    private let numOftimesToCloneText = Components().createNotAsLittleText(text: "Number of Times to Clone:", color: .mainLav);
    
    private let numWheel: CustomNumberPicker = {
        let cnp = CustomNumberPicker();
        cnp.bcn = 50;
        cnp.setWidth(width: 120);
        cnp.setHeight(height: 70);
        return cnp;
    }()
    
    private let cloneOptionsText2 = Components().createNotAsLittleText(text: "Days Between Bookings:", color: .mainLav);
    
    private let numWheel2: CustomNumberPicker = {
        let cnp = CustomNumberPicker();
        cnp.bcn = 31;
        cnp.setWidth(width: 120);
        cnp.setHeight(height: 70);
        return cnp;
    }()
    
    private let discountText = Components().createNotAsLittleText(text: "Package Discount Percent:", color: .mainLav);
    
    private let numWheel3: CustomNumberPicker = {
        let cnp = CustomNumberPicker();
        cnp.none = true;
        cnp.bcn = 100;
        cnp.setWidth(width: 120);
        cnp.setHeight(height: 70);
        return cnp;
    }()
    
    private let pText = Components().createNotAsLittleText(text: "%", color: .mainLav);
    
    
    func configureView() {
        servicesTable.requiresEmployeeDelegate = self;
        noServicesText.setWidth(width: fullWidth / 1.3);
        employeesTable.otherOtherDelegate = self;
        view.backgroundColor = .literGray;
        view.addSubview(datePickerText);
        datePickerText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 45);
        datePickerText.padLeft(from: view.leftAnchor, num: 20);
        view.addSubview(datePicker);
        datePicker.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        datePicker.padLeft(from: datePickerText.rightAnchor, num: 30);
        view.addSubview(dismissButton);
        dismissButton.padTop(from: view.topAnchor, num: 28);
        dismissButton.padRight(from: view.rightAnchor, num: 24);
        view.addSubview(timePickerText);
        timePickerText.padTop(from: datePicker.bottomAnchor, num: 5);
        timePickerText.padLeft(from: view.leftAnchor, num: 20);
        view.addSubview(timePicker);
        timePicker.padTop(from: timePickerText.topAnchor, num: -26);
        timePicker.padLeft(from: timePickerText.rightAnchor, num: 22);
        timePicker.setWidth(width: 150);
        view.addSubview(closedTodayText);
        closedTodayText.isHidden = true;
        closedTodayText.padTop(from: timePickerText.topAnchor, num: 0);
        closedTodayText.padLeft(from: timePickerText.rightAnchor, num: 10);
        view.addSubview(servicesText);
        servicesText.padTop(from: timePicker.bottomAnchor, num: 15);
        servicesText.padLeft(from: view.leftAnchor, num: 20);
        view.addSubview(servicesTable);
        servicesTable.padTop(from: servicesText.bottomAnchor, num: 20);
        servicesTable.centerTo(element: view.centerXAnchor);
        servicesTable.setHeight(height: 170);
        servicesTable.setWidth(width: fullWidth);
        servicesTable.backgroundColor = .literGray;
        view.addSubview(cloneBookingText);
        cloneBookingText.padLeft(from: view.leftAnchor, num: 20);
        cloneBookingText.padTop(from: servicesTable.bottomAnchor, num: 46);
        view.addSubview(noCloneButton);
        noCloneButton.padTop(from: servicesTable.bottomAnchor, num: 50);
        noCloneButton.padRight(from: view.rightAnchor, num: 20);
        view.addSubview(yesCloneButton);
        yesCloneButton.padRight(from: noCloneButton.leftAnchor, num: 10);
        yesCloneButton.padTop(from: servicesTable.bottomAnchor, num: 50);
        view.addSubview(continueButton);
        continueButton.padTop(from: noCloneButton.bottomAnchor, num: 40);
        continueButton.centerTo(element: view.centerXAnchor);
        view.addSubview(newView);
        newView.isHidden = true;
        view.addSubview(clonePopUp);
        clonePopUp.addSubview(topBorder);
        topBorder.centerTo(element: clonePopUp.centerXAnchor);
        topBorder.padTop(from: clonePopUp.topAnchor, num: 12);
        clonePopUp.addSubview(cloneOptionsText);
        cloneOptionsText.padTop(from: topBorder.bottomAnchor, num: 10);
        cloneOptionsText.centerTo(element: clonePopUp.centerXAnchor);
        clonePopUp.addSubview(numOftimesToCloneText);
        numOftimesToCloneText.padTop(from: cloneOptionsText.bottomAnchor, num: 20);
        numOftimesToCloneText.padLeft(from: clonePopUp.leftAnchor, num: 5);
        clonePopUp.addSubview(numWheel);
        numWheel.padTop(from: cloneOptionsText.bottomAnchor, num: 5);
        numWheel.padLeft(from: numOftimesToCloneText.rightAnchor, num: 6);
        clonePopUp.addSubview(cloneOptionsText2);
        cloneOptionsText2.padTop(from: numOftimesToCloneText.bottomAnchor, num: 50);
        cloneOptionsText2.padLeft(from: clonePopUp.leftAnchor, num: 5);
        clonePopUp.addSubview(numWheel2);
        numWheel2.padTop(from: numOftimesToCloneText.bottomAnchor, num: 34);
        numWheel2.padLeft(from: numOftimesToCloneText.rightAnchor, num: 6);
        clonePopUp.addSubview(discountText);
        discountText.padTop(from: cloneOptionsText2.bottomAnchor, num: 50);
        discountText.padLeft(from: clonePopUp.leftAnchor, num: 5);
        clonePopUp.addSubview(continueButton2);
        continueButton2.padTop(from: clonePopUp.topAnchor, num: clonePopUp.frame.height - 50);
        continueButton2.centerTo(element: clonePopUp.centerXAnchor);
        clonePopUp.addSubview(numWheel3);
        numWheel3.padTop(from: cloneOptionsText2.bottomAnchor, num: 34);
        numWheel3.padLeft(from: discountText.rightAnchor, num: 6);
        clonePopUp.addSubview(pText);
        pText.padLeft(from: numWheel3.rightAnchor, num: -5);
        pText.padTop(from: discountText.topAnchor, num: 0);
        view.addSubview(popUp);
        popUp.addSubview(customerPhoneInput);
        customerPhoneInput.padTop(from: popUp.topAnchor, num: 32);
        customerPhoneInput.padLeft(from: popUp.leftAnchor, num: 20);
        popUp.addSubview(timeDurationText);
        timeDurationText.padTop(from: customerPhoneInput.bottomAnchor, num: 18);
        timeDurationText.padLeft(from: popUp.leftAnchor, num: 20);
        popUp.addSubview(datesCollectionView);
        datesCollectionView.padTop(from: timeDurationText.topAnchor, num: -4);
        datesCollectionView.padLeft(from: timeDurationText.rightAnchor, num: 20);
        popUp.addSubview(newGuestNameInput);
        newGuestNameInput.padTop(from: timeDurationText.topAnchor, num: 0);
        newGuestNameInput.padLeft(from: customerPhoneInput.leftAnchor, num: 0);
        newGuestNameInput.isHidden = true;
        popUp.addSubview(costText);
        costText.padTop(from: timeDurationText.bottomAnchor, num: 10);
        costText.padLeft(from: popUp.leftAnchor, num: 20);
        popUp.addSubview(cancelNewGuestRegisterButton);
        cancelNewGuestRegisterButton.padTop(from: costText.topAnchor, num: 5);
        cancelNewGuestRegisterButton.padLeft(from: costText.leftAnchor, num: 70);
        cancelNewGuestRegisterButton.isHidden = true;
        popUp.addSubview(editButton);
        editButton.padTop(from: cancelNewGuestRegisterButton.topAnchor, num: 0);
        editButton.padLeft(from: cancelNewGuestRegisterButton.leftAnchor, num: 0);
        editButton.isHidden = true;
        popUp.addSubview(saveButton);
        saveButton.padTop(from: cancelNewGuestRegisterButton.topAnchor, num: 0);
        saveButton.padLeft(from: cancelNewGuestRegisterButton.rightAnchor, num: 30);
        saveButton.isHidden = true;
        popUp.addSubview(savedText);
        savedText.padTop(from: saveButton.topAnchor, num: -5);
        savedText.padLeft(from: saveButton.leftAnchor, num: 0)
        savedText.isHidden = true;
        popUp.addSubview(startGuestRegisterButton);
        startGuestRegisterButton.padTop(from: costText.topAnchor, num: 5);
        startGuestRegisterButton.padLeft(from: costText.rightAnchor, num: 65);
        popUp.addSubview(servicesChosenText);
        servicesChosenText.padTop(from: costText.bottomAnchor, num: 10);
        servicesChosenText.padLeft(from: popUp.leftAnchor, num: 20);
        popUp.addSubview(servicesChosenTable);
        servicesChosenTable.padTop(from: servicesChosenText.bottomAnchor, num: 8);
        servicesChosenTable.centerTo(element: popUp.centerXAnchor);
        popUp.addSubview(self.bctText);
        bctText.padTop(from: servicesChosenTable.bottomAnchor, num: 34);
        bctText.padLeft(from: popUp.leftAnchor, num: 20);
        popUp.addSubview(bcnSelectorCV);
        bcnSelectorCV.padTop(from: self.servicesChosenTable.bottomAnchor, num: 30);
        bcnSelectorCV.padLeft(from: bctText.rightAnchor, num: 10);
        bcnSelectorCV.setHeight(height: 40);
        bcnSelectorCV.padRight(from: view.rightAnchor, num: 20);
        bcnSelectorCV.del = self;
        popUp.addSubview(bookIfEmployeeNotNeededButton);
        bookIfEmployeeNotNeededButton.centerTo(element: popUp.centerXAnchor);
        bookIfEmployeeNotNeededButton.padTop(from: bcnSelectorCV.bottomAnchor, num: 40);
        bookIfEmployeeNotNeededButton.isHidden = true;
        if eq == "n" {
            print("NOOOOO")
            bcnSelectorCV.isHidden = false;
            popUp.addSubview(employeesAvailableText);
            employeesAvailableText.padTop(from: bcnSelectorCV.bottomAnchor, num: 20);
            employeesAvailableText.centerTo(element: popUp.centerXAnchor);
            popUp.addSubview(employeesTable);
            employeesTable.padTop(from: self.employeesAvailableText.bottomAnchor, num: 6);
            employeesTable.centerTo(element: self.popUp.centerXAnchor);
            employeesTable.setHeight(height: 200);
            employeesTable.setWidth(width: UIScreen.main.bounds.width);
            employeesTable.backgroundColor = .mainLav;
        }
        else {
            print(eq)
            bctText.isHidden = true;
            popUp.addSubview(employeesAvailableText);
            employeesAvailableText.padTop(from: servicesChosenTable.bottomAnchor, num: 20);
            employeesAvailableText.centerTo(element: popUp.centerXAnchor);
            popUp.addSubview(employeesTable)
            employeesTable.backgroundColor = .mainLav;
            employeesTable.padTop(from: employeesAvailableText.bottomAnchor, num: 6);
            employeesTable.centerTo(element: popUp.centerXAnchor);
            employeesTable.setHeight(height: UIScreen.main.bounds.height / 3);
            employeesTable.setWidth(width: UIScreen.main.bounds.width);
        }
        popUp.addSubview(cancelButton);
        cancelButton.padRight(from: view.rightAnchor, num: 20);
        cancelButton.padTop(from: popUp.topAnchor, num: 25);
        view.addSubview(noServicesText);
        noServicesText.padTop(from: servicesText.bottomAnchor, num: 8);
        noServicesText.centerTo(element: popUp.centerXAnchor);
        noServicesText.isHidden = true;
    }
    
    func getAllTimes(start: Int, close: Int) {
        var newStart = start;
        var times: [String] = [];
        while newStart < close {
            times.append(Utilities.itst[newStart]!)
            newStart += 1;
        }
        timePicker.data = times;
    }
    
    func getTimes(date: Date) {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        dateChosen = df.string(from: date);
        API().post(url: myURL + "business/startEndTime", headerToSend: Utilities().getAdminToken(), dataToSend: ["date" : self.dateChosen]) { (res) in
            self.start = res["open"] as? Int;
            self.close = res["close"] as? Int;
        }
    }
    
    func getServices() {
        API().post(url: myURL + "services/getServices", dataToSend: ["businessId": Utilities().decodeAdminToken()!["businessId"]!]) { (res) in
            if let services = res["services"] as? [[String: Any]] {
                if services.count == 0 {
                    DispatchQueue.main.async {
                        self.servicesTable.isHidden = true;
                        self.noServicesText.isHidden = false;
                    }
                    return;
                }
                var newServicesArray: [Service] = [];
                for service in services {
                    newServicesArray.append(Service(dic: service));
                }
                self.services = newServicesArray;
            }
        }
    }
    
    
    func getAvailableEmployees() {
        if closed {
            let alert = Components().createActionAlert(title: "Business Closed", message: "Your business is closed on this day.", buttonTitle: "Okay!", handler: nil);
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil);
            }
            return;
        }
        var serviceIds: [String] = [];
        var serviceNames: [String] = []
        var timeDurationNum = 0;
        var cost: Double = 0;
        var servicesArray: [String] = [];
        for service in servicesTable.selectedServices {
            servicesArray.append(service.id);
        }
            for selectedService in servicesTable.selectedServices {
                serviceIds.append(selectedService.id);
                serviceNames.append(selectedService.serviceName);
                timeDurationNum = timeDurationNum + Utilities.timeDurationStringToInt[selectedService.timeDuration]!;
                cost = cost + selectedService.cost;
            }
            let costString = String(cost);
            var costStringArray = costString.components(separatedBy: ".");
            if costStringArray[1].count == 1 {
                costStringArray[1] = costStringArray[1] + "0";
                self.costText.text = "Cost: " + "$" + costStringArray[0] + "." +  costStringArray[1];
                self.costForTable = "$" + costStringArray[0] + "." +  costStringArray[1];
            }
            else {
                self.costText.text = "Cost: " + "$" + costString;
                self.costForTable = "$" + costString;
            }
            let closeTime = Utilities.itst[Utilities.stit[self.timePicker.selectedItem!]! + timeDurationNum];
            
            API().post(url: myURL + "getBookings", dataToSend: ["businessId": Utilities().decodeAdminToken()!["businessId"], "date": self.dateChosen, "serviceIds": serviceIds, "timeChosen": self.timePicker.selectedItem, "timeDurationNum": timeDurationNum]) { (res) in
                if res["statusCode"] as! Int == 205 {
                    let alert = UIAlertController(title: "Business Closed", message: "This booking is scheduled to end after your business has closed. Please choose a time that will not go past the business closing time.", preferredStyle: .alert);
                    let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                    alert.addAction(woops);
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
                if res["statusCode"] as! Int == 409 {
                    let alert = UIAlertController(title: "Invalid Date", message: "The date or time you have chosen has already passed and cannot be scheduled.", preferredStyle: .alert);
                    let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                    alert.addAction(woops);
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
                if let bcnArray = res["bcnArray"] as? [Int] {
                    print(bcnArray);
                    print("bcnArray above")
                    self.bcnArray = bcnArray;
                }
                if let employees = res["employees"] as? [[String: String]] {
                    var newEmployeesArray: [Employee] = [];
                    for employee in employees {
                        let newEmployee = Employee(dic: employee)
                        newEmployeesArray.append(newEmployee);
                    }
                    self.employeesAvailable = newEmployeesArray;
                    self.servicesChosenTable.servicesChosen = serviceNames;
                    if newEmployeesArray.count > 0 {
                        DispatchQueue.main.async {
                            if self.eq == "y" {
                                self.bcnSelectorCV.isHidden = true;
                                self.bctText.isHidden = true;
                            }
                            self.bookIfEmployeeNotNeededButton.isHidden = true;
                            self.timeDurationText.text = self.timePicker.selectedItem! + "-" + closeTime!;
                            UIView.animate(withDuration: 0.4) {
                                self.popUp.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.00);
                            }
                        }
                    }
                }
                if let date = res["date"] as? String {
                    self.datesForCollectionView = [date];
                }
                else if res["statusCode"] as! Int == 406 || res["statusCode"] as! Int == 401 {
                    let alert = UIAlertController(title: "Time Unavailable", message: "Your business does not have any availability at this time. Want us to check for other nearby times on this date?", preferredStyle: .alert);
                    let searchOthers = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
                        print("gotta go find the others")
                    }
                    alert.addAction(searchOthers);
                    let noThanks = UIAlertAction(title: "Nope", style: .cancel) { (action: UIAlertAction) in
                        print("lol")
                    }
                    alert.addAction(noThanks)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
            }
        }
    
    func getAvailableEmployeesClone() {
        if closed {
            let alert = Components().createActionAlert(title: "Business Closed", message: "Your business is closed on this day.", buttonTitle: "Okay!", handler: nil);
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil);
            }
            return;
        }
        var serviceIds: [String] = [];
        var serviceNames: [String] = []
        var timeDurationNum = 0;
        var cost: Double = 0;
        var servicesArray: [String] = [];
        for service in servicesTable.selectedServices {
            servicesArray.append(service.id);
        }
            for selectedService in servicesTable.selectedServices {
                serviceIds.append(selectedService.id);
                serviceNames.append(selectedService.serviceName);
                timeDurationNum = timeDurationNum + Utilities.timeDurationStringToInt[selectedService.timeDuration]!;
                cost = cost + selectedService.cost;
            }
        if numWheel3.selected != "None" {
            let percentNum = Double(numWheel3.selected)! * 0.01;
            let costMinus = percentNum * cost;
            cost = cost - costMinus;
            cost = round(cost * 100) / 100;
        }
        let closeTime = Utilities.itst[Utilities.stit[self.timePicker.selectedItem!]! + timeDurationNum];
        let costString = String(cost);
        var costStringArray = costString.components(separatedBy: ".");
        if costStringArray[1].count == 1 {
            costStringArray[1] = costStringArray[1] + "0";
            self.costForTable = "$" + costStringArray[0] + "." +  costStringArray[1];
            self.costText.text = "$" + costStringArray[0] + "." +  costStringArray[1];
        }
        else {
            self.costText.text = "Cost: " + "$" + costString;
            self.costForTable = "$" + costString;
        }
        let cloneNum = numWheel.selected;
        let daysBetween = numWheel2.selected;
        
        API().post(url: myURL + "getBookings/clone", dataToSend: ["businessId": Utilities().decodeAdminToken()!["businessId"], "date": self.dateChosen, "serviceIds": serviceIds, "timeChosen": self.timePicker.selectedItem, "timeDurationNum": timeDurationNum, "cloneNum": cloneNum, "daysBetween": daysBetween]) { (res) in
            if res["statusCode"] as! Int == 205 {
                if let dayError = res["day"] as? String {
                    let alert = UIAlertController(title: "Clone Open Time Error", message: "You cannot clone this booking because your business is closed at the preferred time on " + dayError + ".", preferredStyle: .alert);
                    let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                    alert.addAction(woops);
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
                if let openError = res["openError"] as? String {
                    let alert = UIAlertController(title: "Clone Open Time Error", message: "You cannot clone this booking because your business is not open at the preferred time on " + openError + ".", preferredStyle: .alert);
                    let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                    alert.addAction(woops);
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
                return;
            }
            if res["statusCode"] as! Int == 409 {
                let alert = UIAlertController(title: "Invalid Date", message: "The date or time you have chosen has already passed and cannot be scheduled.", preferredStyle: .alert);
                let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                alert.addAction(woops);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
            if let bcnArray = res["bcnArray"] as? [Int] {
                self.bcnArray = bcnArray;
            }
            if let employees = res["employees"] as? [[String: String]], let dates = res["dates"] as? [String] {
                self.datesForCollectionView = dates;
                var newEmployeesArray: [Employee] = [];
                for employee in employees {
                    let newEmployee = Employee(dic: employee)
                    newEmployeesArray.append(newEmployee);
                }
                self.employeesAvailable = newEmployeesArray;
                self.servicesChosenTable.servicesChosen = serviceNames;
                if newEmployeesArray.count > 0 {
                    if dates.count > 0 {
                        self.datesForClone = dates;
                    }
                    DispatchQueue.main.async {
                        self.timeDurationText.text = self.timePicker.selectedItem! + "-" + closeTime!;
                        UIView.animate(withDuration: 0.4) {
                            self.popUp.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.00);
                        }
                    }
                }
            }
            else if res["statusCode"] as! Int == 406 {
                // do the alert here
                let alert = UIAlertController(title: "Time Unavailable", message: "Your business does not have any availability at this time. Want us to check for other nearby times on this date?", preferredStyle: .alert);
                let searchOthers = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
                    print("gotta go find the others")
                }
                alert.addAction(searchOthers);
                let noThanks = UIAlertAction(title: "Nope", style: .cancel) { (action: UIAlertAction) in
                    print("lol")
                }
                alert.addAction(noThanks)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }
    
    
    func getAvailableAreas() {
        if closed {
            let alert = Components().createActionAlert(title: "Business Closed", message: "Your business is closed on this day.", buttonTitle: "Okay!", handler: nil);
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil);
            }
            return;
        }
        var serviceIds: [String] = [];
        var serviceNames: [String] = []
        var timeDurationNum = 0;
        var cost: Double = 0;
        var servicesArray: [String] = [];
        for service in servicesTable.selectedServices {
            servicesArray.append(service.id);
        }
        for selectedService in servicesTable.selectedServices {
            serviceIds.append(selectedService.id);
            serviceNames.append(selectedService.serviceName);
            timeDurationNum = timeDurationNum + Utilities.timeDurationStringToInt[selectedService.timeDuration]!;
            cost = cost + selectedService.cost;
        }
        let costString = String(cost);
        var costStringArray = costString.components(separatedBy: ".");
        if costStringArray[1].count == 1 {
            costStringArray[1] = costStringArray[1] + "0";
            self.costText.text = "Cost: " + "$" + costStringArray[0] + "." +  costStringArray[1];
            self.costForTable = "$" + costStringArray[0] + "." +  costStringArray[1];
        }
        else {
            self.costText.text = "Cost: " + "$" + costString;
            self.costForTable = "$" + costString;
        }
        let closeTime = Utilities.itst[Utilities.stit[self.timePicker.selectedItem!]! + timeDurationNum];
        
        API().post(url: myURL + "getBookings/areas", dataToSend: ["businessId": Utilities().decodeAdminToken()!["businessId"], "date": self.dateChosen, "serviceIds": serviceIds, "timeChosen": self.timePicker.selectedItem, "timeDurationNum": timeDurationNum]) { (res) in
            if res["statusCode"] as! Int == 205 {
                let alert = UIAlertController(title: "Business Closed", message: "This booking is scheduled to end after your business has closed. Please choose a time that will not go past the business closing time.", preferredStyle: .alert);
                let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                alert.addAction(woops);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
                return;
            }
            if res["statusCode"] as! Int == 409 {
                let alert = UIAlertController(title: "Invalid Date", message: "The date or time you have chosen has already passed and cannot be scheduled.", preferredStyle: .alert);
                let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                alert.addAction(woops);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
                return;
            }
            if let bcnArray = res["bcnArray"] as? [Int] {
                if self.eq == "y" {
                    DispatchQueue.main.async {
                        self.bctText.isHidden = false;
                        self.bcnSelectorCV.isHidden = false;
                        self.bookIfEmployeeNotNeededButton.isHidden = false;
                    }
                }
                self.bcnArray = bcnArray;
                self.servicesChosenTable.servicesChosen = serviceNames;
                if bcnArray.count > 0 {
                    DispatchQueue.main.async {
                        self.timeDurationText.text = self.timePicker.selectedItem! + "-" + closeTime!;
                        UIView.animate(withDuration: 0.4) {
                            self.popUp.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.00);
                        }
                    }
                }
            }
            else if res["statusCode"] as? Int == 401 {
                let alert = UIAlertController(title: "Time Unavailable", message: "Your business does not have any availability at this time. Want us to check for other nearby times on this date?", preferredStyle: .alert);
                let searchOthers = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
                    print("gotta go find the others")
                }
                alert.addAction(searchOthers);
                let noThanks = UIAlertAction(title: "Nope", style: .cancel) { (action: UIAlertAction) in
                    print("lol")
                }
                alert.addAction(noThanks)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }
    
    func getAvailableAreasClone() {
        if closed {
            let alert = Components().createActionAlert(title: "Business Closed", message: "Your business is closed on this day.", buttonTitle: "Okay!", handler: nil);
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil);
            }
            return;
        }
        var serviceIds: [String] = [];
        var serviceNames: [String] = []
        var timeDurationNum = 0;
        var cost: Double = 0;
        var servicesArray: [String] = [];
        for service in servicesTable.selectedServices {
            servicesArray.append(service.id);
        }
            for selectedService in servicesTable.selectedServices {
                serviceIds.append(selectedService.id);
                serviceNames.append(selectedService.serviceName);
                timeDurationNum = timeDurationNum + Utilities.timeDurationStringToInt[selectedService.timeDuration]!;
                cost = cost + selectedService.cost;
            }
        if numWheel3.selected != "None" {
            let percentNum = Double(numWheel3.selected)! * 0.01;
            let costMinus = percentNum * cost;
            cost = cost - costMinus;
            cost = round(cost * 100) / 100;
        }
        let closeTime = Utilities.itst[Utilities.stit[self.timePicker.selectedItem!]! + timeDurationNum];
        let costString = String(cost);
        var costStringArray = costString.components(separatedBy: ".");
        if costStringArray[1].count == 1 {
            costStringArray[1] = costStringArray[1] + "0";
            self.costForTable = "$" + costStringArray[0] + "." +  costStringArray[1];
            self.costText.text = "$" + costStringArray[0] + "." +  costStringArray[1];
        }
        else {
            self.costText.text = "Cost: " + "$" + costString;
            self.costForTable = "$" + costString;
        }
        let cloneNum = numWheel.selected;
        let daysBetween = numWheel2.selected;
        
        API().post(url: myURL + "getBookings/cloneAreas", dataToSend: ["businessId": Utilities().decodeAdminToken()!["businessId"], "date": self.dateChosen, "serviceIds": serviceIds, "timeChosen": self.timePicker.selectedItem, "timeDurationNum": timeDurationNum, "cloneNum": cloneNum, "daysBetween": daysBetween]) { (res) in
            if res["statusCode"] as! Int == 205 {
                if let dayError = res["day"] as? String {
                    let alert = UIAlertController(title: "Clone Open Time Error", message: "You cannot clone this booking because your business is closed at the preferred time on " + dayError + ".", preferredStyle: .alert);
                    let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                    alert.addAction(woops);
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
                if let openError = res["openError"] as? String {
                    let alert = UIAlertController(title: "Clone Open Time Error", message: "You cannot clone this booking because your business is not open at the preferred time on " + openError + ".", preferredStyle: .alert);
                    let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                    alert.addAction(woops);
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
                return;
            }
            if res["statusCode"] as! Int == 409 {
                let alert = UIAlertController(title: "Invalid Date", message: "The date or time you have chosen has already passed and cannot be scheduled.", preferredStyle: .alert);
                let woops = UIAlertAction(title: "Woops, Got it!", style: .cancel, handler: nil);
                alert.addAction(woops);
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
            if let dates = res["dates"] as? [String], let bcnArray = res["bcnArray"] as? [Int] {
                self.bcnArray = bcnArray;
                self.datesForCollectionView = dates;
                self.servicesChosenTable.servicesChosen = serviceNames;
                if dates.count > 0 {
                    if dates.count > 0 {
                        self.datesForClone = dates;
                    }
                    DispatchQueue.main.async {
                        self.timeDurationText.text = self.timePicker.selectedItem! + "-" + closeTime!;
                        UIView.animate(withDuration: 0.4) {
                            self.popUp.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.00);
                        }
                    }
                }
            }
            else if res["statusCode"] as! Int == 406 {
                // do the alert here
                let alert = UIAlertController(title: "Time Unavailable", message: "Your business does not have any availability at this time. Want us to check for other nearby times on this date?", preferredStyle: .alert);
                let searchOthers = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
                    print("gotta go find the others")
                }
                alert.addAction(searchOthers);
                let noThanks = UIAlertAction(title: "Nope", style: .cancel) { (action: UIAlertAction) in
                    print("lol")
                }
                alert.addAction(noThanks)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }
            
    
    func bookButtonHitSingle() {
        var serviceIdsArray: [String] = [];
        for service in servicesTable.selectedServices {
            serviceIdsArray.append(service.id);
        }
        if let timeStart = self.timePicker.selectedItem, let date = self.dateChosen, let businessId = Utilities().decodeAdminToken()!["businessId"] as? String {
            if let phone = customerPhoneTextField.text {
                if phone != "" {
                    if !newGuestInfoSaved {
                        if !isNewGuestBeingRegistered {
                            var data: [String: Any];
                            if let selectedBcn = selectedBcn {
                                data = ["phone": phone ,"timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "businessId": Utilities().decodeAdminToken()!["businessId"], "bcn": selectedBcn, "cost": costForTable]
                            }
                            else {
                                data = ["phone": phone ,"timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "businessId": Utilities().decodeAdminToken()!["businessId"], "cost": costForTable]
                            }
                            API().post(url: myURL + "iosBooking/admin/area", dataToSend: data) { (res) in
                                if res["statusCode"] as! Int == 200 {
                                    self.bookHit();
                                }
                                else if res["statusCode"] as! Int == 406 {
                                    self.badPhone();
                                }
                                else if res["statusCode"] as! Int == 409 {
                                    self.bcnNotSelected();
                                }
                            }
                        }
                        else {
                            self.notFinished();
                        }
                    }
                    else {
                        let data: [String: Any];
                        if let selectedBcn = selectedBcn {
                            data = ["phone": phone, "name": newGuestNameTextField.text!, "timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "businessId": Utilities().decodeAdminToken()!["businessId"], "bcn": selectedBcn, "cost": costForTable];
                        }
                        else {
                            data = ["phone": phone, "name": newGuestNameTextField.text!, "timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "businessId": Utilities().decodeAdminToken()!["businessId"], "cost": costForTable];
                        }
                        API().post(url: myURL + "iosBooking/admin/newGuest/area", dataToSend: data) { (res) in
                            if res["statusCode"] as! Int == 200 {
                                self.bookHit();
                            }
                            else {
                                if res["statusCode"] as! Int == 409 {
                                    self.alreadyRegisted();
                                }
                            }
                        }
                    }
                }
            }
            else {
                self.noPhone()
            }
        }
    }
    
    func bookButtonHitClone() {
        var serviceIdsArray: [String] = [];
        for service in servicesTable.selectedServices {
                serviceIdsArray.append(service.id);
            }
        if let timeStart = self.timePicker.selectedItem, let date = self.dateChosen, let businessId = Utilities().decodeAdminToken()!["businessId"] as? String {
                    if let phone = customerPhoneTextField.text {
                        if !newGuestInfoSaved {
                            if !isNewGuestBeingRegistered {
                                var data: [String: Any];
                                if let selectedBcn = selectedBcn {
                                    data = ["phone": phone ,"timeStart": timeStart, "date": date, "dates": datesForClone, "serviceIds": serviceIdsArray, "businessId": Utilities().decodeAdminToken()!["businessId"], "bcn": selectedBcn, "cost": costForTable]
                                }
                                else {
                                    data = ["phone": phone ,"timeStart": timeStart, "date": date, "dates": datesForClone, "serviceIds": serviceIdsArray, "businessId": Utilities().decodeAdminToken()!["businessId"], "cost": costForTable]
                                }
                                API().post(url: myURL + "iosBooking/admin/clone", dataToSend: data) { (res) in
                                    if res["statusCode"] as! Int == 200 {
                                        self.bookHit();
                                    }
                                    else if res["statusCode"] as! Int == 406 {
                                        self.badPhone();
                                    }
                                    else if res["statusCode"] as! Int == 409 {
                                        self.bcnNotSelected();
                                    }
                                }
                            }
                            else {
                                self.notFinished();
                            }
                        }
                        else {
                            let data: [String: Any];
                            if let selectedBcn = selectedBcn {
                                data = ["phone": phone, "name": newGuestNameTextField.text!, "timeStart": timeStart, "date": date, "dates": datesForClone, "serviceIds": serviceIdsArray, "businessId": Utilities().decodeAdminToken()!["businessId"], "bcn": selectedBcn, "cost": costForTable];
                            }
                            else {
                                data = ["phone": phone, "name": newGuestNameTextField.text!, "timeStart": timeStart, "date": date, "dates": datesForClone, "serviceIds": serviceIdsArray, "businessId": Utilities().decodeAdminToken()!["businessId"], "cost": costForTable];
                            }
                            API().post(url: myURL + "iosBooking/admin/newGuest/clone", dataToSend: data) { (res) in
                                if res["statusCode"] as! Int == 200 {
                                    self.bookHit();
                                }
                                else {
                                    if res["statusCode"] as! Int == 409 {
                                        self.alreadyRegisted();
                                    }
                                }
                            }
                        }
                    }
                    else {
                        self.noPhone()
                }
            }
        }
    }
