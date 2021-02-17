//
//  Booking.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/7/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation

struct Booking {
    let time: String?
    let employeeBooked: String?
    let serviceTypes: [String]?;
    let serviceNames: [String]?;
    let businessId: String?
    let date: String?
    let cost: String?
    let customerId: String?
    let cName: String?;
    let bcn: String?;
    let bct: String?;
    let businessName: String?;
    let employeeName: String?
    let id: String?;
    
    init(dic: [String: Any]) {
        self.employeeName = dic["employeeName"] as? String;
        self.time = dic["time"] as? String;
        self.employeeBooked = dic["employeeBooked"] as? String;
        self.businessId = dic["businessId"] as? String;
        self.serviceTypes = dic["serviceType"] as? [String];
        self.serviceNames  = dic["serviceNames"] as? [String];
        self.date = dic["date"] as? String;
        self.cost = dic["cost"] as? String;
        self.customerId = dic["customer"] as? String;
        self.cName = dic["cName"] as? String;
        self.bcn = dic["bcn"] as? String;
        self.bct = dic["bct"] as? String;
        self.businessName = dic["business"] as? String;
        self.id = dic["_id"] as? String;
    }
}

