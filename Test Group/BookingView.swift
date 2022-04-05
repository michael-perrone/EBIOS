//
//  BookingView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 1/6/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class BookingView: UIView {
    
    var time: String?
    
    var bookingClickedDelegate: BookingClickedProtocol?;
    
    var heightNumber: Int;
    
    
    var booking: Booking? {
        didSet {
            self.reloadInputViews();
        }
    }
    
    func setBeginningTime(time: String) {
        beginningTime.text = time;
    }
    
    func setEndTime(time: String) {
        endTime.text = time;
    }
    
    private let topBorder = Components().createBorder(height: 2, width: 180, color: .black);
    
    @objc func hit() {
        bookingClickedDelegate?.viewBookingInfo(booking: booking!);
    }
   
    // weak var bookingClickedDelegate: ;
    
    init(heightNumber: Int) {
        self.heightNumber = heightNumber;
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.init(red: 300, green: 0, blue: 0, alpha: 0.3);
        setWidth(width: 180);
        let topBorder = Components().createBorder(height: 0.8, width: 180, color: .black);
        addSubview(topBorder);
        topBorder.padTop(from: topAnchor, num: 0);
        let bottomBorder = Components().createBorder(height: 0.8, width: 180, color: .black);
        addSubview(bottomBorder);
        bottomBorder.padBottom(from: bottomAnchor, num: 0);
        let tap = UITapGestureRecognizer(target: self, action: #selector(hit));
        tap.numberOfTapsRequired = 2;
        addGestureRecognizer(tap);
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let beginningTime: UITextView = {
        let uitv = Components().createSimpleText(text: "", color: .literGray);
        uitv.font = .boldSystemFont(ofSize: 18);
        uitv.backgroundColor = .clear;
        uitv.isUserInteractionEnabled = false;
        return uitv;
    }()
    
    private let endTime: UITextView = {
        let uitv = Components().createSimpleText(text: "", color: .literGray);
        uitv.backgroundColor = .clear;
        uitv.font = .boldSystemFont(ofSize: 18);
        uitv.isUserInteractionEnabled = false;
        return uitv;
    }()
    
    private let dash: UITextView = {
        let uitv = Components().createSimpleText(text: "-");
        uitv.backgroundColor = .clear;
        uitv.font = .boldSystemFont(ofSize: 14);
        uitv.isUserInteractionEnabled = false;
        return uitv;
    }()
    
    func configureView() {
        if let _ = booking {
            addSubview(beginningTime);
            addSubview(endTime);
            addSubview(dash);
            if heightNumber < 6 {
                
                if heightNumber < 3 {
                    if heightNumber == 2 {
                        beginningTime.font = .boldSystemFont(ofSize: 16);
                        endTime.font = .boldSystemFont(ofSize: 16);
                        beginningTime.padTop(from: topAnchor, num: 0);
                        beginningTime.padLeft(from: leftAnchor, num: 5)
                        dash.padTop(from: beginningTime.topAnchor, num: 0);
                    }
                    else {
                        beginningTime.font = .boldSystemFont(ofSize: 12);
                        endTime.font = .boldSystemFont(ofSize: 12);
                        beginningTime.padTop(from: topAnchor, num: -7);
                        beginningTime.padLeft(from: leftAnchor, num: 20)
                        dash.padTop(from: beginningTime.topAnchor, num: -3);
                    }
                    dash.padLeft(from: beginningTime.rightAnchor, num: 0);
                    endTime.padTop(from: beginningTime.topAnchor, num: 0);
                    endTime.padLeft(from: dash.rightAnchor, num: 0);
                    return;
                }
                beginningTime.font = .boldSystemFont(ofSize: 16);
                endTime.font = .boldSystemFont(ofSize: 16);
                beginningTime.padTop(from: topAnchor, num: 8);
                beginningTime.padLeft(from: leftAnchor, num: 3)
                addSubview(dash);
                dash.padTop(from: topAnchor, num: 8);
                dash.padLeft(from: beginningTime.rightAnchor, num: 0);
                endTime.padTop(from: beginningTime.topAnchor, num: 0);
                endTime.padLeft(from: dash.rightAnchor, num: 0)
            }
            else {
                beginningTime.padTop(from: topAnchor, num: 3);
                beginningTime.centerTo(element: centerXAnchor);
                endTime.padBottom(from: bottomAnchor, num: 3);
                endTime.centerTo(element: centerXAnchor);
                
            }
        }
    }
}
