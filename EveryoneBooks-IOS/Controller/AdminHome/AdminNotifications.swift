//
//  AdminSettings.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/3/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol RequestAnswerCell {
    func tapped(noti: RequestAnswerNotification);
    
}

protocol MessageViewControllerProtocolForAdmin: AdminNotifications {
    func answerHit();
}

class AdminNotifications: UICollectionViewController, RequestAnswerCell, MessageViewControllerProtocolForAdmin {
    
    func answerHit() {
        getAdminNotis()
    }
    
    func tapped(noti: RequestAnswerNotification) {
        let messageVC = MessageViewController();
        messageVC.requestAnswerNoti = noti;
        messageVC.adminDelegate = self;
        present(messageVC, animated: true, completion: nil);
        if noti.notificationType == "ERY" {
            API().post(url: myURL + "notifications/changeToRead", dataToSend: ["notificationId": noti.id]) { (res) in
                if res["statusCode"] as? Int == 200 {
                    self.getAdminNotis();
                }
            }
        }
    }
    
    var adminNotifications: [RequestAnswerNotification]? {
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
        collectionView.backgroundColor = .mainLav;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        getAdminNotis()
    }
    
    func getAdminNotis() {
        API().get(url: myURL + "notifications/getAdminNotis", headerToSend: Utilities().getAdminToken()) { (res) in
            if res["statusCode"] as? Int == 200 {
                var notis = res["notifications"] as? [[String: Any]];
                var adminNotificationsArray: [RequestAnswerNotification] = [];
                if let notis = notis {
                    for noti in notis {
                        var adminNotification = RequestAnswerNotification(dic: noti);
                        adminNotificationsArray.insert(adminNotification, at: 0);
                    }
                    self.adminNotifications = adminNotificationsArray;
                    print(self.adminNotifications);
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
