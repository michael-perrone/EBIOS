//
//  EmployeePayroll.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/12/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import Foundation

struct EmployeePayroll {
    var id: String;
    var isHourlyWage: Bool?;
    var isSalary: Bool?;
    var isCommissionServices: Bool?;
    var isComissionProducts: Bool?;
    var productCommissionRate: String?;
    var serviceCommissionRate: String?;
    var salary: String?;
    var hourlyWage: String?;
    var emName: String?;
    
    init(dic: [String: Any]) {
        self.id = dic["_id"] as! String;
        self.isHourlyWage = dic["paidHourly"] as? Bool;
        self.isSalary = dic["paidSalary"] as? Bool;
        self.isCommissionServices = dic["serviceCommission"] as? Bool;
        self.isComissionProducts = dic["productCommission"] as? Bool;
        self.productCommissionRate = dic["pcp"] as? String;
        self.serviceCommissionRate = dic["scp"] as? String;
        self.salary = dic["salary"] as? String;
        self.hourlyWage = dic["hourly"] as? String;
        self.emName = dic["employeeName"] as? String;
    }
}
