//
//  AdminNotificationCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 8/24/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RequestAnswerNotificationCell: NotificationCell {
    
    var delegate: RequestAnswerCell?
    
    weak var otherDelegate: MessageViewControllerProtocolForEmployee?
    
    @objc func hit(_ sender: UITapGestureRecognizer? = nil) {
           delegate?.tapped(noti: noti!)
    }
    
    func layoutCell() {
        if let noti = noti {
            let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
            notiMessage.addGestureRecognizer(tap);
            addSubview(notiMessage);
            notiMessage.addGestureRecognizer(tap);
            notiMessage.isUserInteractionEnabled = true;
            notiMessage.padTop(from: topAnchor, num: 26);
            notiMessage.padLeft(from: leftAnchor, num: 55);
            notiMessage.setWidth(width: UIScreen.main.bounds.width - 55);
            notiMessage.setHeight(height: 65);
            // Employee Request Accepted
            if noti.notificationType == "ERA" {
                notiMessage.text = noti.fromName! + " has accepted your employment request.";
            }
            
            
            addSubview(dateOfNoti);
            dateOfNoti.padTop(from: topAnchor, num: 2);
            dateOfNoti.padRight(from: rightAnchor, num: 20);
            dateOfNoti.setHeight(height: 24);
            dateOfNoti.text = noti.date!;
            backgroundColor = .mainLav;
            
            let border = UIView();
            border.setHeight(height: 0.6);
            border.setWidth(width: UIScreen.main.bounds.width);
            border.backgroundColor = .darkGray;
            addSubview(border);
            border.centerTo(element: centerXAnchor);
            border.padBottom(from: bottomAnchor, num: 0);
        }
    }
}
