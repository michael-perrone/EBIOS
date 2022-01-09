//
//  ColumnScrollView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 1/5/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

// DONT FORGET TO TRY TO ITERATE OVER THE BOOKINGS IN EACH COLUMN WITH A FOR LOOP EACH TIME YOU REUSE THE CELL USING A HELPER FUNCTION BELOW WHICH MAY HELP YOU GET THE NEW CORRECT BOOKINGS EVERYTIME U REUSE A CELL HOWEVER THE OPERATION DOES SEEM EXPENSIVE

import UIKit

class ColumnScrollView: UIScrollView, UIScrollViewDelegate {
    
    
    var bookingClickedDelegate: BookingClickedProtocol?;
    
    var bcn: String?
    
    var bookings: [Booking]? {
        didSet {
            var bookingsViews = 0;
            for subview in subviews {
                if subview is BookingView {
                  bookingsViews = bookingsViews + 1;
                }
            }
            print(bookingsViews)
            if let bookings = bookings {
            if bookingsViews != bookings.count  {
                for booking in bookings {
                    let timeArray = booking.time?.components(separatedBy: "-");
                    let heightNum = Utilities.heightGetterNum[timeArray![1]]! - Utilities.heightGetterNum[timeArray![0]]!;
                    let bookingView = BookingView(heightNumber: heightNum);
                    bookingView.booking = booking;
                    bookingView.setBeginningTime(time: timeArray![0]);
                    bookingView.setEndTime(time: timeArray![1]);
                    bookingView.setHeight(height: CGFloat(heightNum * 16));
                    bookingView.setWidth(width: 180);
                    if let bookingClickedDelegate = bookingClickedDelegate {
                        bookingView.bookingClickedDelegate = bookingClickedDelegate;
                    }
                    bookingView.configureView()
                    addSubview(bookingView);
                    let padTopNum = (Utilities.heightGetterNum[timeArray![0]]! - Utilities.heightGetterNum[self.openTime!]!) * 16;
                    print(padTopNum)
                    print("padTopNum ABOVE")
                    bookingView.padTop(from: topAnchor, num: CGFloat(Double(padTopNum)));
                    self.reloadInputViews();
                    }
                }
            }
        }
    }
    
    func setBcn(bcn: String) {
        self.bcn = bcn;
    }
    
    
    func setOpenTime(openTime: String) {
        self.openTime = openTime;
    }
    
    func setCloseTime(closeTime: String) {
        self.closeTime = closeTime;
    }
    
    
    var openTime: String?
    
    var closeTime: String? {
        didSet {
            let height = Utilities().determineColumnHeight(dayStart: self.openTime!, dayEnd: self.closeTime!)
            contentSize = CGSize(width: 180, height: height);
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero);
        backgroundColor = .literGray;
        delegate = self;
        bounces = false;
        
        showsHorizontalScrollIndicator = false;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
