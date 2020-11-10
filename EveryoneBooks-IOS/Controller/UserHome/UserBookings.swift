//
//  UserBookings.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/5/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class UserBookings: UICollectionViewController {
    
    var bookings: [Booking]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData();
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.getBookings();
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .mainLav;
        navigationController?.navigationBar.barTintColor = .mainLav;
        navigationItem.title = "My Bookings";
        collectionView.register(UserBookingsCollectionCell.self, forCellWithReuseIdentifier: "UserBookingsCell");
        collectionView.backgroundColor = .literGray;
    }
    
    
    func getBookings() {
        API().get(url: myURL + "getBookings/ios", headerToSend: Utilities().getToken()) { (res) in
            print(res)
            var bookings: [Booking] = [];
            if let bookingsBack = res["bookings"] as? [[String: Any]] {
                for booking in bookingsBack {
                    let actualBooking = Booking(dic: booking);
                    bookings.append(actualBooking)
                }
                self.bookings = bookings;
            }
        }
    }
}

extension UserBookings {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let bookings = bookings {
        return bookings.count;
    }
    else {
        return 0;
    }
}

override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserBookingsCell", for: indexPath) as! UserBookingsCollectionCell;
    if let bookings = bookings {
        cell.booking = bookings[indexPath.row];
        cell.configureCell()
        }
    return cell;
    }
}


extension UserBookings: UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 260);
    }
}
