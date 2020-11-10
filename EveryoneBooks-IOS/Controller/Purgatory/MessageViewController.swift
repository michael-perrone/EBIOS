//
//  MessageViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 8/22/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    weak var delegate: MessageViewControllerProtocol?
    
    weak var otherDelegate: MessageViewControllerProtocolForEmployee?
    
    var message: String?;
    
    var header: String?
    
    var requestAnswerNoti: RequestAnswerNotification?;
    
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
                self.delegate?.answerHit();
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
        print("hello");
        self.delegate?.answerHit();
        print(self.delegate!)
//        API().post(url: myURL + "notifications/employerDeniedEmployee", headerToSend: Utilities().getAdminToken(), dataToSend: ["notificationId": adminNoti?.id, "employeeId": adminNoti?.fromId]) { (res) in
//            if res["statusCode"] as! Int == 200 {
//
//                print("even better")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessageView();
        if requestAnswerNoti!.notificationType == "ERA" && requestAnswerNoti!.answer == nil {
            otherDelegate?.read(notiId: requestAnswerNoti!.id!)
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
                if noti.answer == nil {
                    message = noti.fromName! + " has requested that they be added as a current working employee to your business. Would you like to add " + noti.fromName! + "? If yes, be aware this employee will be able to be booked on your current schedule unless you go into your settings and specify otherwise.";
                    view.addSubview(answeredYes);
                    answeredYes.padBottom(from: view.bottomAnchor, num: 100);
                    answeredYes.centerTo(element: view.centerXAnchor);
                    view.addSubview(answeredNo)
                    answeredNo.padBottom(from: view.bottomAnchor, num: 100);
                    answeredNo.centerTo(element: view.centerXAnchor);
                }
                else {
                    if noti.answer == true {
                        message = "You accepted " + noti.fromName! + " as a new employe to your business. If this was a mistake, you can remove them in your edit business menu."
                    }
                    if noti.answer == false {
                        message = "You denied " + noti.fromName! + " from becoming an employee at your business. If this was a mistake, you can add them in your edit business menu or have them send another request."
                    }
                    yesButton.isHidden = true;
                    noButton.isHidden = true;
                }
            }
            else if noti.notificationType == "ERA" {
                header = "Employer Accepted"
                message = noti.fromName! + " has accepted your request to join there business as an employee!"
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
