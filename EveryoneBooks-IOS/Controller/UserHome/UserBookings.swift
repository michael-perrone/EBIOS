//
//  UserBookings.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/5/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit



protocol UserBookingViewClicked: UserBookings {
    func viewBooking(booking: Booking);
}

class UserBookings: UICollectionViewController, UserBookingViewClicked {
    
    func presentFailure(alert: UIAlertController) {
        present(alert, animated: true, completion: nil);
    }
    
    func presentSuccess(alert: UIAlertController) {
        present(alert, animated: true) {
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    func viewBooking(booking: Booking) {
        DispatchQueue.main.async {
            let vbvc = ViewBookingViewController();
            vbvc.booking = booking;
            vbvc.modalPresentationStyle = .fullScreen;
            self.navigationController?.pushViewController(vbvc, animated: true);
        }
    }
    
    
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
        collectionView.register(NoBookingsCell.self, forCellWithReuseIdentifier: "NB");
        collectionView.backgroundColor = .mainLav;
    }
    
    
    func getBookings() {
        API().get(url: myURL + "getBookings/ios", headerToSend: Utilities().getToken()) { (res) in
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
        if bookings.count == 0 {
            return 1;
        }
        else {
            return bookings.count;
        }
    }
    else {
        return 1;
    }
}

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noBookingsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NB", for: indexPath) as! NoBookingsCell;
        if let bookings = bookings {
            if bookings.count == 0 {
                noBookingsCell.configureCell();
                return noBookingsCell;
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserBookingsCell", for: indexPath) as! UserBookingsCollectionCell;
            cell.booking = bookings[indexPath.row];
            cell.viewClickedDelegate = self;
            cell.configureCell();
            return cell;
        } else {
            return noBookingsCell;
        }
    }
}


extension UserBookings: UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 290);
    }
}
