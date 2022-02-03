//
//  UserBookedRequestNotificationCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 1/11/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class UserBookedNotificationCell: NotificationCell {
    
    var services: [Service]?
    
    func layoutCell() {
        if let noti = noti {
            addSubview(notiMessage);
            notiMessage.isUserInteractionEnabled = true;
            notiMessage.padTop(from: topAnchor, num: 26);
            notiMessage.padLeft(from: leftAnchor, num: 55);
            notiMessage.setWidth(width: UIScreen.main.bounds.width - 55);
            notiMessage.setHeight(height: 65);
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
