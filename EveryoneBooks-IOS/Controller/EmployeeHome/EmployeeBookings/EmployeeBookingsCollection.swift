//
//  EmployeeBookingsCollection.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/6/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeeBookingsCollection: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var bookings: [Booking]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    var isBreak = false {
        didSet {
            print("isBreak setto detto");
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    var breakTime: String?
    
    var employeeCellDelegate: EmployeeBookingCellProtocol?;
    
    var bct: String?;
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout());
        register(EmployeeBookingCollectionCell.self, forCellWithReuseIdentifier: "EBC");
       // register(BreakFillerCell.self, forCellWithReuseIdentifier: "BreakCell");
        delegate = self;
        dataSource = self;
        backgroundColor = .mainLav;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let bookings = bookings {
            if isBreak {
                return 1 + bookings.count;
            }
            else {
                return bookings.count;
            }
        }
        else {
            return 0;
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "EBC", for: indexPath) as! EmployeeBookingCollectionCell;
        if let bookings = bookings {
            if indexPath.row == 0 {
//            if isBreak {
//                    let otherCell = dequeueReusableCell(withReuseIdentifier: "BreakCell", for: indexPath) as! BreakFillerCell;
//                    if let breakTime = breakTime {
//                        otherCell.breakTime = breakTime;
//                        otherCell.setup()
//                    }
//                    return otherCell;
//            }
            if indexPath.row == bookings.count {
                cell.booking = bookings[indexPath.row];
                cell.bct = self.bct;
                if let employeeCellDelegate = self.employeeCellDelegate {
                    cell.delegate = employeeCellDelegate;
                }
                cell.configureCell();
                    return cell;
                }
            }
            else {
                if indexPath.row < bookings.count {
                    cell.booking = bookings[indexPath.row];
                    cell.bct = self.bct;
                    if let employeeCellDelegate = self.employeeCellDelegate {
                        cell.delegate = employeeCellDelegate;
                    }
                    cell.configureCell();
                        return cell;
                }
                else {
                    cell.booking = bookings[indexPath.row - 1];
                    cell.bct = self.bct;
                    if let employeeCellDelegate = self.employeeCellDelegate {
                        cell.delegate = employeeCellDelegate;
                    }
                    cell.configureCell();
                        return cell;
                }
            }
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isBreak {
            if indexPath.row == 0 {
                return CGSize(width: fullWidth, height: 100);
            }
        }
     return CGSize(width: fullWidth, height: 260);
 }
    
}
