//
//  ReadAdminNotificationCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 8/24/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class ReadRequestAnswerNotificationCell: RequestAnswerNotificationCell {
    
    func layoutReadCell() {
        if let noti = noti {
            if noti.notificationType == "YAE" {
                notiMessage.text = noti.fromName! + " has been added as an employee."
            }
            else if noti.notificationType == "YDE" {
                notiMessage.text = noti.fromName! + " was denied from becoming an employee."
            }
            else if noti.notificationType == "EAR" {
                notiMessage.text = "You accepted an employment request from " + noti.fromName!;
            }
            else if noti.notificationType == "ERYR" {
                notiMessage.text = noti.fromName! + " has accepted your request to join your business."
            }
            else if noti.notificationType == "BARR" {
                notiMessage.text = noti.fromName! + " has accepted your request to join their business as an employee."
            }
            else if noti.notificationType == "YAE" {
                notiMessage.text = "You have added " + noti.fromName! + " as a employee of your bussiness";
            }
        }
        addSubview(openEnv);
        openEnv.padLeft(from: leftAnchor, num: 10);
        openEnv.padTop(from: topAnchor, num: 33);
    }
}

