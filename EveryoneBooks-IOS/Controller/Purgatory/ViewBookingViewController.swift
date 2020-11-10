//
//  ViewBookingViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/8/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol EditServicesDelegate: ViewBookingViewController {
    func removeService(service: Service);
    func addService(service: Service);
}

class ViewBookingViewController: UIViewController, EditServicesDelegate {
    
    func addService(service: Service) {
        
    }
    
    
    func removeService(service: Service) {
        
    }
    
    var services: [Service]? {
        didSet {
            editServicesTable.services = self.services;
        }
    }
    
    var booking: Booking? {
        didSet {
            print(booking);
        }
    }
    
    private let editServicesTable = EditServicesTable();
    
    lazy var exitButton: UIButton = {
        let uib = Components().createXButton();
        uib.addTarget(self, action: #selector(exit), for: .touchUpInside);
        return uib;
    }()
    
    private let servicesText: UITextView = {
        let uitv = Components().createSimpleText(text: "Services:");
        uitv.font = .systemFont(ofSize: 24);
        return uitv;
    }()
    
    
    
    
    @objc func exit() {
        print("HELLO");
        navigationController?.popViewController(animated: true);
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.hidesBackButton = true;
        configureView();
        handleLogo();
    }
    
    func configureView() {
        view.backgroundColor = .literGray;
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: exitButton);
    }
    
    func handleLogo() {
        navigationController?.navigationBar.backgroundColor = .mainLav;
               navigationController?.navigationBar.barTintColor = .mainLav;
               let logoView = UIImageView(image: UIImage(named: "logo-small"));
               logoView.setHeight(height: 36);
               logoView.setWidth(width: 36);
               navigationItem.titleView = logoView;
    }
}
