import UIKit

protocol GroupJoinDelegate: BusinessPageController {
    func joinGroup(groupId: String, price: String);
}

class BusinessPageController: UIViewController, GroupJoinDelegate {
    
    func joinGroup(groupId: String, price: String) {
        let actionAlert = Components().createActionAlert(title: "Join this group?", message: "Would you like to join this group? The price is " + price + ".", buttonTitle: "Yes") { UIAlertAction in
            API().post(url: myURL + "groups/join", headerToSend: Utilities().getToken(), dataToSend: ["groupId": groupId]) { res in
                print(res)
            }
        }
        let decline = UIAlertAction(title: "No Thanks", style: .cancel, handler: nil);
        actionAlert.addAction(decline);
        self.present(actionAlert, animated: true, completion: nil);
    }
    
    var businessId: String? {
        didSet {
            getBusinessInfo();
        }
    }
    
    var services: [Service]? {
        didSet {
            table.services = self.services;
        }
    }
    
    var business: Business? {
        didSet {
            DispatchQueue.main.async {
                self.navigationItem.title = self.business?.nameOfBusiness!;
                self.streetText.text = self.business?.street;
                self.stateText.text = self.business?.state;
                self.cityText.text = self.business?.city;
                self.zipText.text = self.business?.zip;
                self.phoneText.text = self.business?.phone;
                self.webText.text = self.business?.website;
                if self.business!.schedule!.sunOpen == "Closed" || self.business!.schedule!.sunClose == "Closed" {
                    self.sunText.text = "Sun: Closed"
                }
                else {
                    self.sunText.text = "Sun: \(self.business!.schedule!.sunOpen)-\(self.business!.schedule!.sunClose)"
                }
                if self.business!.schedule!.monOpen == "Closed" || self.business!.schedule!.monClose == "Closed" {
                    self.monText.text = "Mon: Closed"
                }
                else {
                    self.monText.text = "Mon: \(self.business!.schedule!.monOpen)-\(self.business!.schedule?.monClose ?? "")"
                }
                if self.business!.schedule!.tueOpen == "Closed" || self.business!.schedule!.tueClose == "Closed" {
                    self.tueText.text = "Tue: Closed"
                }
                else {
                    self.tueText.text = "Tue: \(self.business!.schedule!.tueOpen)-\(self.business!.schedule!.tueClose)"
                }
                if self.business!.schedule!.wedOpen == "Closed" || self.business!.schedule!.wedClose == "Closed" {
                    self.wedText.text = "Wed: Closed"
                }
                else {
                    self.wedText.text = "Wed: \(self.business!.schedule!.wedOpen)-\(self.business!.schedule!.wedClose)"
                }
                if self.business!.schedule?.thuOpen == "Closed" || self.business!.schedule?.thuClose == "Closed" {
                    self.thuText.text = "Thu: Closed"
                }
                else {
                    self.thuText.text = "Thu: \(self.business!.schedule!.thuOpen)-\(self.business!.schedule!.thuClose)"
                }
                if self.business!.schedule!.friOpen == "Closed" || self.business!.schedule!.friClose == "Closed" {
                    self.friText.text = "Fri: Closed"
                }
                else {
                    self.friText.text = "Fri: \(self.business!.schedule!.friOpen)-\(self.business!.schedule!.friClose)"
                }
                if self.business!.schedule!.satOpen == "Closed" || self.business!.schedule!.satClose == "Closed" {
                    self.satText.text = "Sat: Closed"
                }
                else {
                    self.satText.text = "Sat: \(self.business!.schedule!.satOpen)-\(self.business!.schedule!.satClose)"
                }
            }
        }
    }
    
