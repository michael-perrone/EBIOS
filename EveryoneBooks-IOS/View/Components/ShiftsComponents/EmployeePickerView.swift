//
//  EmployeePickerView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/7/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var selectedEmployee: [String: String]?
    
    var employees: [[String: String]]? {
        didSet{
            if let employees  = employees {
                if employees.count > 0 {
                    self.selectedEmployee = employees[0]
                }
                DispatchQueue.main.async {
                    self.reloadAllComponents()
                }
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
        if let employees = employees {
            return employees.count
        }
        else {
            return 0;
            }
       }
          
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let employees = employees {
        if employees.count > 0 {
                return employees[row]["fullName"];
            }
           else {
                return "No";
            }
        } else {
            return "No"
        }
    }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let employees = employees {
            if employees.count > 0 {
                selectedEmployee = employees[row];
              
            }
        }
           
       }

}
