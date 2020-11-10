import UIKit

protocol MessageViewControllerProtocolForEmployee: EmployeeNotifications {
    func read(notiId: String);
}

class EmployeeNotifications: UICollectionViewController, RequestAnswerCell, MessageViewControllerProtocolForEmployee {
    
    func read(notiId: String) {
        API().post(url: myURL + "notifications/employeeRead", dataToSend: ["employeeId" : Utilities().decodeEmployeeToken()!["id"], "notificationId": notiId]) { (res) in
            self.getEmployeeNotis()
        }
    }
    
    func tapped(noti: RequestAnswerNotification) {
        let messageVC = MessageViewController();
        messageVC.requestAnswerNoti = noti;
        messageVC.otherDelegate = self;
        present(messageVC, animated: true, completion: nil);
    }
    
    var employeeNotifications: [RequestAnswerNotification]? {
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
        collectionView.backgroundColor = .literGray;
        navigationController?.navigationBar.backgroundColor = .mainLav;
        navigationController?.navigationBar.barTintColor = .mainLav;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        getEmployeeNotis()
    }
    
    func getEmployeeNotis() {
        API().post(url: myURL + "notifications/employeenotifications", dataToSend: ["employeeId" : Utilities().decodeEmployeeToken()!["id"]]) { (res) in
            if res["statusCode"] as? Int == 200 {
                var notis = res["notifications"] as? [[String: Any]];
                var employeeNotificationsArray: [RequestAnswerNotification] = [];
                if let notis = notis {
                    for noti in notis {
                        var employeeNotification = RequestAnswerNotification(dic: noti);
                        employeeNotificationsArray.insert(employeeNotification, at: 0);
                    }
                    self.employeeNotifications = employeeNotificationsArray;
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
            if noti.answer == nil {
                let unreadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnreadRequestAnswernNotiCell", for: indexPath) as! UnreadRequestAnswerNotificationCell;
                unreadCell.noti = noti;
                unreadCell.layoutCell();
                unreadCell.layoutUnreadCell();
                unreadCell.delegate = self;
                unreadCell.otherDelegate = self;
                return unreadCell;
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
