//
//  GenericDropDown.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/17/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class GenericDropDown: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var data: [String] = [] {
        didSet {
            if data.count > 0 {
                selectedItem = data[0];
                DispatchQueue.main.async {
                    self.selectRow(0, inComponent: 0, animated: true)
                }
            }
            DispatchQueue.main.async {
                self.reloadAllComponents()
            }
          
        }
    }
    
    var selectedItem: String?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        dataSource = self;
        delegate = self;
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
        if data.count > 0 {
            return data[row];
        }
        else {
            return "Not Good"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if data.count > 0 {
            self.selectedItem = data[row];
        }
    }
    
    func configureView() {
        setHeight(height: 90);
    }
    
    
}
