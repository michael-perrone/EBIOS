import UIKit

protocol FromNotiBcnSelector: UserBookedMessageViewController {
    func notiBcnSelector(num: Int);
}

class UserBookedMessageViewController: UIViewController, FromNotiBcnSelector {
    
    func notiBcnSelector(num: Int) {
        selectedBcn = num;
    }
    
    weak var employeeDelegate: MessageViewControllerProtocolForEmployee?;
    
    weak var adminDelegate: MessageViewControllerProtocolForAdmin?;
    
    var employeeName: String? {
        didSet {
            DispatchQueue.main.async {
                self.employeeNameText.text = "With Employee: " + self.employeeName!;
            }
        }
    }
    
    
    var services: [Service]?
    
    var selectedBcn: Int? {
        didSet {
            bcnCollection.selectedBcn = selectedBcn!;
        }
    }
    
    var eq: String? {
        didSet {
            figureOutBcn(noti: noti!);
        }
    }

    
    var noti: Notification?
    
    var bct: String? {
        didSet {
            bctTextField.text = bct! + ":";
        }
    }
    
    var bcns: [Int]? {
        didSet {
            bcnCollection.bcns = bcns!;
        }
    }
    
    private let bctTextField = Components().createSimpleText(text: "");
    
    private let bcnCollection = BcnSelectorCollectionView();
    
    private let fakeThing: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: 4);
        uiv.setWidth(width: 120);
        uiv.backgroundColor = .black;
        return uiv;
    }()
    
    
    
    var header: String? {
        didSet {
            headerView.text = header!;
        }
    }
    
