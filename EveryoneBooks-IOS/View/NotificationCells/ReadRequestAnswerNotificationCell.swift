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
            // You denied Employee
            if noti.notificationType == "YDE" {
                notiMessage.text = noti.fromName! + " was denied from becoming an employee."
            }
            // You accepted request read // formerly EAR
            else if noti.notificationType == "YARR" {
                notiMessage.text = "You accepted an employment request from " + noti.fromName!;
            }
            // Employee Responded Yes Read
            else if noti.notificationType == "ERYR" {
                notiMessage.text = noti.fromName! + " has accepted your request to join your business."
            }
            // Business Accepted Request Read
            else if noti.notificationType == "BARR" {
                notiMessage.text = noti.fromName! + " has accepted your request to join their business as an employee."
            }
            // You Accepted Employee
            else if noti.notificationType == "YAE" {
                notiMessage.text = "You have added " + noti.fromName! + " as an employee of your bussiness";
            }
            // Admin Accepted User Request
            else if noti.notificationType == "AAUR" {
                notiMessage.text = "This booking request from " + noti.fromName! + " was accepted.";
            }
            // Admin Denied User Request
            else if noti.notificationType == "ADUR" {
                notiMessage.text = "This booking request from " + noti.fromName! + " was denied";
            }
        }
        addSubview(openEnv);
        openEnv.padLeft(from: leftAnchor, num: 10);
        openEnv.padTop(from: topAnchor, num: 33);
    }
}

