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
            // Employee Sent ID
            if noti.notificationType == "ESID" {
                notiMessage.text = noti.fromName! + " has asked to be added as an employee."
            }
            // Business Added Employee
            else if noti.notificationType == "BAE" {
                notiMessage.text = noti.fromName! + " has added you as an employee to their business."
            }
            // Business Accepted Request
            else if noti.notificationType == "BAR" {
                notiMessage.text = noti.fromName! + " has accepted your request to join their business as an employee."
            }
            // Employee Responded Yes
            else if noti.notificationType == "ERY" {
                notiMessage.text = noti.fromName! + " has accepted your request to join your business as an employee."
            }
            // Employee Left Business
            else if noti.notificationType == "ELB" {
                notiMessage.text = noti.fromName! + " has left your business as an employee."
            }
            // Business Removed Employee
            else if noti.notificationType == "BRE" {
                notiMessage.text = noti.fromName! + " has removed you as an employee from their business."
            }
            else if noti.notificationType == "YURA" {
                notiMessage.text = noti.fromName! + " has accepted your booking request."
            }
            else if noti.notificationType == "BBY" {
                notiMessage.text = noti.fromName! + " has booked you at their business. Check your bookings for details.";
            }
            else if noti.notificationType == "UATG" {
                notiMessage.text = noti.fromName! + " has added you as a member of a group."
            }
            addSubview(closeEnv);
            closeEnv.padLeft(from: leftAnchor, num: 10);
            closeEnv.padTop(from: topAnchor, num: 33);
        }
    }
}
