//
//  BookedCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 9/19/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//
import UIKit

class BookedCell: UITableViewCell {
    
    var booked: Bool? {
        didSet {
            if booked! {
                let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
                tap.numberOfTapsRequired = 2;
                addGestureRecognizer(tap);
                backgroundColor = UIColor.init(red: 300, green: 0, blue: 0, alpha: 0.3);
            }
        }
    }
    
    private var time: String?;
    
    func setTime(time: String) {
        self.time = time;
    }
    
    func getTime() -> String {
        guard let time = time else {return ""};
        return time;
    }
    
    weak var delegate: GetBookingInfo?;
    
    @objc func hit(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.getBookingInfo(time: self.time!)
    }
    
}
