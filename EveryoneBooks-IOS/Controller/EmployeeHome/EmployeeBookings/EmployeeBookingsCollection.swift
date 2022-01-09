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
            print(self.bookings)
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    var employeeCellDelegate: EmployeeBookingCellProtocol?;
    
    var bct: String?;
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout());
        register(EmployeeBookingCollectionCell.self, forCellWithReuseIdentifier: "EBC");
        delegate = self;
        dataSource = self;
        backgroundColor = .mainLav;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let bookings = bookings {
            print(bookings.count);
            print("THE COUNT IS BELOW");
            return bookings.count;
        }
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "EBC", for: indexPath) as! EmployeeBookingCollectionCell;
        if let bookings = bookings {
            cell.booking = bookings[indexPath.row];
            cell.bct = self.bct;
            if let employeeCellDelegate = self.employeeCellDelegate {
                cell.delegate = employeeCellDelegate;
            }
            cell.configureCell();
            return cell;
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     return CGSize(width: fullWidth, height: 260);
 }
    
}
