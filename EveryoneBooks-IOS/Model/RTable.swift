//
//  RTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/4/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import CoreGraphics


struct RTable {
    let x: CGFloat;
    let y: CGFloat;
    let hor: Bool;
    let num: Int;
    
    init(dic: [String: Any]) {
        self.x = dic["x"] as! CGFloat;
        self.y = dic["y"] as! CGFloat;
        self.hor = dic["hor"] as! Bool;
        self.num = dic["num"] as! Int;
    }
}
