import UIKit

protocol NotiTappedProtocol: UserNotifications {
    func tapped(noti: Notification);
}

class UserNotifications: UICollectionViewController, NotiTappedProtocol {
    
    func tapped(noti: Notification) {
        let messageVC = MessageViewController();
        messageVC.requestAnswerNoti = noti;
        present(messageVC, animated: true, completion: nil);
        if noti.notificationType == "YURA" || noti.notificationType == "BBY" || noti.notificationType == "UATG" {
            API().post(url: myURL + "notifications/changeToRead", dataToSend: ["notificationId": noti.id]) { (res) in
                if res["statusCode"] as? Int == 200 {
                    self.getUserNotis();
                }
            }
        }
    }
    
    var userNotifications: [Notification]? {
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
        getUserNotis()
    }
    
    func getUserNotis() {
        API().get(url: myURL + "notifications/getUserNotis", headerToSend: Utilities().getToken()) { (res) in
            if res["statusCode"] as? Int == 200 {
                guard let notis = res["allNotis"] as? [[String: Any]] else {
                    DispatchQueue.main.async {
                        self.testText.isHidden = false;
                    }
                    return;
                }
                var userNotificationsArray: [Notification] = [];
                for noti in notis {
                    var userNotification = Notification(dic: noti);
                    userNotificationsArray.insert(userNotification, at: 0);
                }
                self.userNotifications = userNotificationsArray;
                if userNotificationsArray.count == 0 {
                    DispatchQueue.main.async {
                        self.testText.isHidden = false;
                    }
                }
                DispatchQueue.main.async {
                    if userNotificationsArray.count > 0 && self.testText.isHidden == false {
                        self.testText.isHidden = true;
                    }
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let employeeNotifications = self.userNotifications {
            return employeeNotifications.count;
        }
        else {return 0};
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let otherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnreadRequestAnswernNotiCell", for: indexPath) as! UnreadRequestAnswerNotificationCell;
        if let userNotifications = self.userNotifications {
            let noti = userNotifications[indexPath.row];
            if noti.notificationType == "YURA" || noti.notificationType == "BBY" || noti.notificationType == "UATG" {
                
                let unreadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnreadRequestAnswernNotiCell", for: indexPath) as! UnreadRequestAnswerNotificationCell;
                unreadCell.noti = noti;
                unreadCell.userDel = self;
                unreadCell.layoutCell();
                unreadCell.layoutUnreadCell();
                return unreadCell;
            }
            else {
                let readCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadRequestAnswerNotiCell", for: indexPath) as! ReadRequestAnswerNotificationCell;
                    readCell.noti = noti;
                    readCell.layoutReadCell()
                    readCell.layoutCell();
                    readCell.userDel = self;
                    return readCell;
            }
        }
        return otherCell;
    }
}

extension UserNotifications: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 95);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
              return 0
    }
}
