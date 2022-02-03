//
//  EmployeeHomeController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/8/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol DoesThisStillWork: EmployeeHomeController {
    func changeTabs()
}

class EmployeeHomeController: SlideTabBarController, DoesThisStillWork {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView();
        configureTabs();
    }
    
    func changeTabs() {
        DispatchQueue.main.async {
            let employeeSchedule = Components().createNavBarItemController(image: UIImage(named: "calendar"), viewController: EmployeeSchedule(), title: "Schedule");
            let notifications = EmployeeNotifications(collectionViewLayout: UICollectionViewFlowLayout());
            let notificationsTab = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: notifications, title: "Notifications");
            
            self.viewControllers = [employeeSchedule, notificationsTab]
        }
    }
    
    func configureTabs() {
        let businessName = Utilities().decodeEmployeeToken()?["businessName"] as? String;
        if businessName == nil {
            API().get(url: myURL + "notifications/employeeHas", headerToSend: Utilities().getEmployeeToken()) { (res) in
                if res["hasBusiness"] as! Bool == false {
                    DispatchQueue.main.async {
                        let home = Components().createNavBarItemController(image: UIImage(named: "calendar"), viewController: SendEmployeeIdViewController(), title: "Home");
                        let notifications = EmployeeNotifications(collectionViewLayout: UICollectionViewFlowLayout());
                        notifications.delegateFromHome = self;
                        let notificationsTab = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: notifications, title: "Notifications");
                        self.viewControllers = [home, notificationsTab]
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let employeeSchedule = Components().createNavBarItemController(image: UIImage(named: "calendar"), viewController: EmployeeSchedule(), title: "Schedule");
                        let notifications = EmployeeNotifications(collectionViewLayout: UICollectionViewFlowLayout());
                        notifications.delegateFromHome = self;
                        let notificationsTab = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: notifications, title: "Notifications");
                        self.viewControllers = [employeeSchedule, notificationsTab]
                    }
                }
            }
        }
        else {
            DispatchQueue.main.async {
                let employeeSchedule = Components().createNavBarItemController(image: UIImage(named: "calendar"), viewController: EmployeeSchedule(), title: "Schedule");
                let notifications = EmployeeNotifications(collectionViewLayout: UICollectionViewFlowLayout());
                notifications.delegateFromHome = self;
                let notificationsTab = Components().createNavBarItemController(image: UIImage(named: "notis"), viewController: notifications, title: "Notifications");
                self.viewControllers = [employeeSchedule, notificationsTab];
            }
        }
    }
    
    func configureView() {
        view.backgroundColor = .mainLav;
        navigationController?.navigationBar.barTintColor = .mainLav;
        tabBar.backgroundColor = .mainLav;
        tabBar.barTintColor = .mainLav;
    }
}
