//
//  PayrollNumbers.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/16/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import Foundation


struct PayrollNumbers {
    var salaryNum: String;
    var hourlyNum: String;
    var productCommissionNum: String;
    var serviceCommissionNum: String;
    var employeeName: String;
    
    
    init(dic: [String: String]) {
        self.salaryNum = dic["salary"]!;
        self.hourlyNum = dic["hourlyEarned"]!;
        self.productCommissionNum = dic["productEarned"]!;
        self.serviceCommissionNum = dic["serviceEarned"]!;
        self.employeeName = dic["employeeName"]!;
    }
}
