//
//  RegisterAdminController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/23/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RegisterAdminController: UIViewController {
    
    private var businessName = "";
    private var typeOfBusiness = "";
    private var fullName = "";
    private var email = "";
    private var password = "";
    private var street = "";
    private var city = "";
    private var state = "";
    private var zip = "";
    private var phone = "";
    private var website = "";
    private var satOpen = "";
    private var satClose = "";
    private var sunOpen = "";
    private var sunClose = "";
    private var monOpen = "";
    private var monClose = "";
    private var tueOpen = "";
    private var tueClose = "";
    private var wedOpen = "";
    private var wedClose = "";
    private var thuOpen = "";
    private var thuClose = "";
    private var friOpen = "";
    private var friClose = "";
    
    private var regOneEntered = false;
    private var regTwoEntered = false;
    private var regThreeEntered = false;
    private var regFourEntered = false;
    private var regFiveEntered = false;
    private var regSixEntered = false;
    private var regSevenEntered = false;
    private var error = "";

 
    // MARK: - UI
    
    // MARK: - FRONT PAGE
    
    let backButton: UIButton = {
        let uib = Components().createBackButton();
        uib.addTarget(self, action: #selector(goBack), for: .touchUpInside);
        return uib;
    }()
    
    let progressBar: UIProgressView = {
        let uip = UIProgressView();
        uip.layer.borderWidth = 2.0;
        uip.progress = 0
        uip.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        return uip;
    }()
    
    private let regAdminOne: RegAdminOne = {
        let uiv = RegAdminOne();
        return uiv;
    }();
    
    private let regAdminTwo: RegAdminTwo = {
        let uiv = RegAdminTwo();
        return uiv;
    }()
    
    private let regAdminThree: RegAdminThree = {
        let uiv = RegAdminThree();
        return uiv;
    }()
    
    private let regAdminFour: RegAdminFour = {
           let uiv = RegAdminFour();
           return uiv;
       }()
    
    private let regAdminFive: RegAdminFive = {
             let uiv = RegAdminFive();
             return uiv;
         }()
    
    private let regAdminSix: RegAdminSix = {
        let uiv = RegAdminSix();
        return uiv;
    }()
    
    private let regAdminSeven: RegAdminSeven = {
        let uiv = RegAdminSeven();
        return uiv;
    }()
    
    private let questionButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setTitle("?", for: .normal);
        uib.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1);
        uib.layer.borderWidth = 3.0;
        uib.setHeight(height: 60);
        uib.setWidth(width: 60);
        uib.titleLabel?.font = UIFont.boldSystemFont(ofSize: 42);
        uib.layer.cornerRadius = 30.0;
        uib.addTarget(self, action: #selector(questionHit), for: .touchUpInside);
        return uib;
    }()
    
    private let errorText: UITextView = {
        let uitv = UITextView();
        uitv.backgroundColor = .mainLav;
        uitv.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1);
        uitv.text = "";
        uitv.font = .systemFont(ofSize: UIScreen.main.bounds.width / 17);
        uitv.textAlignment = .center;
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        return uitv;
    }()
    
    private let continueButton: UIButton = {
           let uib = Components().createNormalButton(title: "Continue");
       uib.addTarget(self, action: #selector(continueHit), for: .touchUpInside)
           return uib;
       }()
       
    @objc func continueHit() {
        if !regOneEntered {
            self.businessName = regAdminOne.getName();
            self.typeOfBusiness = regAdminOne.getType();
            if businessName == "" {
                error = "Please enter name of Business"
            }
            else if typeOfBusiness == "" || typeOfBusiness == "Select Business"{
                error = "Please enter type of Business"
            }
            else {
                error = "";
                regAdminOne.isHidden = true;
                regOneEntered = true;
                progressBar.progress = 0.15;
                regAdminTwo.isHidden = false;
          }
        }
        else if !regTwoEntered {
            self.email = regAdminTwo.getEmail();
            self.password = regAdminTwo.getPassword();
            if email == "" {
                error = "Please Enter Email"
            }
            else if password == "" {
                error = "Please Enter A Password"
            }
            else if password != regAdminTwo.getConfirmPassword() {
                error = "Passwords do not match"
            }
            else {
                API().post(url: myURL + "auth/checkEmail", dataToSend: ["email": self.email]) { (res) in
                    if res["statusCode"] as? Int == 200 {
                        DispatchQueue.main.async {
                            self.regAdminTwo.isHidden = true;
                            self.error = "";
                            self.regTwoEntered = true;
                            self.progressBar.progress = 0.3;
                            self.regAdminThree.isHidden = false;
                            self.errorText.text = "";
                        }
                    }
                    else {
                        self.error = "This email is already being used";
                        DispatchQueue.main.async {
                            self.errorText.text = self.error;
                            self.errorText.isHidden = false;
                        }
                        print("HERE I AM ROCKING LIKE A HURRICANE")
                    }
                }
            }
        }
        else if !regThreeEntered {
            self.street = regAdminThree.getStreet();
            self.city = regAdminThree.getCity();
            self.state = regAdminThree.getState();
            self.zip = regAdminThree.getZip()
            if street == "" {
                error = "Please Enter Street Name"
            }
            else if city == "" {
                error = "Please Enter City Name"
            }
            else if state == "" {
                error = "Please Enter State Name"
            }
            else if zip == "" {
                error = "Please Enter Zip Code"
            }
            else {
                error = "";
                regThreeEntered = true;
                regAdminThree.isHidden = true;
                regAdminFour.isHidden = false;
                progressBar.progress = 0.45;
            }
         }
        else if !regFourEntered {
            self.website = regAdminFour.getWebsite();
            self.phone = regAdminFour.getPhone();
            if phone == "" {
                error = "Please Enter Phone Number";
            }
            else {
                error = "";
                regFourEntered = true;
                regAdminFour.isHidden = true;
                regAdminFive.isHidden = false;
                progressBar.progress = 0.6;
                
            }
        }
        else if !regFiveEntered {
            satOpen = regAdminFive.getSatOpen();
            satClose = regAdminFive.getSatClose();
            sunOpen = regAdminFive.getSunOpen();
            sunClose = regAdminFive.getSunClose();
            var okay = true;
            [sunOpen, sunClose, satOpen, satClose].forEach { (time) in
                if time == "Open" || time == "Close" {
                    let alert = Components().createActionAlert(title: "Time Error", message: "Please make sure the open and close slot for each day is correctly changed to a time or that it is changed to CLOSED if your business is closed that day.", buttonTitle: "Woops, okay!", handler: nil);
                    self.present(alert, animated: true, completion: nil);
                    okay = false;
                }
            }
            if okay {
                regFiveEntered = true;
                regAdminFive.isHidden = true;
                regAdminSix.isHidden = false;
                progressBar.progress = 0.75;
                error = "";
            }
        }
        else if !regSixEntered {
            print(regAdminSix.getThuOpen())
            monOpen = regAdminSix.getMonOpen();
            monClose = regAdminSix.getMonClose();
            tueOpen = regAdminSix.getTueOpen();
            tueClose = regAdminSix.getTueClose();
            wedOpen = regAdminSix.getWedOpen();
            wedClose = regAdminSix.getWedClose();
            thuOpen = regAdminSix.getThuOpen();
            thuClose = regAdminSix.getThuClose();
            friOpen = regAdminSix.getFriOpen();
            friClose = regAdminSix.getFriClose();
            var okay = true;
            [monOpen, monClose, tueOpen, tueClose, wedOpen, wedClose, thuOpen, thuClose, friOpen].forEach { (time) in
                if time == "Open" || time == "Close" {
                    let alert = Components().createActionAlert(title: "Time Error", message: "Please make sure the open and close slot for each day is correctly changed to a time or that it is changed to CLOSED if your business is closed that day.", buttonTitle: "Woops, okay!", handler: nil);
                    self.present(alert, animated: true, completion: nil);
                    okay = false;
                }
            }
            if okay {
                regSixEntered = true;
                regAdminSix.isHidden = true;
                regAdminSeven.isHidden = false;
                progressBar.progress = 0.9;
                error = "";
            }
        }
        else if !regSevenEntered {
            if let bookingColumnNumber = regAdminSeven.getBookingColumnNumber(), let bookingColumnType = regAdminSeven.getBookingColumnType(), let eq = regAdminSeven.eq {
                if bookingColumnNumber != "" && bookingColumnType != "" {
                    let url = "http://localhost:4000/api/adminSignup";
                    let dataToSend = ["businessName": businessName, "typeOfBusiness": typeOfBusiness, "email": email, "password": password, "address": street, "city": city, "state": state, "zip": zip, "phoneNumber": phone, "website": website, "satOpen": satOpen, "satClose": satClose, "sunOpen": sunOpen, "sunClose": sunClose, "monOpen": monOpen, "monClose": monClose, "tueOpen": tueOpen, "tueClose": tueClose, "wedOpen": wedOpen, "wedClose": wedClose, "thuOpen": thuOpen, "thuClose": thuClose, "friOpen": friOpen, "friClose": friClose, "bookingColumnNumber": bookingColumnNumber, "bookingColumnType": bookingColumnType, "eq": eq];
                    BasicCalls().register(urlString: url, dataToSend: dataToSend) { (token) in
                        if Utilities().setTokenInKeyChain(token: token, key: "adminToken") {
                            DispatchQueue.main.async {
                                let adminHome = AdminHomeController();
                                adminHome.modalTransitionStyle = .crossDissolve;
                                self.navigationController?.pushViewController(adminHome, animated: true);
                            }
                        }
                        else {
                            print("signup failed")
                        }
                    }
                }
                else {
                    let alert = Components().createActionAlert(title: "Please Fill In All Fields", message: "Please enter the item/area to be booked at your business and how many of these items/areas can be booked at your business.", buttonTitle: "Okay!", handler: nil);
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil);
                    }
                }
            }
            else {
                print("not good")
                print(regAdminSeven.getBookingColumnType())
                print(regAdminSeven.getBookingColumnNumber());
                print(regAdminSeven.eq)
            }
        }
        errorText.text = error;
    }
    
    
    // MARK: - SELECTORS
    
    @objc func questionHit() {
        let help = UINavigationController( rootViewController: HelpRegModal())
        help.modalTransitionStyle = .crossDissolve;
        help.modalPresentationStyle = .fullScreen;
        present(help, animated: true, completion: nil);
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true);
    }
    
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        configureUI();
        hkb();
    }
    
    // MARK: - HELPERS

    
    func configureUI() {
        regAdminOne.isHidden = false;
        regAdminTwo.isHidden = true;
        regAdminThree.isHidden = true;
        regAdminFour.isHidden = true;
        regAdminFive.isHidden = true;
        regAdminSix.isHidden = true;
        regAdminSeven.isHidden = true;
        
        // MARK: -ALWAYS HERE
        view.backgroundColor = .mainLav;
        
        view.addSubview(backButton);
        backButton.padLeft(from: view.leftAnchor, num: 10);
        backButton.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 5);
        
        view.addSubview(progressBar);
        progressBar.setWidth(width: view.frame.width / 1.5);
        progressBar.setHeight(height: 47);
        progressBar.padLeft(from: backButton.rightAnchor, num: 20);
        progressBar.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 5);
        
        // MARK: - REG ADMIN 1
        
        view.addSubview(regAdminOne);
        regAdminOne.setWidth(width: view.frame.width);
        regAdminOne.setHeight(height: view.frame.height / 1.8);
        regAdminOne.padTop(from: progressBar.bottomAnchor, num: 20)
        regAdminOne.centerTo(element: view.centerXAnchor);
        
        // MARK: - REG ADMIN 2
        
        view.addSubview(regAdminTwo);
        regAdminTwo.setWidth(width: view.frame.width);
        regAdminTwo.setHeight(height: view.frame.height / 1.6);
        regAdminTwo.padTop(from: progressBar.bottomAnchor, num: 20);
        regAdminTwo.centerTo(element: view.centerXAnchor);
        
        // MARK: - REG ADMIN 3
        
        view.addSubview(regAdminThree);
        regAdminThree.setWidth(width: view.frame.width);
        regAdminThree.setHeight(height: view.frame.height / 1.6);
        regAdminThree.padTop(from: progressBar.bottomAnchor, num: 20);
        regAdminThree.centerTo(element: view.centerXAnchor);
        
        view.addSubview(regAdminFour);
        regAdminFour.setWidth(width: view.frame.width);
        regAdminFour.setHeight(height: view.frame.height / 3);
        regAdminFour.padTop(from: progressBar.bottomAnchor, num: 20);
        regAdminFour.centerTo(element: view.centerXAnchor);
        
        view.addSubview(regAdminFive);
        regAdminFive.setWidth(width: view.frame.width);
        regAdminFive.setHeight(height: view.frame.height / 1.3);
        regAdminFive.padTop(from: progressBar.bottomAnchor, num: 20);
        regAdminFive.centerTo(element: view.centerXAnchor);
        
        view.addSubview(regAdminSix);
        regAdminSix.setWidth(width: view.frame.width);
        regAdminSix.padTop(from: progressBar.bottomAnchor, num: 8);
        regAdminSix.centerTo(element: view.centerXAnchor);
        
        view.addSubview(regAdminSeven);
        regAdminSeven.setWidth(width: view.frame.width);
        regAdminSeven.setHeight(height: view.frame.height / 1.3);
        regAdminSeven.padTop(from: progressBar.bottomAnchor, num: 20);
        regAdminSeven.centerTo(element: view.centerXAnchor);
        
        view.addSubview(continueButton);
        continueButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: view.frame.height / 12); 
        continueButton.centerTo(element: view.centerXAnchor);
        continueButton.setHeight(height: 50);
        continueButton.setWidth(width: 124);
        
        view.addSubview(questionButton);
        questionButton.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: view.frame.height / 12.2);
        questionButton.padLeft(from: view.leftAnchor, num: 20);
        
        
        view.addSubview(errorText);
        errorText.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 5);
        errorText.centerTo(element: view.centerXAnchor);
        errorText.setWidth(width: view.frame.width / 1.2);
        errorText.setHeight(height: 50);
        
        
    }
}
