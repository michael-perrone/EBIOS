//
//  CustomNumberPicker.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 9/21/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//
//
//  BookingItemPicker.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/30/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class CustomNumberPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource  {
  
   var selected = "1";
    
    var bcn: Int? {
        didSet {
            var i = 1;
            var toBeData: [String] = [];
            while i <= self.bcn! {
                toBeData.append(String(i));
                i = i + 1;
            }
            self.data = toBeData;
        }
    }

    var data: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadAllComponents();
            }
        }
    }
    
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
        return data.count;
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
             selected = data[row]
        
    }
      
    
    

}
