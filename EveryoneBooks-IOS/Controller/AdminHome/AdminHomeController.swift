//
//  AdminHomeController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/3/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class AdminHomeController: TabBarSliderController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        configureUI()
        getBusiness()
    }
    
    func configureTabs() {
        let notifications = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: AdminNotifications(collectionViewLayout: UICollectionViewFlowLayout()), title: "Notifications")
        let businessHome = Components().createNavBarItemController(image: UIImage(named: "business-tab-bar"), viewController: AdminBookings(), title: "Service Schedule")
        let schedule = Components().createNavBarItemController(image: UIImage(named: "calendar"), viewController: AdminShifts(), title: "Shift Schedule")
        viewControllers = [businessHome, schedule, notifications];
    }
    
    func configureUI() {
        view.backgroundColor = .mainLav;
    }
    
    func getBusiness() {
        print(Utilities().getAdminToken())
        print("PRINTING ADMINTOKEN ABOVE")
        let url = myURL + "businessProfile/myBusinessForProfile";
        API().get(url: url, headerToSend: Utilities().getAdminToken()) { (res) in
            if let profileCreated = res["profileCreated"] as? Bool {
                if (profileCreated) {
                    print("DEBUGY   : for now all good")
                }
                else {
                    DispatchQueue.main.async {
                        let editBusiness = EditBusinessProfile();
                        editBusiness.message = "Bitch What";
                        editBusiness.modalPresentationStyle = .fullScreen;
                        self.present(editBusiness, animated: true, completion: nil);
                    }
                }
            }
        }
    }
}
