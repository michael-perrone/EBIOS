//
//  RoomAreaColumn.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 9/17/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RoomAreaColumn: UICollectionViewCell {
    
    private let leftBorder = Components().createBorder(height: fullHeight - 200, width: 0.5, color: .black);
    private let rightBorder = Components().createBorder(height: fullHeight - 200, width: 0.5, color: .black);
    private let textBorder = Components().createBorder(height: 0.5, width: 200, color: .black);
    
    weak var bookingClickedDelegate: BookingClickedProtocol?
    
    private var date: String? {
        didSet {
            columnTableView.setDate(date: self.date!);
        }
    }
    
    private let roomText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.setHeight(height: 40);
        uitv.backgroundColor = .white;
        return uitv;
    }()
    
    private var bcn: String? {
        didSet {
            columnTableView.setBcn(bcn: self.bcn!);
        }
    }
    
    func setBcn(bcn: String) {
        self.bcn = bcn;
    }
    
    func getBcn() -> Int {
        return Int(self.bcn!)!
    }
    
    func setDate(date: String) {
        self.date = date;
    }
    
    func setColumnBookings(bookings: [Booking]) {
        columnTableView.setBookings(bookings: bookings);
    }
    
    func setRoomText(text: String) {
        roomText.text = text;
    }
    
    func setColumnTimeSlotNum(num: Int) {
        columnTableView.setTimeSlotNum(num: num);
    }
    
    func setColumnOpenTime(open: String) {
        columnTableView.setOpenTime(open: open);
    }
    
    func setColumnCloseTime(close: String) {
        columnTableView.setCloseTime(close: close)
    }
    
    private let columnTableView: ColumnTableView = {
        let ctv = ColumnTableView();
        return ctv;
    }()
    
    
    func configureCell() {
        columnTableView.bookingClickedDelegate = bookingClickedDelegate;
        backgroundColor = .white;
        addSubview(leftBorder);
        leftBorder.padLeft(from: leftAnchor, num: 0);
        leftBorder.padTop(from: topAnchor, num: 0);
        addSubview(rightBorder);
        rightBorder.padRight(from: rightAnchor, num: 0);
        rightBorder.padTop(from: topAnchor, num: 0);
        addSubview(roomText);
        roomText.padTop(from: topAnchor, num: fullHeight > 800 ? 50 : 30 );
        roomText.centerTo(element: centerXAnchor);
        addSubview(columnTableView);
        columnTableView.padTop(from: roomText.bottomAnchor, num: 10);
        columnTableView.padLeft(from: leftAnchor, num: 2);
        columnTableView.padRight(from: rightAnchor, num: 2);
        columnTableView.padBottom(from: safeAreaLayoutGuide.bottomAnchor, num: 20);
        columnTableView.setBookings(bookings: []);
        addSubview(textBorder);
        textBorder.padBottom(from: columnTableView.topAnchor, num: 0.5);
        textBorder.padRight(from: rightAnchor, num: 2);
        textBorder.padLeft(from: leftAnchor, num: 2);
    }
    
    
}
