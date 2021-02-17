//
//  DayRow.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/27/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class DayRow: UIView {
    
    private var day = "";
    
    required init(dayName: String) {
        day = dayName;
        super.init(frame: CGRect.zero)
        configureView()
    }

   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dayText: UITextView = {
        let uitv = Components().createSimpleText(text: day);
        uitv.backgroundColor = .mainLav;
        uitv.textAlignment = .center;
        uitv.font = .systemFont(ofSize: 24);
        return uitv;
    }()
    
    let openPicker: TimeDrop = {
        let td = TimeDrop(openClose: "Open");
        return td;
    }()
    
    let closePicker: TimeDrop = {
        let td = TimeDrop(openClose: "Close");
        return td;
    }()
    
    func getOpen() -> String {
        return openPicker.selected;
    }
    
    func getClose() -> String {
        return closePicker.selected;
    }
    
    func configureView() {
        backgroundColor = .mainLav;
        
        addSubview(dayText);
        dayText.padTop(from: topAnchor, num: 20);
        dayText.padLeft(from: leftAnchor, num: 3);
        dayText.setWidth(width: 66);
        
        addSubview(openPicker);
        openPicker.padLeft(from: dayText.rightAnchor, num: 10);
        openPicker.padTop(from: topAnchor, num: 5);
        openPicker.setWidth(width: 140);
        openPicker.setHeight(height: 75);
        
        addSubview(closePicker);
        closePicker.padTop(from: topAnchor, num: 5);
        closePicker.padLeft(from: openPicker.rightAnchor, num: UIScreen.main.bounds.height * UIScreen.main.bounds.height / 40000 );
        closePicker.setWidth(width: 140);
        closePicker.setHeight(height: 75);
        
        setWidth(width: UIScreen.main.bounds.width);
        setHeight(height: 75);
        
    }
}
