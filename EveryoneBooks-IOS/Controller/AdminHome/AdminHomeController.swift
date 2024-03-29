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
    }
    
    func configureUI() {
        view.backgroundColor = .mainLav;
        tabBar.backgroundColor = .white;
    }
    
    
    func getBusiness() {
        let url = myURL + "businessProfile/myBusinessForProfile";
        API().get(url: url, headerToSend: Utilities().getAdminToken()) { (res) in
            if let profileCreated = res["profileCreated"] as? Bool {
                if profileCreated {
                    DispatchQueue.main.async {
                        self.setTabsAdmin(tab1: AdminBookings(), image1: UIImage(named: "business-tab-bar")!, title1: "Service Schedule", tab2: AdminShifts(), image2: UIImage(named: "calendar")!, title2: "Shift Schedule", tab3: AdminNotifications(collectionViewLayout: UICollectionViewFlowLayout()), image3: UIImage(named: "notis")!, title3: "Notifications", image4: UIImage(named: "group")!, title4: "Groups", tab4: GroupsClinicsController());
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.setTabsAdmin(tab1: AdminBookings(), image1: UIImage(named: "business-tab-bar")!, title1: "Service Schedule", tab2: AdminShifts(), image2: UIImage(named: "calendar")!, title2: "Shift Schedule", tab3: AdminNotifications(collectionViewLayout: UICollectionViewFlowLayout()), image3: UIImage(named: "notis")!, title3: "Notifications", image4: UIImage(named: "group")!, title4: "Groups", tab4: GroupsClinicsController());
                        let editBusiness = EditBusinessProfile();
                        editBusiness.modalPresentationStyle = .fullScreen;
                        self.present(editBusiness, animated: true, completion: nil);
                    }
                }
            }
        }
    }
}

