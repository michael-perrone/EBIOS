//
//  ColumnScrollView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 1/5/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//



import UIKit

class ColumnScrollView: UIScrollView, UIScrollViewDelegate {
    
    
    var bookingClickedDelegate: BookingClickedProtocol?;
    
    var groupClickedDelegate: GroupClickedProtocol?;
    
    var bcn: String?
    
    var bookings: [Booking]? {
        didSet {
            var bookingsViews = 0;
            for subview in subviews {
                if subview is BookingView {
                  bookingsViews = bookingsViews + 1;
                }
            }
            
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
                    bookingView.padTop(from: topAnchor, num: CGFloat(Double(padTopNum)));
                    self.reloadInputViews();
                    }
                }
            }
        }
    }
    
    var groups: [Group]? {
        didSet {
            var groupsViews = 0;
            for subview in subviews {
                if subview is GroupView {
                  groupsViews = groupsViews + 1;
                }
            }
            
            if let groups = groups {
            if groupsViews != groups.count  {
                for group in groups {
                    let timeArray = group.time?.components(separatedBy: "-");
                    let heightNum = Utilities.heightGetterNum[timeArray![1]]! - Utilities.heightGetterNum[timeArray![0]]!;
                    let groupView = GroupView(heightNumber: heightNum);
                    groupView.group = group;
                    groupView.setBeginningTime(time: timeArray![0]);
                    groupView.setEndTime(time: timeArray![1]);
                    groupView.setHeight(height: CGFloat(heightNum * 16));
                    groupView.setWidth(width: 180);
                    if let groupClickedDelegate = groupClickedDelegate {
                        groupView.groupClickedDelegate = groupClickedDelegate;
                    }
                    groupView.configureView()
                    addSubview(groupView);
                    let padTopNum = (Utilities.heightGetterNum[timeArray![0]]! - Utilities.heightGetterNum[self.openTime!]!) * 16;
                    groupView.padTop(from: topAnchor, num: CGFloat(Double(padTopNum)));
                    self.reloadInputViews();
                    }
                }
            }
        }
    }
    
    var breaks: [Break]? {
        didSet {
            var breakViews = 0;
            for subview in subviews {
                if subview is BreakView {
                  breakViews = breakViews + 1;
                }
            }
            if let breaks = breaks {
            if breakViews != breaks.count  {
                for iBreak in breaks {
                    print(iBreak)
                    let timeArray = iBreak.time?.components(separatedBy: "-");
                    let heightNum = Utilities.heightGetterNum[timeArray![1]]! - Utilities.heightGetterNum[timeArray![0]]!;
                    let breakView = BreakView(heightNumber: heightNum);
                    breakView.iBreak = iBreak;
                    breakView.setBeginningTime(time: timeArray![0]);
                    breakView.setEndTime(time: timeArray![1]);
                    breakView.setHeight(height: CGFloat(heightNum * 16));
                    breakView.setWidth(width: 180);
                    breakView.configureView()
                    addSubview(breakView);
                    let padTopNum = (Utilities.heightGetterNum[timeArray![0]]! - Utilities.heightGetterNum[self.openTime!]!) * 16;
                    breakView.padTop(from: topAnchor, num: CGFloat(Double(padTopNum)));
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
