//
//  TimePicker.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/19/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class TimePicker: UIPickerView,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let choices = ["Service Duration", "15 Minutes", "30 Minutes", "45 Minutes", "1 Hour", "1 Hour 15 Minutes", "1 Hour 30 Minutes", "1 Hour 45 Minutes", "2 Hours", "2 Hours 15 Minutes", "2 Hours 30 Minutes", "2 Hours 45 Minutes", "3 Hours", "3 Hours 15 Minutes", "3 Hours 30 Minutes", "3 Hours 45 Minutes", "4 Hours", "4 Hours 15 Minutes", "4 Hours 30 Minutes", "4 Hours 45 Minutes", "5 Hours"]
    
    private var timeSelected = "";
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        dataSource = self;
        delegate = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTimeSelected() -> String {
        return self.timeSelected;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1;
       }
          
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return choices.count;
       }
          
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
               return choices[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                timeSelected = choices[row]
           
       }
    
}
