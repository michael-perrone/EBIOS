//
//  Shift.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/5/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation


struct Shift {
    var timeStart: String;
    var timeEnd: String;
    var employeeName: String;
    var id: String;
    var date: String;
    var breakStart: String;
    var breakEnd: String;
    var bcn: String?
    
    init(dic: [String: String]) {
        self.timeStart = dic["timeStart"]!;
        self.timeEnd = dic["timeEnd"]!;
        self.employeeName = dic["employeeName"]!;
        self.id = dic["_id"]!;
        self.bcn = dic["bookingColumnNumber"] as? String;
        if let date = dic["shiftDate"] as? String {
            self.date = date;
        }
        else {
            date = "";
        }
        if let breakStart = dic["breakStart"] as? String {
            self.breakStart = breakStart;
        }
        else {
            breakStart = "";
        }
        if let breakEnd = dic["breakEnd"] as? String {
            self.breakEnd = breakEnd;
        }
        else {
            breakEnd = "";
        }
        
    }
    
    
}
