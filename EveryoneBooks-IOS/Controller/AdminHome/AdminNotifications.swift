//
//  AdminSettings.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/3/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol RequestAnswerCell {
    func tapped(noti: Notification);
}

protocol UserBookedCellProtocol: AdminNotifications {
    func tappedUserBooked(noti: Notification);
}

protocol AdminAnsweringUserBookedProtocol: AdminNotifications {
    func adminHitBookedAnswer();
}

protocol MessageViewControllerProtocolForAdmin: AdminNotifications {
    func answerHit();
}


class AdminNotifications: UICollectionViewController, RequestAnswerCell, MessageViewControllerProtocolForAdmin, UserBookedCellProtocol, AdminAnsweringUserBookedProtocol {
    
    func adminHitBookedAnswer() {
        collectionView.reloadData();
    }
    
    
    func tappedUserBooked(noti: Notification) {
        let userBookedMessageVc = UserBookedMessageViewController();
        userBookedMessageVc.adminDelegate = self;
        userBookedMessageVc.noti = noti;
        if let eq = eq {
            userBookedMessageVc.eq = eq;
            userBookedMessageVc.bct = self.bct;
        }
        present(userBookedMessageVc, animated: true, completion: nil);
    }
    
    
    func answerHit() {
            self.getAdminNotis();
    }
    
    func tapped(noti: Notification) {
        let messageVC = MessageViewController();
        messageVC.requestAnswerNoti = noti;
        messageVC.adminDelegate = self;
        present(messageVC, animated: true, completion: nil);
        if noti.notificationType == "ERY" || noti.notificationType == "ELB" {
            API().post(url: myURL + "notifications/changeToRead", dataToSend: ["notificationId": noti.id]) { (res) in
                if res["statusCode"] as? Int == 200 {
                    self.getAdminNotis();
                }
            }
        }
    }
    
    private let testText = Components().createNotAsLittleText(text: "You do not have any notifications at this time. We will let you know when you do!", color: .mainLav);
    
    var eq: String?;
    
    var bct: String?;
    
    var bcn: Int?;
    
    var adminNotifications: [Notification]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var businessEditButton: UIButton = {
        let uib = Components().createGoToBusinessEdit()
        uib.addTarget(self, action: #selector(editBusiness), for: .touchUpInside);
        return uib;
    }()
    
    @objc func editBusiness() {
        let editBusiness = EditBusinessProfile();
        editBusiness.modalPresentationStyle = .fullScreen;
        self.present(editBusiness, animated: true, completion: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Notifications";
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: businessEditButton);
        collectionView.register(UnreadRequestAnswerNotificationCell.self, forCellWithReuseIdentifier: "UnreadAdminNotiCell");
        collectionView.register(ReadRequestAnswerNotificationCell.self, forCellWithReuseIdentifier: "ReadAdminNotiCell");
        collectionView.register(UserBookedUnansweredNotificationCell.self, forCellWithReuseIdentifier: "UBC");
        collectionView.backgroundColor = .mainLav;
        view.addSubview(testText);
        testText.centerTo(element: view.centerXAnchor);
        testText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 20);
        testText.setWidth(width: fullWidth / 1.15);
        testText.isHidden = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        getAdminNotis()
    }
    
    func getAdminNotis() {
        API().get(url: myURL + "notifications/getAdminNotis", headerToSend: Utilities().getAdminToken()) { (res) in
            if res["statusCode"] as? Int == 200 {
                if let eq = res["eq"] as? String, let bct = res["bct"] as? String {
                    if eq == "n" {
                        self.bct = bct;
                        self.eq = eq;
                    }
                }
                var notis = res["notifications"] as? [[String: Any]];
                if let notis = notis {
                    DispatchQueue.main.async {
                        if notis.count == 0 && self.testText.isHidden == true {
                            self.testText.isHidden = false;
                        }
                        else if self.testText.isHidden == false && notis.count > 0 {
                            self.testText.isHidden = true
                        }
                    }
                    var adminNotificationsArray: [Notification] = [];
                    for noti in notis {
                        var adminNotification = Notification(dic: noti);
                        adminNotificationsArray.insert(adminNotification, at: 0);
                    }
                    self.adminNotifications = adminNotificationsArray;
                }
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let adminNotis = self.adminNotifications {
            return adminNotis.count;
        }
        else {return 0};
     }
     
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let adminNotis = self.adminNotifications {
                let noti = adminNotis[indexPath.row];
                if noti.notificationType == "ERY" || noti.notificationType == "ESID" || noti.notificationType == "ELB" {
                    let unreadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnreadAdminNotiCell", for: indexPath) as! UnreadRequestAnswerNotificationCell;
                    unreadCell.noti = noti;
                    unreadCell.layoutCell();
                    unreadCell.layoutUnreadCell();
                    unreadCell.delegate = self;
                    return unreadCell;
                }
                else if noti.notificationType == "UBU" {
                    let userBookedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UBC", for: indexPath) as! UserBookedUnansweredNotificationCell;
                    userBookedCell.noti = noti;
                    userBookedCell.layoutCell();
                    userBookedCell.layoutUnread();
                    userBookedCell.ubDel = self;
                    return userBookedCell;
                }
                else {
                    let readCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadAdminNotiCell", for: indexPath) as! ReadRequestAnswerNotificationCell;
                    readCell.noti = noti;
                    readCell.layoutReadCell()
                    readCell.layoutCell();
                    readCell.delegate = self;
                    return readCell;
                }
        }
        return RequestAnswerNotificationCell()
    }
}

extension AdminNotifications: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 95);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
              return 0
          }
}
