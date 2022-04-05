//
//  MessageViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 8/22/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    weak var adminDelegate: MessageViewControllerProtocolForAdmin?
    
    weak var employeeDelegate: MessageViewControllerProtocolForEmployee?
    
    var message: String?;
    
    var header: String?
    
    var requestAnswerNoti: Notification?;
    
    private let fakeThing: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: 4);
        uiv.setWidth(width: 120);
        uiv.backgroundColor = .black;
        return uiv;
    }()
    
    private let messageView: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 19)
        uitv.setWidth(width: fullWidth - 18);
        uitv.backgroundColor = .mainLav;
        uitv.setHeight(height: 300);
        return uitv;
    }()
    
    private let headerView: UITextView = {
        let uitv = Components().createLargerText(text: "");
        uitv.setWidth(width: fullWidth - 8);
        uitv.setHeight(height: 60);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let dateView: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 13);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    
    private let yesButton: UIButton = {
        let uib = Components().createCoolButton(title: "Accept");
        return uib;
    }()
    
    private let noButton: UIButton = {
        let uib = Components().createCoolButton(title: "Deny");
        return uib;
    }()
    
    private let answeredYes: UIView = {
        let uiv = Components().createYesAnswer(answer: "Accepted");
        uiv.alpha = 0;
        return uiv;
    }()
    
    private let answeredNo: UIView = {
         let uiv = Components().createNoAnswer(answer: "Denied");
         uiv.alpha = 0;
         return uiv;
     }()

    
    @objc func acceptEmployeeRequest() {
        API().post(url: myURL + "notifications/employerAcceptedEmployee", headerToSend: Utilities().getAdminToken(), dataToSend: ["employeeId": requestAnswerNoti?.fromId, "notificationId": requestAnswerNoti?.id, "businessId": Utilities().decodeAdminToken()!["businessId"]]) { (res) in
            if (res["statusCode"] as! Int == 200) {
                self.adminDelegate?.answerHit();
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        self.yesButton.alpha = 0
                        self.noButton.alpha = 0;
                    }
                }
                let acceptedAlert = UIAlertController(title: "Success!", message: "You have successfully added " + self.requestAnswerNoti!.fromName! + " as an employee to your business.", preferredStyle: .alert)
                let acceptedAlertOk = UIAlertAction(title: "Cool!", style: .default, handler: nil);
                acceptedAlert.addAction(acceptedAlertOk);
                DispatchQueue.main.async {
                    self.present(acceptedAlert, animated: true, completion: nil);
                }
            }
        }
    }

    @objc func denyEmployeeRequest() {
        self.adminDelegate?.answerHit();
//        API().post(url: myURL + "notifications/employerDeniedEmployee", headerToSend: Utilities().getAdminToken(), dataToSend: ["notificationId": adminNoti?.id, "employeeId": adminNoti?.fromId]) { (res) in
//            if res["statusCode"] as! Int == 200 {
//

//                UIView.animate(withDuration: 0.5) {
//                    DispatchQueue.main.async {
//                        self.yesButton.alpha = 0;
//                        self.noButton.alpha = 0;
//                    }
//                }
//                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIView.AnimationOptions.transitionFlipFromTop, animations: {
//                    DispatchQueue.main.async {
//                        self.answeredNo.alpha = 1;
//                    }
//                }, completion: nil)
//            }
//        }
     }
    
    @objc func acceptEmployerRequest() {
        let data: [String: Any] = ["employeeId": Utilities().getEmployeeId(), "notificationId": requestAnswerNoti!.id!]
        API().post(url: myURL + "notifications/employeeClickedYesIos", dataToSend: data) { (res) in
            if res["statusCode"] as! Int == 200 {
                self.employeeDelegate?.answerHit();
                self.employeeDelegate?.alterTabs();
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.5) {
                        self.yesButton.alpha = 0
                        self.noButton.alpha = 0;
                    }
                }
            }
            let acceptedAlert = UIAlertController(title: "Success!", message: "You have successfully been added as an employee to " + self.requestAnswerNoti!.fromName! + ". Congratulations!", preferredStyle: .alert)
            let acceptedAlertOk = UIAlertAction(title: "Cool!", style: .default, handler: nil);
            acceptedAlert.addAction(acceptedAlertOk);
            DispatchQueue.main.async {
                self.present(acceptedAlert, animated: true, completion: nil);
            }
        }
    }
    
    @objc func denyEmployerRequest() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessageView();
       if requestAnswerNoti!.notificationType == "BRA" {
           employeeDelegate?.answerHit()
       }
    }
    
    
    func loadMessageView() {
        view.addSubview(dateView);
        if let noti = requestAnswerNoti {
            dateView.text = noti.date;
            if noti.notificationType! == "ESID" {
                view.addSubview(yesButton);
                yesButton.centerTo(element: view.centerXAnchor);
                yesButton.padBottom(from: view.bottomAnchor, num: 120);
                view.addSubview(noButton);
                noButton.centerTo(element: view.centerXAnchor);
                noButton.padTop(from: yesButton.bottomAnchor, num: 20);
                yesButton.addTarget(self, action: #selector(acceptEmployeeRequest), for: .touchUpInside);
                noButton.addTarget(self, action: #selector(denyEmployeeRequest), for: .touchUpInside);
                header = "Employee Join Request";
                message = noti.fromName! + " has requested that they be added as a current working employee to your business. Would you like to add " + noti.fromName! + "? If yes, be aware this employee will be able to be booked on your current schedule unless you go into your settings and specify otherwise.";
                view.addSubview(answeredYes);
                answeredYes.padBottom(from: view.bottomAnchor, num: 100);
                answeredYes.centerTo(element: view.centerXAnchor);
                view.addSubview(answeredNo)
                answeredNo.padBottom(from: view.bottomAnchor, num: 100);
                answeredNo.centerTo(element: view.centerXAnchor);
            }
            else if noti.notificationType == "BAE" { // business added employee
                header = "Employer Sent Request";
                message = noti.fromName! + " has used your unique id to add you as an employee to their business. If you accept this request, this employer will be able to add you to their shift schedule right away. Would you like to confirm youself as an employee?";
                view.addSubview(yesButton);
                yesButton.centerTo(element: view.centerXAnchor);
                yesButton.padBottom(from: view.bottomAnchor, num: 120);
                yesButton.addTarget(self, action: #selector(acceptEmployerRequest), for: .touchUpInside);
                view.addSubview(noButton);
                noButton.centerTo(element: view.centerXAnchor);
                noButton.padTop(from: yesButton.bottomAnchor, num: 20);
            }
            else if noti.notificationType == "EAR" {
                header = "Request Accepted";
                message = "You accepted this request from " + noti.fromName! + " to join there business as an employee! You will now be able to be added to their shift schedule.";
            }
            else if noti.notificationType == "ERY" || noti.notificationType == "ERYR" {
                header = "Employee Accepted";
                message = noti.fromName! + " has accepted your request to join your business as an employee. You can now add them to your shift schedule!";
            }
            else if noti.notificationType == "BAR" || noti.notificationType == "BARR" {
                header = "Employer Accepted";
                message = noti.fromName! + " has accepted your request to join their business as an employee. You can now be added to their shift schedule!";
            }
            else if noti.notificationType == "YAE" {
                header = "Employee Accepted";
                message = "Your business accepted a request from " + noti.fromName! + " to join your business as an employee. They can now be added to your shift schedule.";
            }
            // COME BACK AND ADD MORE DATE PLX
            else if noti.notificationType == "AAUR" {
                header = "Booking Request Accepted";
                message = "A booking request from  " + noti.fromName! + " has been accepted. This booking is now in your schedule.";
            }
            else if noti.notificationType == "ADUR" {
                header = "Booking Request Denied";
                message = "You have denied a booking request from " + noti.fromName! + "."
            }
            else if noti.notificationType == "ELB" || noti.notificationType == "ELBR" {
                header = "Employee Left Business";
                message = noti.fromName! + " has left your business. All bookings that " + noti.fromName! + " was scheduled for have been deleted.";
            }
            else if noti.notificationType == "BBY" || noti.notificationType == "BBYR" {
                header = "Business Added Booking"
                message = noti.fromName! + " has booked you at their business. You can find the information for this booking on your bookings page. Enjoy!";
            }
            else if noti.notificationType == "YURA" || noti.notificationType == "YURAR" {
                header = "User Request Accepted"
                message = "Your user request for a booking at " + noti.fromName! + " has been accepted. You can find the information for this booking on your bookings page. Enjoy!"
            }
            else if noti.notificationType == "UATG" || noti.notificationType == "UATGR" {
                header = "Group Addition"
                message = "You have been added as a member of a group on " + noti.potentialDate! + " at " + noti.fromName! + " at the time of " + noti.potentialStartTime! + ". You can find this information on your bookings page."
            }
        }
        
        dateView.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 24);
        dateView.padRight(from: view.rightAnchor, num: 5);
        headerView.text = header;
        view.addSubview(headerView);
        headerView.padLeft(from: view.leftAnchor, num: 8);
        headerView.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 55);
        messageView.text = message;
        view.addSubview(messageView);
        messageView.centerTo(element: view.centerXAnchor);
        messageView.padTop(from: headerView.bottomAnchor, num: 27);
        view.backgroundColor = .mainLav;
        view.addSubview(fakeThing);
        fakeThing.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 14);
        fakeThing.centerTo(element: view.centerXAnchor);
        
        
        
    }
    
}
