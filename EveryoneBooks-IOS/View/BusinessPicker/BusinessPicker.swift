//
//  BusinessPicker.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/25/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class BusinessPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selected: String = "Business Type";
  
    let typesOfBusinesses = ["Business Type","Wax Center", "Beauty Center", "Fitness Center", "Medical Office", "Hair Salon", "Tanning Salon", "Barber Shop", "Tattoo Studio", "Tennis Club", "Other"];

    override init(frame: CGRect) {
        self.selected = "";
        super.init(frame: frame);
        
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
        return typesOfBusinesses.count;
      }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesOfBusinesses[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if typesOfBusinesses[row] == "Business Type" {
            self.selected = "";
            
        }
        else {
            self.selected = typesOfBusinesses[row];
        }
        
    }
      
}
