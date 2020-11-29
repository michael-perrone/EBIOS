//
//  EmployeeHomeController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/8/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeeHomeController: SlideTabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated);
        configureTabs();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView();
    }
    
    func configureTabs() {
        print("running")
        let businessName = Utilities().decodeEmployeeToken()?["businessName"] as? String;
        print(businessName)
        if businessName == nil {
            API().get(url: myURL + "notifications/employeeHas", headerToSend: Utilities().getEmployeeToken()) { (res) in
                print(res)
                if res["notis"] as! Bool == false {
                    DispatchQueue.main.async {
                        let home = Components().createNavBarItemController(image: UIImage(named: "calendar"), viewController: SendEmployeeIdViewController(), title: "Home");
                        let notifications = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: EmployeeNotifications(collectionViewLayout: UICollectionViewFlowLayout()), title: "Notifications")
                        self.viewControllers = [home, notifications]
                    }
                }
                else {
                    print("down here")
                    DispatchQueue.main.async {
                        let employeeSchedule = Components().createNavBarItemController(image: UIImage(named: "calendar"), viewController: EmployeeSchedule(), title: "Schedule");
                        let notifications = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: EmployeeNotifications(collectionViewLayout: UICollectionViewFlowLayout()), title: "Notifications")
                        self.viewControllers = [employeeSchedule, notifications]
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                let employeeSchedule = Components().createNavBarItemController(image: UIImage(named: "calendar"), viewController: EmployeeSchedule(), title: "Schedule");
                let notifications = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: EmployeeNotifications(collectionViewLayout: UICollectionViewFlowLayout()), title: "Notifications")
                self.viewControllers = [employeeSchedule, notifications]
            }
        }
    }
    
    func configureView() {
        view.backgroundColor = .literGray;
        navigationController?.navigationBar.barTintColor = .mainLav;
        tabBar.backgroundColor = .mainLav;
        tabBar.barTintColor = .mainLav;
    }
}
