//
//  BottomBookedCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 9/19/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class BottomBookedCell: UITableViewCell {
    
    var booked = false {
         didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
             if booked {
                 addGestureRecognizer(tap);
                addSubview(bottomBorder);
                bottomBorder.padBottom(from: bottomAnchor, num: 0);
                bottomBorder.centerTo(element: centerXAnchor);
                    backgroundColor = UIColor.init(red: 300, green: 0, blue: 0, alpha: 0.3);
             } else {
                removeGestureRecognizer(tap);
                addSubview(bottomBorder);
                bottomBorder.padBottom(from: bottomAnchor, num: 0);
                bottomBorder.centerTo(element: centerXAnchor);
                backgroundColor = .literGray;
            }
         }
     }
    
  

    
    private var time: String? {
        didSet {
            timeText.text = self.time;
        }
    }
    
    weak var delegate: GetBookingInfo?;
    
    private let bottomBorder = Components().createBorder(height: 0.5, width: fullWidth - 20, color: .black);

    private let timeText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 18);
        uitv.backgroundColor = UIColor.init(red: 300, green: 0, blue: 0, alpha: 0.0011);
        return uitv;
    }()
    
    func setTime(time: String) {
        self.time = time;
    }
    
    func getTime() -> String{
        guard let time = time else {return ""};
        return time;
    }
    
    @objc func hit(_ sender: UITapGestureRecognizer? = nil) {
        let wrongTimeNum: Int = Utilities.stit[self.time!]!;
        let rightTime = Utilities.itst[wrongTimeNum - 1]!;
        delegate?.getBookingInfo(time: rightTime);
    }
    
    func configureCell() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
        timeText.addGestureRecognizer(tap);
        addSubview(timeText);
        timeText.padTop(from: topAnchor, num: 4);
        timeText.centerTo(element: centerXAnchor);
      
    }
}

