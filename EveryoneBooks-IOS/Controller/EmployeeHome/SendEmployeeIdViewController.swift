//
//  SendEmployeeIdViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/31/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class SendEmployeeIdViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        tabBarController?.selectedIndex = 0;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        navigationController?.navigationBar.backgroundColor = .mainLav;
        view.backgroundColor = .mainLav;
        navigationController?.navigationItem.hidesBackButton = true;
        navigationController?.navigationBar.barTintColor = .mainLav;
    }
    
    private let logoImage: UIImageView = {
        let uiiv = UIImageView();
        uiiv.image = UIImage(named: "logo-medium");
        return uiiv;
    }()
    
    private let getAddedText: UIView = {
        let uiv = UIView();
        uiv.layer.borderColor = .CGBlack;
        uiv.layer.borderWidth = 2.0;
        uiv.backgroundColor = .white;
        let uitv = UITextView()
        uitv.text! = "Welcome to EveryoneBooks! To get started, you will need to send your unique ID to your employer/administrator. They will be able to use this ID to register you with the business you work for. Your ID is: "
        uitv.isScrollEnabled = false;
        uitv.isEditable = false;
        uitv.font = .systemFont(ofSize: 16);
        let uitv2 = UITextView();
        uitv2.text = Utilities().getEmployeeId();
        uitv2.isScrollEnabled = false;
        uitv2.isEditable = false;
        uitv2.isSelectable = true;
        uitv2.font = .boldSystemFont(ofSize: UIScreen.main.bounds.width / 20);
        uiv.addSubview(uitv)
        uiv.addSubview(uitv2);
        uitv.padTop(from: uiv.topAnchor, num: 15);
        uitv.padLeft(from: uiv.leftAnchor, num: 10);
        uitv2.padTop(from: uitv.bottomAnchor, num: 6);
        uitv2.padLeft(from: uiv.leftAnchor, num: 13);
        uitv.setWidth(width: UIScreen.main.bounds.width / 1.3)
        return uiv;
    }()
    
    private let sendIdButton: UIButton = {
        let uib = Components().createNormalButton(title: "Send ID To Employer/Admin");
        uib.addTarget(self, action: #selector(search), for: .touchUpInside);
        return uib;
    }()
    
    @objc func search() {
        let bs = BusinessSearch();
        bs.employeeSearchingForBusiness = true;
        bs.modalPresentationStyle = .overFullScreen;
        self.present(bs, animated: true, completion: nil)
    }

    
    @objc func logout() {
           let loginController = UINavigationController(rootViewController: LoginController());
           loginController.modalPresentationStyle = .fullScreen;
           loginController.modalTransitionStyle = .crossDissolve;
           Utilities().logout(key: "employeeToken");
           self.present(loginController, animated: true, completion: nil);
    }
    
   
    
    func configureView() {
        navigationItem.title = "Getting Started";
        view.addSubview(getAddedText);
        view.addSubview(logoImage);
        logoImage.centerTo(element: view.centerXAnchor);
        logoImage.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 20);
        logoImage.setHeight(height: 60);
        logoImage.setWidth(width: 60);
        getAddedText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 120);
        getAddedText.centerTo(element: view.centerXAnchor);
        getAddedText.setWidth(width: view.frame.width / 1.2);
        getAddedText.setHeight(height: view.frame.height / 2.2);
        view.addSubview(sendIdButton);
        sendIdButton.centerTo(element: view.centerXAnchor);
        sendIdButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 20);
        sendIdButton.setHeight(height: 50);
        sendIdButton.setWidth(width: 300);
    }
}
