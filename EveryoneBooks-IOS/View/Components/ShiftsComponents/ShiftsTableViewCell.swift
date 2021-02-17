//
//  ShiftsTableViewCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/12/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class ShiftsTableViewCell: UITableViewCell {
    
    var shift: Shift? {
        didSet {
            if shift!.employeeName.count > 22 {
                var name = shift!.employeeName[0..<19];
                name+="...";
                shiftName.text = name;
            }
            else {
                shiftName.text = shift!.employeeName;
            }
            shiftTime.text = shift!.timeStart + "-" + shift!.timeEnd;
        }
    }
    
    private let shiftName: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let shiftTime: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
      
    

    func configure() {
        addSubview(shiftName);
        shiftName.padLeft(from: leftAnchor, num: 20);
        shiftName.padTop(from: topAnchor, num: 5);
        shiftName.setWidth(width: 190);
        addSubview(shiftTime);
        shiftTime.padLeft(from: shiftName.rightAnchor, num: 25);
        shiftTime.padTop(from: topAnchor, num: 5);
        backgroundColor = .mainLav;
    }
}
