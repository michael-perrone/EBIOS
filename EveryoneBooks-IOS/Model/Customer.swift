//
//  Customer.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/29/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

struct Customer {
    let name: String?;
    let phone: String?
    let id: String?
    
    init(dic: [String: Any]) {
        self.name = dic["fullName"] as? String;
        self.phone = dic["phoneNumber"] as? String;
        self.id = dic["_id"] as? String;
    }
}
