//
//  Break.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 3/27/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

struct Break {
    let time: String?;
    let bcn: String?;
    
    init(dictionary: [String: String]) {
        self.time = dictionary["time"];
        self.bcn = dictionary["bcn"];
    }
}
