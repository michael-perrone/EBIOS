//
//  TimeDrop.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/25/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit
import Foundation

class TimeDrop: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selected = "";
    var openClose = "";
    
    var timesData = ["12:00 AM", "12:30 AM", "1:00 AM", "1:30 AM", "2:00 AM", "2:30 AM", "3:00 AM", "3:30 AM", "4:00 AM", "4:30 AM", "5:00 AM", "5:30 AM", "6:00 AM", "6:30 AM", "7:00 AM", "7:30 AM", "8:00 AM", "8:30 AM", "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM", "4:00 PM", "4:30 PM", "5:00 PM", "5:30 PM", "6:00 PM", "6:30 PM", "7:00 PM", "7:30 PM", "8:00 PM", "8:30 PM", "9:00 PM", "9:30 PM", "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM"]
    
    init(openClose: String?) {
        if let openCloseUnwrapped = openClose {
            self.openClose = openCloseUnwrapped;
            super.init(frame: CGRect());
            timesData.insert(openCloseUnwrapped, at: 0);
            timesData.insert("Closed", at: 1);
            self.delegate = self;
            self.dataSource = self;
            self.selected = openCloseUnwrapped;
        }
        else {
            super.init(frame: CGRect());
            self.delegate = self;
            self.dataSource = self;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1;
    }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timesData.count;
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return timesData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if timesData[row] == "Open" || timesData[row] == "Close" {
            selected = "";
        }
        else {
            selected = timesData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = timesData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]);
        return myTitle
    }
}
