//
//  SlideTabBarController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/13/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol SlideTabBarProtocol: SlideTabBarController {
    func slideBack()
}

protocol MenuCellClicked: SlideTabBarProtocol {
    func logout()
    func cellClicked(vc: UIViewController)
}

class SlideTabBarController: UITabBarController, SlideTabBarProtocol, MenuCellClicked {
  
    func logout() {
        if Utilities().getAdminToken() != "nil" {
            Utilities().logout(key: "adminToken");
        }
        else if Utilities().getEmployeeToken() != "nil" {
            Utilities().logout(key: "employeeToken");
        }
        else if Utilities().getToken() != "nil" {
            Utilities().logout(key: "token");
        }
        let loginController = UINavigationController(rootViewController: LoginController());
        loginController.modalTransitionStyle = .flipHorizontal;
        loginController.modalPresentationStyle = .fullScreen;
        self.present(loginController, animated: true, completion: nil)
    }
    
    func cellClicked(vc: UIViewController) {
        vc.modalTransitionStyle = .crossDissolve;
        vc.modalPresentationStyle = .fullScreen;
        self.present(vc, animated: true, completion: nil);
    }
    
    func slideBack() {
        print("anything working")
        UIView.animate(withDuration: 0.45) {
            self.menu.frame = CGRect(x: -(fullWidth / 1.45), y: 0, width: fullWidth / 1.45, height: fullHeight);
        }
    }
    
    private let menuButton: UIBarButtonItem = {
        let uib = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(slideOver))
        return uib;
    }()
    
    private let fmb: UIButton = {
        let uib = UIButton(type: .system);
        uib.addTarget(self, action: #selector(slideOver), for: .touchUpInside);
        uib.setTitle("⚙️", for: .normal);
        uib.titleLabel?.font = .systemFont(ofSize: 38);
        return uib;
    }()
    
    lazy var menu: Menu = {
        if Utilities().getAdminToken() != "nil" {
            let uiv = Menu(selectionItems: [SelectionItem(vc: BusinessProfileController(), title: "Business Info", image: "🏢"), SelectionItem(vc: EditBusinessProfile(), title: "Edit Business", image: "📎"), SelectionItem(vc: BusinessPerformanceController(), title: "Business Performance", image: "💰"), SelectionItem(vc: AdminEmployeePerformanceViewController(), title: "Employee Performance", image: "👥"), SelectionItem(vc: LoginController(), title: "Logout", image: "👋")]);
            uiv.cancelDelegate = self;
            uiv.cellClickedDelegate = self;
            uiv.frame = CGRect(x: -(fullWidth / 1.45), y: 0, width: fullWidth / 1.45, height: fullHeight)
            return uiv;
        }
        else if Utilities().getEmployeeToken() != "nil" {
            let uiv = Menu(selectionItems: [SelectionItem(vc: EmployeeProfileController(), title: "Profile", image: "👩‍🦲"), SelectionItem(vc: EmployeePerf(), title: "Performance", image: "💰"), SelectionItem(vc: LoginController(), title: "Logout", image: "👋")]);
            uiv.cancelDelegate = self;
            uiv.cellClickedDelegate = self;
            uiv.frame = CGRect(x: -(fullWidth / 1.45), y: 0, width: fullWidth / 1.45, height: fullHeight)
            return uiv;
        }
        else {
            let uiv = Menu(selectionItems: [SelectionItem(vc: EmployeeProfileController(), title: "Profile", image: "👩‍🦲"), SelectionItem(vc: BusinessPerformanceController(), title: "History", image: "🧧"), SelectionItem(vc: LoginController(), title: "Logout", image: "👋")]);
            uiv.cancelDelegate = self;
            uiv.cellClickedDelegate = self;
            uiv.frame = CGRect(x: -(fullWidth / 1.45), y: 0, width: fullWidth / 1.45, height: fullHeight)
            return uiv;
        }
    }()
    
    @objc func slideOver() {
        print("hello")
        UIView.animate(withDuration: 0.3) {
            self.menu.frame = CGRect(x: 0, y: 0, width: fullWidth / 1.45, height: fullHeight);
        }
    }
    
    override func viewDidLoad() {
        print(fullHeight)
        print("I AM THE FULL HEIGHT ABOVE")
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton;
        view.addSubview(fmb);
        fmb.padLeft(from: view.leftAnchor, num: 20);
        var num: CGFloat = 0.0;
        num = fullHeight * fullHeight * fullHeight / 20000000;
        fmb.padTop(from: view.topAnchor, num: num);
        view.addSubview(menu)
    }
    
    func setTabs(tab1: UIViewController, image1: UIImage, title1: String, tab2: UIViewController, image2: UIImage, title2: String, tab3: UIViewController, image3: UIImage, title3: String) {
        let nav1 = Components().createNavBarItemController(image: image1, viewController: tab1, title: title1);
        let nav2 = Components().createNavBarItemController(image: image2, viewController: tab2, title: title2);
        let nav3 = Components().createNavBarItemController(image: image3, viewController: tab3, title: title3);
        viewControllers = [nav1, nav2, nav3];
    }
}
