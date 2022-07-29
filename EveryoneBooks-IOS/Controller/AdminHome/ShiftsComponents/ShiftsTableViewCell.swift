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
            let name = Utilities().slimString(stringToSlim: shift!.employeeName);
            shiftName.text = name;
            shiftTime.text = shift!.timeStart + "-" + shift!.timeEnd;
            guard let bct = bct else {
                return
            }
            if let bcn = shift!.bcn {
                bctAndNum.text = bct + ": " + bcn;
            }
            else {
                bctAndNum.text = bct + ": None"
            }
          
            if let breakStart = shift?.breakStart, let breakEnd = shift?.breakEnd {
                if breakStart != "" && breakEnd != "" {
                    breakText.text = "Break: " + breakStart + "-" + breakEnd;
                }
                else {
                    breakText.text = "No Break";
                }
            }
            else {
                breakText.text = "No Break";
            }
        }
    }
    
    var bct: String?;
    
    private let shiftName: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        uitv.backgroundColor = .mainLav;
        uitv.isSelectable = false;
        return uitv;
    }()
    
    private let shiftTime: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let bctAndNum: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        return uitv;
    }()
    
    private let breakText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        return uitv;
    }()
    
    func configure() {
        addSubview(shiftName);
        shiftName.padLeft(from: leftAnchor, num: 20);
        shiftName.padTop(from: topAnchor, num: 5);
        shiftName.setWidth(width: 190);
        addSubview(shiftTime);
        shiftTime.padRight(from: rightAnchor, num: 15);
        shiftTime.padTop(from: topAnchor, num: 5);
        backgroundColor = .mainLav;
        addSubview(bctAndNum);
        bctAndNum.padTop(from: shiftName.bottomAnchor, num: 0);
        bctAndNum.padLeft(from: shiftName.leftAnchor, num: 0);
        addSubview(breakText);
        breakText.padTop(from: shiftTime.bottomAnchor, num: 0);
        breakText.padRight(from: rightAnchor, num: 15);
    }
}
