import UIKit


class ViewGroupViewController: UIViewController {
    
    var group: Group? {
        didSet {
            API().post(url: myURL + "getBookings/moreGroupInfo", dataToSend: ["bookingId": group!.id]) { (res) in
                if let employeeNameBack = res["employeeName"] as? String {
                    self.employeeName = employeeNameBack;
                }
                var customersArray: [Customer] = [];
                if let customersComingBack = res["customers"] as? [[String: Any]] {
                    for customer in customersComingBack {
                       var customer = Customer(dic: customer);
                    }
                    
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
    
    var customers: [Customer]?;

    
    var employeeName: String?
    
    
    // MARK: - Interface
    
    private let employeeNameHeader = Components().createLittleText(text: "Employee Name:", color: .mainLav);
    
    private let employeeNameText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    
    private let timeOfServiceHeader = Components().createLittleText(text: "Time of Serivce:", color: .mainLav);
    
    private let timeOfServiceText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let dateHeader = Components().createLittleText(text: "Date of Service:", color: .mainLav);
    
    private let dateText = Components().createNotAsSmallText(text: "", color: .mainLav);
    
    private let costHeader = Components().createLittleText(text: "Cost of Service:", color: .mainLav);
    
    private let costText = Components().createNotAsSmallText(text: "", color: .mainLav);
    

    
    
    
    private let cancelGroupButton: UIButton = {
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
    

    @objc func cancelBooking() {
        let alert = Components().createActionAlert(title: "Cancel Booking?", message: "Click okay to cancel this booking. This action is not reverisble!", buttonTitle: "Okay") { (UIAlertAction) in
            API().post(url: myURL + "iosBooking/group/delete", headerToSend: Utilities().getAdminToken(), dataToSend: ["bookingId": self.group!.id]) { (res) in
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
        employeeNameHeader.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 12);
        employeeNameHeader.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(employeeNameText);
        employeeNameText.padTop(from: employeeNameHeader.bottomAnchor, num: -10);
        employeeNameText.padLeft(from: view.leftAnchor, num: 4);
        view.addSubview(timeOfServiceHeader);
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
    }
    
    func handleLogo() {
            navigationController?.navigationBar.backgroundColor = .mainLav;
            navigationController?.navigationBar.barTintColor = .mainLav;
            navigationItem.title = "Booking Details"
    }

}

