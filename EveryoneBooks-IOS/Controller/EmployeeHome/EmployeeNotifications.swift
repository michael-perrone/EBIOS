import UIKit

protocol MessageViewControllerProtocolForEmployee: EmployeeNotifications {
    func answerHit();
    func alterTabs();
}
protocol UserBookedCellProtocolEmployee: EmployeeNotifications {
    func tappedUserBooked(noti: Notification);
}



class EmployeeNotifications: UICollectionViewController, RequestAnswerCell, MessageViewControllerProtocolForEmployee, UserBookedCellProtocolEmployee {
    
    
    func tappedUserBooked(noti: Notification) {
        let userBookedMessageVc = UserBookedMessageViewController();
        userBookedMessageVc.employeeDelegate = self;
        userBookedMessageVc.noti = noti;
        if let eq = eq {
            userBookedMessageVc.eq = eq;
            userBookedMessageVc.bct = self.bct;
        }
        present(userBookedMessageVc, animated: true, completion: nil);
    }
    
    var eq: String?;
    
    var bct: String?;
    
    
    weak var delegateFromHome: DoesThisStillWork?;
    
    func alterTabs() {
        delegateFromHome?.changeTabs() 
    }
    
    func answerHit() {
        self.getEmployeeNotis()
    }
    
    func tapped(noti: Notification) {
        let messageVC = MessageViewController();
        
        messageVC.requestAnswerNoti = noti;
        messageVC.employeeDelegate = self;
        present(messageVC, animated: true, completion: nil);
        if noti.notificationType == "BAW" {
            API().post(url: myURL + "notifications/changeToRead", dataToSend: ["notificationId": noti.id]) { (res) in
                    if res["statusCode"] as? Int == 200 {
                        if let notif = res["notification"] as? [String: Any] {
                            let notifi = Notification(dic: notif);
                            print(noti);
                            print("noti above");
                            let indy = self.employeeNotifications?.firstIndex(where: { notific in
                                notific.id == notifi.id
                            })
                            self.employeeNotifications?.remove(at: indy!);
                            self.employeeNotifications?.insert(notifi, at: indy!)
                        }
                        else if let notif = res["bookedNoti"] as? [String: Any] {
                            let notifi = Notification(dic: notif);
                            print(noti);
                            print("noti above");
                            let indy = self.employeeNotifications?.firstIndex(where: { notific in
                                notific.id == notifi.id
                            })
                            self.employeeNotifications?.remove(at: indy!);
                            self.employeeNotifications?.insert(notifi, at: indy!)
                        }
                    }
            }
        }
    }
    
    var employeeNotifications: [Notification]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notifications";
        collectionView.register(UnreadRequestAnswerNotificationCell.self, forCellWithReuseIdentifier: "UnreadRequestAnswernNotiCell");
        collectionView.register(ReadRequestAnswerNotificationCell.self, forCellWithReuseIdentifier: "ReadRequestAnswerNotiCell");
        collectionView.register(UserBookedUnansweredNotificationCell.self, forCellWithReuseIdentifier: "123")
        collectionView.backgroundColor = .mainLav;
        navigationController?.navigationBar.barTintColor = .mainLav;
        view.addSubview(testText);
        testText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 30);
        testText.padLeft(from: view.leftAnchor, num: 20);
        testText.padRight(from: view.rightAnchor, num: 20);
        testText.isHidden = true;
    }
    
    private let testText = Components().createNotAsLittleText(text: "You do not have any notifications at this time. We will let you know when you do!", color: .mainLav);
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        getEmployeeNotis()
    }
    
    func getEmployeeNotis() {
        API().get(url: myURL + "notifications/employeenotifications", headerToSend: Utilities().getEmployeeToken()) { (res) in
            if res["statusCode"] as? Int == 200 {
                var notis = res["notifications"] as? [[String: Any]];
                var employeeNotificationsArray: [Notification] = [];
                if let notis = notis {
                    for noti in notis {
                        var employeeNotification = Notification(dic: noti);
                        employeeNotificationsArray.insert(employeeNotification, at: 0);
                    }
                    self.employeeNotifications = employeeNotificationsArray;
                    if employeeNotificationsArray.count == 0 {
                        DispatchQueue.main.async {
                            self.testText.isHidden = false;
                        }
                    }
                    DispatchQueue.main.async {
                        if employeeNotificationsArray.count > 0 && self.testText.isHidden == false {
                            self.testText.isHidden = true;
                        }
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let employeeNotifications = self.employeeNotifications {
            return employeeNotifications.count;
        }
        else {return 0};
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let otherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnreadRequestAnswernNotiCell", for: indexPath) as! UnreadRequestAnswerNotificationCell;
        if let employeeNotifications = self.employeeNotifications {
            let noti = employeeNotifications[indexPath.row];
            if  noti.notificationType == "BAE" || noti.notificationType == "BAW" {
                let unreadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnreadRequestAnswernNotiCell", for: indexPath) as! UnreadRequestAnswerNotificationCell;
                unreadCell.noti = noti;
                unreadCell.layoutCell();
                unreadCell.layoutUnreadCell();
                unreadCell.delegate = self;
                unreadCell.otherDelegate = self;
                return unreadCell;
            }
            else if noti.notificationType == "UBU" {
                let userBookedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "123", for: indexPath) as! UserBookedUnansweredNotificationCell;
                userBookedCell.noti = noti;
                userBookedCell.layoutCell();
                userBookedCell.layoutUnread();
                userBookedCell.ubDelEmployee = self;
                return userBookedCell;
            }
            else {
                let readCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadRequestAnswerNotiCell", for: indexPath) as! ReadRequestAnswerNotificationCell;
                    readCell.noti = noti;
                    readCell.layoutReadCell()
                    readCell.layoutCell();
                    readCell.delegate = self;
                    readCell.otherDelegate = self;
                    return readCell;
            }
        }
        return otherCell;
    }
}

extension EmployeeNotifications: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 95);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
              return 0
    }
}
