//
//  BookingItemPicker.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/30/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class BookingItemPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource  {
  
   var selected = "";

   var selectableData = ["Num", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50"]
    
    override init(frame: CGRect) {
        super.init(frame:frame);
        self.delegate = self;
        self.dataSource = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1;
    }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectableData.count;
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectableData[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
             selected = selectableData[row]
        
    }
      
    
    

}
