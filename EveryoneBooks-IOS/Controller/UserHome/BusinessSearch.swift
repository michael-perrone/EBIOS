//
//  ViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/5/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class BusinessSearch: UIViewController {
    
    var businesses: [Business]?
    
    var employeeSearchingForBusiness: Bool?
            

    private let businessNameTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Business Name", fontSize: 18);
        return uitf;
    }()
    
    lazy var businessNameInput: UIView = {
        let uiv = Components().createInput(textField: businessNameTextField, view: view);
        return uiv;
    }()
    
    private let cityTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Business City", fontSize: 18);
        return uitf;
    }()
    
    lazy var cityInput: UIView = {
        let uiv = Components().createInput(textField: cityTextField, view: view);
        return uiv;
    }()
    
    private let stateTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Business State", fontSize: 18);
        return uitf;
    }()
    
    lazy var stateInput: UIView = {
        let uiv = Components().createInput(textField: stateTextField, view: view);
        return uiv;
    }()
    
    private let zipTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Business Zip", fontSize: 18);
        return uitf;
    }()
    
    lazy var zipInput: UIView = {
        let uiv = Components().createInput(textField: zipTextField, view: view);
        return uiv;
    }()
    
    private let searchButton: UIButton = {
        let uib = Components().createNormalButton(title: "Search Businesses");
        uib.addTarget(self, action: #selector(searchBusinesses), for: .touchUpInside);
        return uib;
    }()
    
    private let bp: BusinessPicker = {
        let bp = BusinessPicker();
        return bp;
    }()
    
    private let backButton: UIButton = {
        let uib = Components().createBackButton();
        uib.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return uib;
    }()
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil);
    }
   
    
    @objc func searchBusinesses() {
        if bp.selected != "" || businessNameTextField.text! != "" || cityTextField.text! != "" ||  stateTextField.text! != "" || zipTextField.text! != "" {
            print(bp.selected + "selected")
            let data = ["typeOfBusiness": bp.selected, "businessName": businessNameTextField.text!, "city": cityTextField.text!, "state": stateTextField.text!, "zip": zipTextField.text!];
            API().post(url: "http://localhost:4000/api/businessList/businessSearch", headerToSend: Utilities().getToken(), dataToSend: data, completion: { (res) in
                print(res)
                guard let newBusinesses = res["businessesBack"] as? [[String: Any]] else {print("no businesses"); return}
                var businessesArray: [Business] = [];
                for newBusiness in newBusinesses {
                     let businessToAdd = Business(dic: newBusiness);
                     businessesArray.append(businessToAdd)
                }
                self.businesses = businessesArray;
                if let esfb = self.employeeSearchingForBusiness {
                    if esfb {
                        DispatchQueue.main.async {
                            let businessCollectionView = EmployeeBusinessSearchCollection(collectionViewLayout:UICollectionViewFlowLayout());
                            businessCollectionView.businesses = self.businesses;
                            let navController = UINavigationController(rootViewController: businessCollectionView);
                            navController.modalPresentationStyle = .fullScreen;
                            self.present(navController, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let businessCollectionView = BusinessSearchCollection(collectionViewLayout:UICollectionViewFlowLayout());
                        businessCollectionView.businesses = self.businesses;
                        let navController = UINavigationController(rootViewController: businessCollectionView);
                        navController.modalPresentationStyle = .fullScreen;
                        self.present(navController, animated: true, completion: nil)
                    }
                }
                
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Business Search";
        view.backgroundColor = .literGray;
        navigationItem.hidesBackButton = true;
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if let esfb = self.employeeSearchingForBusiness {
            if esfb {
                backButton.isHidden = false;
            }
        }
    }
    
    func configureUI() {
        backButton.isHidden = true;
        navigationController?.navigationBar.barTintColor = .mainLav;
        view.addSubview(businessNameInput);
        businessNameInput.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        businessNameInput.centerTo(element: view.centerXAnchor);
        view.addSubview(cityInput);
        cityInput.padTop(from: businessNameInput.bottomAnchor, num: 12);
        cityInput.centerTo(element: view.centerXAnchor);
        view.addSubview(stateInput);
        stateInput.padTop(from: cityInput.bottomAnchor, num: 12);
        stateInput.centerTo(element: view.centerXAnchor);
        view.addSubview(zipInput);
        zipInput.padTop(from: stateInput.bottomAnchor, num: 12);
        zipInput.centerTo(element: view.centerXAnchor);
        view.addSubview(bp);
        bp.setHeight(height: 100);
        bp.setWidth(width: 240);
        bp.padTop(from: zipInput.bottomAnchor, num: 5);
        bp.centerTo(element: view.centerXAnchor);
        view.addSubview(searchButton);
        searchButton.setHeight(height: 48);
        searchButton.setWidth(width: 200);
        searchButton.centerTo(element: view.centerXAnchor);
        searchButton.padTop(from: bp.bottomAnchor, num: 40);
        view.addSubview(backButton);
        backButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 20);
        backButton.padLeft(from: view.leftAnchor, num: 20);
    }
}