    lazy var bookButton: UIButton = {
        let uib = Components().createRightButton(title: "Book");
        uib.addTarget(self, action: #selector(goToBook), for: .touchUpInside)
        return uib;
    }();
    
    @objc func goToBook() {
        let userBookingSomethingController = UserBookingSomething();
        userBookingSomethingController.comingFromBusinessPage = true;
        userBookingSomethingController.business = self.business;
        userBookingSomethingController.services = self.services;
        navigationController?.pushViewController(userBookingSomethingController, animated: true);
    }
    
    lazy var xButton: UIButton = {
        let uib = Components().createXButton();
        uib.addTarget(self, action: #selector(exit), for: .touchUpInside);
        return uib;
    }()
    
    private var streetText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    private var cityText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    private var stateText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    private var zipText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    private var phoneText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    var webText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    var sunText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    var monText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    var tueText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    var wedText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    var thuText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    var friText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    var satText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        
        return uitv;
    }()
    
    private let scrollView: UIScrollView = {
        let uisv = UIScrollView();
        let size = CGSize(width: UIScreen.main.bounds.width, height: 1000);
        uisv.contentSize = size;
        
        return uisv;
    }()
    
    private let table: ServicesDisplayTable = {
        let table = ServicesDisplayTable();
        return table;
    }()
    
    private let servicesDontExistText: UITextView = {
        let uitv = Components().createNotAsLittleText(text: "This business has not listed any services they are able to perform at this time.", color: .mainLav);
        uitv.setWidth(width: fullWidth / 1.4);
        return uitv;
    }()
    
    private let serviceText: UITextView = {
        let uitv = Components().createNotAsLittleText(text: "Services", color: .mainLav);
    
        return uitv;
    }()
    
    private let locationHoursText: UITextView = {
        let uitv = Components().createSimpleText(text: "Location/Hours");
        
        return uitv;
    }();
    
    
    @objc func exit() {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getGroupsToJoin();
    }
    
    var groupsToJoin: [Group]? {
        didSet {
            groupTable.groups = self.groupsToJoin!;
            print(groupsToJoin?.count);
        }
    }
    
    func getGroupsToJoin() {
        API().post(url: myURL + "groups/toJoin", headerToSend: Utilities().getToken(), dataToSend: ["businessId": self.businessId!]) { res in
            print(res)
            print("BELOW RES");
            if let groupsBack = res["groups"] as? [[String: String]] {
                print(groupsBack);
                print("BELOW GROUPSBACK")
                var groupsArray: [Group] = [];
                for group in groupsBack {
                    groupsArray.append(Group(dic: group));
                }
                self.groupsToJoin = groupsArray;
                if self.groupsToJoin!.count == 0 {
                    DispatchQueue.main.async {
                        self.groupTable.isHidden = true;
                        self.noGroups.isHidden = false;
                    }
                }
            }
        }
    }
    
    private let noGroups = Components().createNotAsLittleText(text: "There are no groups available that you haven't already joined at this business.", color: .mainLav);
    
    func getBusinessInfo() {
        let data = ["businessId": self.businessId!];
        API().post(url: "http://localhost:4000/api/business/appBusiness", dataToSend: data) { (res) in
            if let business = res["business"] as? [String: Any] {
                self.business = Business(dic: business);
            }
            if let services = res["services"] as? [[String:Any]] {
                if services.count == 0 {
                    DispatchQueue.main.async {
                        self.table.isHidden = true;
                        self.servicesDontExistText.isHidden = false;
                    }
                }
                var servicesArray: [Service] = []
                for service in services {
                    servicesArray.append(Service(dic: service));
                }
                self.services = servicesArray;
            }
        }
    }
    
    private let groupTable = GroupTable();
    
    private var availableGroupsText = Components().createNotAsLittleText(text: "Groups Available to Join", color: .mainLav);
    

    func configureView() {
        groupTable.joinDelegate = self;
        navigationController?.navigationBar.barTintColor = .mainLav;
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: xButton);
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookButton);
        view.backgroundColor = .mainLav;
        view.addSubview(scrollView);
        scrollView.padLeft(from: view.leftAnchor, num: 0);
        scrollView.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 0);
        scrollView.setHeight(height: view.frame.height);
        scrollView.setWidth(width: view.frame.width);
        let infoView = UIStackView(arrangedSubviews: [streetText, cityText, stateText, zipText, phoneText, webText]);
        infoView.backgroundColor = .mainLav;
        infoView.setHeight(height: 231.5);
        infoView.setWidth(width: view.frame.width / 2.05);
        infoView.backgroundColor = .mainLav;
        infoView.axis = .vertical;
        infoView.distribution = .fillEqually;
        scrollView.addSubview(locationHoursText);
        locationHoursText.padTop(from: scrollView.topAnchor, num: 10);
        locationHoursText.centerTo(element: view.centerXAnchor);
        scrollView.addSubview(infoView);
        infoView.padLeft(from: view.leftAnchor, num: view.frame.width / 2 - view.frame.width / 2.05);
        infoView.padTop(from: scrollView.topAnchor, num: 72);
        let scheduleView = UIStackView(arrangedSubviews: [sunText, monText, tueText, wedText, thuText, friText, satText]);
        scheduleView.backgroundColor = .mainLav;
        scheduleView.setHeight(height: 225);
        scheduleView.setWidth(width: view.frame.width / 2);
        scheduleView.backgroundColor = .mainLav;
        scheduleView.axis = .vertical;
        scheduleView.distribution = .fillEqually;
        scrollView.addSubview(scheduleView);
        scheduleView.padRight(from: view.rightAnchor, num: view.frame.width / 2 - view.frame.width / 2.05);
        scheduleView.padTop(from: scrollView.topAnchor, num: 70);
        view.addSubview(availableGroupsText);
        availableGroupsText.padTop(from: scheduleView.bottomAnchor, num: 20);
        availableGroupsText.centerTo(element: view.centerXAnchor);
        view.addSubview(groupTable);
        groupTable.setHeight(height: 210);
        groupTable.backgroundColor = .mainLav;
        groupTable.setWidth(width: fullWidth);
        groupTable.padTop(from: availableGroupsText.bottomAnchor, num: 30);
        groupTable.centerTo(element: view.centerXAnchor);
        view.addSubview(noGroups);
        noGroups.setWidth(width: view.frame.width / 1.4);
        noGroups.isHidden = true;
        noGroups.centerTo(element: view.centerXAnchor);
        noGroups.padTop(from: availableGroupsText.bottomAnchor, num: 10);
        view.addSubview(serviceText);
        serviceText.centerTo(element: view.centerXAnchor);
        serviceText.padTop(from: groupTable.bottomAnchor, num: 40);
        view.addSubview(table);
        table.centerTo(element: view.centerXAnchor);
        table.padTop(from: serviceText.bottomAnchor, num: 0);
        servicesDontExistText.isHidden = true;
        view.addSubview(servicesDontExistText);
        servicesDontExistText.padTop(from: serviceText.bottomAnchor, num: 8);
        servicesDontExistText.centerTo(element: view.centerXAnchor);
    }

}