//    self.message = self.noti!.fromName! + " has requested a booking at your business. The service requested is " + serviceNames + "." +  " The booking time is to be from " + timeBeginning! + "-" + timeEnd! + " on the date of " +
//    dateForBooking! + ". Please hit accept below if you would like to have this booked in your schedule."
    
    
    private let customerNameText = Components().createNotAsLittleText(text: "Customer Name: ");
    
    private let serviceNamesText = Components().createNotAsLittleText(text: "Services: ");
    
    private let timeAskedText = Components().createNotAsLittleText(text: "Time: ");
    
    private let dateAskedText = Components().createNotAsLittleText(text: "Date: ");
    
    private let employeeNameText = Components().createNotAsLittleText(text: "With Employee: None");
    
    
    private let headerView: UITextView = {
        let uitv = Components().createLargerText(text: "");
        uitv.setWidth(width: fullWidth - 8);
        uitv.setHeight(height: 60);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let dateView: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 13);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    
    private let yesButton: UIButton = {
        let uib = Components().createCoolButton(title: "Accept");
        return uib;
    }()
    
    private let noButton: UIButton = {
        let uib = Components().createCoolButton(title: "Deny");
        return uib;
    }()
    
    private let answeredYes: UIView = {
        let uiv = Components().createYesAnswer(answer: "Accepted");
        uiv.alpha = 0;
        return uiv;
    }()
    
    private let answeredNo: UIView = {
         let uiv = Components().createNoAnswer(answer: "Denied");
         uiv.alpha = 0;
         return uiv;
     }()
    
    func changeColors(text1: UITextView, text2: UITextView, text3: UITextView, text4: UITextView, text5: UITextView ) {
        text1.backgroundColor = .mainLav;
        text2.backgroundColor = .mainLav;
        text3.backgroundColor = .mainLav;
        text4.backgroundColor = .mainLav;
        text5.backgroundColor = .mainLav;
    }
    
   
    
    override func viewDidLoad() {
        bcnCollection.fromNotiDel = self;
        super.viewDidLoad();
        view.backgroundColor = .mainLav;
        setupUserBookedMessage()
        changeColors(text1: customerNameText, text2: serviceNamesText, text3: dateAskedText, text4: timeAskedText, text5: employeeNameText);
    }
    
    func setupUserBookedMessage() {
        if let noti = noti {
            view.addSubview(dateView);
            dateView.text = noti.date;
            dateView.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 24);
            dateView.padRight(from: view.rightAnchor, num: 5);
            view.addSubview(headerView);
            headerView.padLeft(from: view.leftAnchor, num: 8);
            headerView.padTop(from: view.topAnchor, num: 55);
            view.addSubview(customerNameText);
            customerNameText.padTop(from: headerView.bottomAnchor, num: 20);
            customerNameText.padLeft(from: view.leftAnchor, num: 8);
            view.addSubview(employeeNameText);
            employeeNameText.padTop(from: customerNameText.bottomAnchor, num: 8);
            employeeNameText.padLeft(from: view.leftAnchor, num: 8);
            view.addSubview(timeAskedText);
            timeAskedText.padLeft(from: view.leftAnchor, num: 8);
            timeAskedText.padTop(from: employeeNameText.bottomAnchor, num: 8);
            view.addSubview(dateAskedText);
            dateAskedText.padLeft(from: view.leftAnchor, num: 8);
            dateAskedText.padTop(from: timeAskedText.bottomAnchor, num: 8);
            view.addSubview(serviceNamesText);
            serviceNamesText.padTop(from: dateAskedText.bottomAnchor, num: 8);
            serviceNamesText.padLeft(from: view.leftAnchor, num: 8);
            
            if noti.notificationType! == "UBU" {
                if let eq = eq {
                    if eq == "n" {
                        view.addSubview(bctTextField);
                        bctTextField.padTop(from: serviceNamesText.bottomAnchor, num: 32);
                        bctTextField.padLeft(from: view.leftAnchor, num: 20);
                        view.addSubview(bcnCollection);
                        bcnCollection.padLeft(from: bctTextField.rightAnchor, num: 20);
                        bcnCollection.padTop(from: serviceNamesText.bottomAnchor, num: 32);
                        bcnCollection.padRight(from: view.rightAnchor, num: 20);
                        bcnCollection.setHeight(height: 40);
                        view.addSubview(yesButton);
                        yesButton.centerTo(element: view.centerXAnchor);
                        yesButton.padTop(from: bctTextField.bottomAnchor, num: 50);
                        view.addSubview(noButton);
                        noButton.centerTo(element: view.centerXAnchor);
                        noButton.padTop(from: yesButton.bottomAnchor, num: 20);
                        yesButton.addTarget(self, action: #selector(acceptUserRequest), for: .touchUpInside);
                        noButton.addTarget(self, action: #selector(denyUserRequest), for: .touchUpInside);
                        header = "User Requested Booking";
                    }
                    else {
                        print("NOT GOOD")
                    }
                }
                else {
                    view.addSubview(yesButton);
                    yesButton.centerTo(element: view.centerXAnchor);
                    yesButton.padTop(from: serviceNamesText.bottomAnchor, num: 30);
                    view.addSubview(noButton);
                    noButton.centerTo(element: view.centerXAnchor);
                    noButton.padTop(from: yesButton.bottomAnchor, num: 20);
                    yesButton.addTarget(self, action: #selector(acceptUserRequest), for: .touchUpInside);
                    noButton.addTarget(self, action: #selector(denyUserRequest), for: .touchUpInside);
                    header = "User Requested Booking";
                }
            }
            getServicesInfo()
        }
    }
    
    func getServicesInfo() {
        var timeNum = 0;
        var serviceNames = "";
        var comingFrom: String = "";
        API().post(url: myURL + "getServiceTypes", dataToSend: ["serviceTypesArray": noti!.potentialServices, "pe": noti!.potentialEmployeeId]) { res in
            if let servicesBack = res["serviceTypesArray"] as? [[String: Any]] {
                for service in servicesBack {
                    timeNum = timeNum + Utilities.timeDurationStringToInt[service["timeDuration"]! as! String]!
                    if let name = service["serviceName"] as? String {
                        if serviceNames != "" {
                            serviceNames = serviceNames + ", " + name
                        }
                        else {
                            serviceNames = name;
                        }
                    }
                }
                
                if let employee = res["employee"] as? String {
                    self.employeeName = employee;
                }
                let timeBeginning = self.noti!.potentialStartTime;
                let timeEndNum = Utilities.stit[timeBeginning!]! + timeNum;
                let timeEnd = Utilities.itst[timeEndNum];
                
                var dateForBooking: String? = "";
                
             
                DispatchQueue.main.async {
                    self.serviceNamesText.text = "Services: " + serviceNames;
                    self.timeAskedText.text = "Time: " + timeBeginning! + "-" + timeEnd!;
                    self.dateAskedText.text = "Date: " + self.noti!.potentialDate!;
                    self.customerNameText.text = "Customer: " + self.noti!.fromName!;
                    
                }
//                if self.noti!.potentialServices!.count == 1 {
//                    self.message = self.noti!.fromName! + " has requested a booking at your business. The service requested is " + serviceNames + "." +  " The booking time is to be from " + timeBeginning! + "-" + timeEnd! + " on the date of " +
//                    dateForBooking! + ". Please hit accept below if you would like to have this booked in your schedule."
//                }
//                else {
//                    self.message = self.noti!.fromName! + " has requested a booking at your business. The services requested are " + serviceNames + "." +  " The booking time is to be from " + timeBeginning! + "-" + timeEnd! + " on the date of " + dateForBooking! + ". Please hit accept below if you would like to have this booked in your schedule."
//                }
            }
        }
    }
    
    func figureOutBcn(noti: Notification) {
        var idNeeded: String = "";
        if Utilities().getAdminToken() != "nil" {
            if let adminToken = Utilities().decodeAdminToken() {
                idNeeded = adminToken["id"] as! String;
            }
        }
        else {
            if let employeeToken = Utilities().decodeEmployeeToken() {
                idNeeded = employeeToken["id"] as! String;
            }
        }
        API().post(url: myURL + "business/fbcn", dataToSend: ["idNeeded": idNeeded, "noti": noti.id]) { res in
            if let bcnArray = res["bcnArray"] as? [Int] {
                self.bcns = bcnArray;
            }
            if let employeeName = res["employeeName"] as? String {
                self.employeeName = employeeName;
            }
        }
    }

    @objc func acceptUserRequest() {
        if Utilities().getAdminToken() != "nil" {
            var businessId: String = "";
            if let bID = Utilities().getBusinessId() {
                businessId = bID
            }
            API().post(url: myURL + "iosBooking/acceptedUserRequest", dataToSend: ["notiId": noti!.id, "businessId": businessId, "bcn": selectedBcn]) { res in
                if res["statusCode"] as! Int == 200 {
                    let alert = Components().createActionAlert(title: "Booking Added", message: "This booking was succesfully added to your schedule.", buttonTitle: "Cool") { UIAlertAction in
                        API().post(url: myURL + "notifications/changeAcceptedUserRequestNoti", dataToSend: ["notiId": self.noti!.id, "businessId": businessId]) { res in
                            if res["statusCode"] as! Int == 200 {
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true, completion: nil);
                                    self.adminDelegate?.answerHit();
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
            }
        }
        else if Utilities().getEmployeeToken() != "nil" {
            let eToken = Utilities().decodeEmployeeToken();
            let id = eToken!["id"] as! String;
            API().post(url: myURL + "iosBooking/acceptedUserRequest", dataToSend: ["notiId": noti!.id, "employeeId": id, "bcn": selectedBcn]) { res in
                if res["statusCode"] as! Int == 409 {
                    let dateAlert = Components().createActionAlert(title: "Time/Date Error", message: "This time or date has already passed.", buttonTitle: "Okay!") { UIAlertAction in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil);
                            self.employeeDelegate?.answerHit();
                        }
                    }
                    DispatchQueue.main.async {
                        self.present(dateAlert, animated: true, completion: nil);
                    }
                }
                if res["statusCode"] as! Int == 200 {
                    let alert = Components().createActionAlert(title: "Booking Added", message: "This booking was succesfully added to your schedule.", buttonTitle: "Cool") { UIAlertAction in
                        API().post(url: myURL + "notifications/changeAcceptedUserRequestNoti", dataToSend: ["notiId": self.noti!.id, "employeeId": id]) { res in
                            if res["statusCode"] as! Int == 200 {
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true, completion: nil);
                                    self.employeeDelegate?.answerHit();
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
            }
            
        }
    }
    
    @objc func denyUserRequest() {
      API().post(url: myURL + "notifications/changeDeniedUserRequestNoti", dataToSend: ["notiId": self.noti!.id]) { res in
            if res["statusCode"] as! Int == 200 {
                let alert = Components().createActionAlert(title: "Request Denied", message: "You denied this booking request.", buttonTitle: "Indeed") { UIActionAlert in
                    self.dismiss(animated: true, completion: nil);
                }
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil);
                }
                self.adminDelegate?.answerHit();
            }
        }
    }
}


