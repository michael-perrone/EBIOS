//
//  Friend.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/8/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import Foundation

struct Friend {
    var userName: String;
    var phone: String;
    var name: String;
    var id: String;
    
    init(dic: [String: String]) {
        self.userName = dic["userName"]!;
        self.phone = dic["phone"]!;
        self.name = dic["name"]!;
        self.id = dic["id"]!;
    }
}
