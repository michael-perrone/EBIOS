//
//  OneCellBooked.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 5/14/21.
//  Copyright © 2021 Michael Perrone. All rights reserved.
//

import UIKit

class OneCellBooked: UITableViewCell {
    var booked: Bool? {
         didSet {
             if booked! {
                let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
                addGestureRecognizer(tap);
                tap.numberOfTapsRequired = 2;
                backgroundColor = UIColor.init(red: 300, green: 0, blue: 0, alpha: 0.3);
                addSubview(topBorder);
                topBorder.padTop(from: topAnchor, num: 0);
                topBorder.centerTo(element: centerXAnchor);
                addSubview(bottomBorder);
                bottomBorder.padTop(from: bottomAnchor, num: 0);
                bottomBorder.centerTo(element: centerXAnchor);
             }
         }
     }
    
    private var time: String? {
        didSet {
            timeText.text = self.time;
        }
    }
    
    weak var delegate: GetBookingInfo?;
    
    private let topBorder = Components().createBorder(height: 0.5, width: fullWidth - 20, color: .black);
    private let bottomBorder = Components().createBorder(height: 0.5, width: fullWidth - 20, color: .black);

    private let timeText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 16);
        uitv.backgroundColor = UIColor.init(red: 300, green: 0, blue: 0, alpha: 0.011);
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
        delegate?.getBookingInfo(time: self.time!)
    }
    
    func configureCell() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
        timeText.addGestureRecognizer(tap);
        tap.numberOfTapsRequired = 2;
        addSubview(timeText);
        timeText.padTop(from: topAnchor, num: 4);
        timeText.centerTo(element: centerXAnchor);
    }
}
