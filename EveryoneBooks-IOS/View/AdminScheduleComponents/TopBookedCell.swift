//
//  TopBookedCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 9/19/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class TopBookedCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    var booked: Bool? {
         didSet {
             if booked! {
                 let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
                 addGestureRecognizer(tap);
                 backgroundColor = UIColor.init(red: 300, green: 0, blue: 0, alpha: 0.3);
                addSubview(topBorder);
                     topBorder.padTop(from: topAnchor, num: 0);
                     topBorder.centerTo(element: centerXAnchor);
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

    private let timeText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 18);
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
        addSubview(timeText);
        timeText.padTop(from: topAnchor, num: 4);
        timeText.centerTo(element: centerXAnchor);
    }
    
 
    
}
