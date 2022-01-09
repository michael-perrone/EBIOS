//
//  AdminHomeController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/3/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class AdminHomeController: SlideTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getBusiness();
        print("THIS HAS TO WORK")
    }
    
    func configureUI() {
        view.backgroundColor = .mainLav;
    }
    
    func getBusiness() {
        let url = myURL + "businessProfile/myBusinessForProfile";
        API().get(url: url, headerToSend: Utilities().getAdminToken()) { (res) in
            print("thisss")
            print(res)
            if let profileCreated = res["profileCreated"] as? Bool {
                print(profileCreated)
                print("hello allow me")
                if profileCreated {
                    DispatchQueue.main.async {
                        self.setTabs(tab1: AdminBookings(), image1: UIImage(named: "business-tab-bar")!, title1: "Service Schedule", tab2: AdminShifts(), image2: UIImage(named: "calendar")!, title2: "Shift Schedule", tab3: AdminNotifications(collectionViewLayout: UICollectionViewFlowLayout()), image3: UIImage(named: "notis")!, title3: "Notifications");
                        
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.setTabs(tab1: AdminBookings(), image1: UIImage(named: "business-tab-bar")!, title1: "Service Schedule", tab2: AdminShifts(), image2: UIImage(named: "calendar")!, title2: "Shift Schedule", tab3: AdminNotifications(collectionViewLayout: UICollectionViewFlowLayout()), image3: UIImage(named: "notis")!, title3: "Notifications");
                        let editBusiness = EditBusinessProfile();
                        editBusiness.message = "Stop it";
                        editBusiness.modalPresentationStyle = .fullScreen;
                        self.present(editBusiness, animated: true, completion: nil);
                    }
                }
            }
        }
    }
}
