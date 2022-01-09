//
//  MyDatePicker.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/5/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class MyDatePicker: UIDatePicker {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:0, y: 0, width: 300, height: 200));
        configureView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        datePickerMode = .date;
    }
}
