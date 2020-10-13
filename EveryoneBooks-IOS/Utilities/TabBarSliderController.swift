//
//  TabBarControllerDragoutViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/2/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol SliderMenuDelegate: TabBarSliderController {
    func goToSelectedVC(vc: UIViewController?);
}

class TabBarSliderController: UITabBarController, SliderMenuDelegate {
    var selectableItems: [SelectionItem]? {
        didSet {
            sliderMenuTable.items = self.selectableItems;
        }
    }
    
    func goToSelectedVC(vc: UIViewController?) {
        if let vc = vc {
            vc.modalPresentationStyle = .fullScreen;
            vc.modalTransitionStyle = .crossDissolve;
            self.present(vc, animated: true, completion: nil);
        }
        else {
           // logout()
        }
    }
    
    var out = false;
    
    private let menuButton: UIBarButtonItem = {
        let uib = UIBarButtonItem(image: UIImage(named:"menu"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(slideOutOrIn))
        return uib;
    }();
    
    @objc func slideOutOrIn() {
            viewSlider.isHidden = false;
            viewSlider.alpha = 1;
            UIView.animate(withDuration: 0.45) {
                self.viewSlider.frame = CGRect(x: 400, y: 0, width: UIScreen.main.bounds.width / 1.4, height: fullHeight);
                self.backDrop.alpha = 1;
                print("BYE")
            }
            out = true;
        }
    
    private let backDrop = Components().createBackDrop();
    
    func logout() {
        let loginController = UINavigationController(rootViewController: LoginController());
        loginController.modalPresentationStyle = .fullScreen;
        loginController.modalTransitionStyle = .crossDissolve;
        print("am i running?")
        if Utilities().getEmployeeToken() != "nil" {
            Utilities().logout(key: "employeeToken");
        }
        else if Utilities().getToken() != "nil" {
            Utilities().logout(key: "token")
        }
        else if Utilities().getAdminToken() != "nil" {
            Utilities().logout(key: "adminToken")
        }
        self.present(loginController, animated: true, completion: nil);
       }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabAndSlider()
        configureSliderItems()
    }
    
    func configureSliderItems() {
         if Utilities().getEmployeeToken() != "nil" {
            let settingsController = SettingsController();
            self.selectableItems = [SelectionItem(vc: settingsController, title: "Settings", image: "🛠")];
        }
        else if Utilities().getToken() != "nil" {
            Utilities().logout(key: "token")
        }
         else if Utilities().getAdminToken() != "nil" {
            Utilities().logout(key: "adminToken")
        }
    }
    
    let sliderMenuTable = SliderMenuTable();
    
    lazy var viewSlider: UIView = {
        let vs = UIView();
        vs.setHeight(height: fullHeight);
        vs.setWidth(width: fullWidth / 1.4);
        let topTextView = Components().createSimpleText(text: "");
        if let decodedToken = Utilities().decodeUserToken() {
           topTextView.text = decodedToken["userName"] as! String;
         }
        else if let employeeDecodedToken = Utilities().decodeEmployeeToken() {
            topTextView.text = employeeDecodedToken["employeeName"] as! String;
        }
        else if let adminDecodedToken = Utilities().decodeAdminToken() {
            print("YES")
            topTextView.text = adminDecodedToken["name"] as! String;
            print(topTextView.text)
        }
        vs.addSubview(topTextView);
        topTextView.backgroundColor = .black;
        topTextView.padTop(from: vs.topAnchor, num: 40);
        topTextView.padLeft(from: vs.leftAnchor, num: 6);
        topTextView.textColor = .mainLav;
        vs.addSubview(sliderMenuTable);
        sliderMenuTable.padTop(from: vs.topAnchor, num: 20);
        sliderMenuTable.centerTo(element: vs.centerXAnchor);
        vs.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 1.4, height: fullHeight)
        vs.backgroundColor = .black;
        let border = Components().createBorder(height: fullHeight, width: 1.5, color: .gray);
        vs.addSubview(border);
        border.padRight(from: vs.rightAnchor, num: 0);
        border.padTop(from: vs.topAnchor, num: 0);
        let border2 = Components().createBorder(height: 1.5, width: fullWidth / 1.4, color: .mainLav);
        vs.addSubview(border2);
        border2.padTop(from: topTextView.bottomAnchor, num: 5);
        border2.centerTo(element: vs.centerXAnchor);
        let cancelButton = Components().createPinkXButton();
        vs.addSubview(cancelButton);
        cancelButton.padRight(from: vs.rightAnchor, num: 10);
        cancelButton.padTop(from: vs.topAnchor, num: 30)
        cancelButton.addTarget(self, action: #selector(cancel1), for: .touchUpInside);
        return vs;
    }()

@objc func cancel1() {
            UIView.animate(withDuration: 0.45) {
                self.viewSlider.alpha = 0;
                self.backDrop.alpha = 0;
    }
    
}
    
    func configureTabAndSlider() {
        backDrop.alpha = 0;
        navigationItem.leftBarButtonItem = menuButton;
        view.addSubview(viewSlider);
        viewSlider.isHidden = true;
        view.addSubview(backDrop);
        backDrop.padTop(from: view.topAnchor, num: 0);
        backDrop.centerTo(element: view.centerXAnchor);
    }
}
