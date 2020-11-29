//
//  Business.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/6/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation

struct Business {
    let street: String?;
    let city: String?;
    let state: String?;
    let zip: String?;
    let typeOfBusiness: String?;
    let nameOfBusiness: String?;
    let id: String?;
    let bookingColumnNumber: String?;
    let bookingColumnType: String?;
    let website: String?
    let phone: String?
    let schedule: Schedule?
    
    init(dic: [String:Any]) {
        self.street = dic["address"] as? String;
        self.city = dic["city"] as? String;
        self.state = dic["state"] as? String;
        self.zip = dic["zip"] as? String;
        self.typeOfBusiness = dic["typeOfBusiness"] as? String;
        self.nameOfBusiness = dic["businessName"] as? String;
        self.id = dic["_id"] as? String;
        self.bookingColumnType = dic["bookingColumnType"] as? String;
        self.bookingColumnNumber = dic["bookingColumnNumber"] as? String;
        self.website = dic["website"] as? String;
        self.phone = dic["phoneNumber"] as? String;
        if let schedule =  dic["schedule"] as? [[String: String]] {
            self.schedule = Schedule(dic: schedule);
        }
        else {
            self.schedule = nil;
        }
        
    }
}
