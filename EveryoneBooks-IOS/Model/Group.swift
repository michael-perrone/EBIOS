//
//  Group.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/21/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import Foundation

struct Group {
    let customers: [Customer]?;
    let price: String?;
    let bcn: String?;
    let time: String?;
    let employeeBooked: String?;
    let type: String?;
    let businessId: String?
    let date: String?;
    let bct: String?;
    let businessName: String?;
    let employeeName: String?;
    let id: String?;
    let customerNames: [String]?;
    
    
    init(dic: [String: Any]) {
        self.customers = dic["customers"] as? [Customer];
        self.price = dic["price"] as? String;
        self.bcn = dic["bcn"] as? String;
        self.time = dic["time"] as? String;
        self.employeeBooked = dic["employeeBooked"] as? String;
        self.type = dic["type"] as? String;
        self.businessId = dic["businessId"] as? String;
        self.date = dic["date"] as? String;
        self.bct = dic["bct"] as? String;
        self.businessName = dic["businessName"] as? String;
        self.employeeName = dic["employeeName"] as? String;
        self.id = dic["_id"] as? String;
        self.customerNames = dic["customerNames"] as? [String];
    }
    
}
