//
//  RoomAreaCollectionView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 9/17/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class RoomAreaCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var bookings: [[Booking]]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    weak var bookingClickedDelegate: BookingClickedProtocol?
    
    var timeSlotNum: Int?;
    var openTime: String?;
    var closeTime: String?;
    var bct: String?;
    var bcn: String?;
    var date: String?;

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let myLayout = UICollectionViewFlowLayout();
        myLayout.scrollDirection = .horizontal;
        super.init(frame: frame, collectionViewLayout: myLayout);
        dataSource = self;
        delegate = self;
        register(RoomAreaColumn.self, forCellWithReuseIdentifier: "1");
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let bookings = bookings {
            return bookings.count;
        }
        return 0;
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "1", for: indexPath) as! RoomAreaColumn;
        if let date = self.date {
            cell.setDate(date: date)
        }
        cell.configureCell();
        if let timeSlotNum = self.timeSlotNum {
            cell.setColumnTimeSlotNum(num: timeSlotNum)
        }
        if let openTime = self.openTime, let closeTime = self.closeTime {
            cell.setColumnOpenTime(open: openTime);
            cell.setColumnCloseTime(close: closeTime);
        }
        cell.setBcn(bcn: String(indexPath.row + 1));
        if let bct = bct {
            cell.setRoomText(text: bct + " " + String(indexPath.row + 1));
        }
        if let bookings = bookings {
            print(indexPath.row)
            cell.setColumnBookings(bookings: bookings[cell.getBcn() - 1])
        }
        cell.bookingClickedDelegate = bookingClickedDelegate;
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: fullHeight - 200);
    }
}
