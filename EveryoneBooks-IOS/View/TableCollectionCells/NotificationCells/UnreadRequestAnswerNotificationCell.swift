//
//  UnreadAdminNotificationCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 8/24/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class UnreadRequestAnswerNotificationCell: RequestAnswerNotificationCell {
    
    func layoutUnreadCell() {
        if let noti = noti {
            if noti.notificationType == "ESID" {
                notiMessage.text = noti.fromName! + " has asked to be added as an employee."
            }

            else if noti.notificationType == "BAE" {
                notiMessage.text = noti.fromName! + " has added you as an employee to their business."
            }
            
            else if noti.notificationType == "BAR" {
                notiMessage.text = noti.fromName! + " has accepted your request to join their business as an employee."
            }
            
            else if noti.notificationType == "ERY" {
                notiMessage.text = noti.fromName! + " has accepted your request to join your business as an employee."
            }
            
            else if noti.notificationType == "ELB" {
                notiMessage.text = noti.fromName! + " has left your business as an employee."
            }
            
            else if noti.notificationType == "BRE" {
                notiMessage.text = noti.fromName! + " has removed you as an employee from their business."
            }
            addSubview(closeEnv);
            closeEnv.padLeft(from: leftAnchor, num: 10);
            closeEnv.padTop(from: topAnchor, num: 33);
        }
    }
}
