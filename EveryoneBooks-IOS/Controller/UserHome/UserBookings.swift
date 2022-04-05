//
//  UserBookings.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/5/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit



protocol UserBookingCancel: UserBookings {
    func cancelBooking(booking: Booking, row: Int);
}

protocol LeaveGroupDelegate: UserBookings {
    func leaveGroup(group: Group, row: Int);
}

class UserBookings: UICollectionViewController, UserBookingCancel, LeaveGroupDelegate {
    
    func leaveGroup(group: Group, row: Int) {
        let alertController = UIAlertController(title: "Confirm Leave", message: "Please confirm that you would like to leave this group.", preferredStyle: .alert);
        let confirmDelete = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
            API().post(url: myURL + "groups/userLeft", headerToSend: Utilities().getToken(), dataToSend: ["groupId": group.id]) { res in
                if res["statusCode"] as! Int == 200 {
                    self.allOfIt.remove(at: row);
                }
            }
        }
        let nevermind = UIAlertAction(title: "Oops, no!", style: .cancel, handler: nil);
        alertController.addAction(confirmDelete);
        alertController.addAction(nevermind);
        self.present(alertController, animated: true, completion: nil);
    }
    
    
    func presentFailure(alert: UIAlertController) {
        present(alert, animated: true, completion: nil);
    }
    
    func presentSuccess(alert: UIAlertController) {
        present(alert, animated: true) {
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    func cancelBooking(booking: Booking, row: Int) {
        
        let alertController = UIAlertController(title: "Confirm Cancellation", message: "Please confirm that you would like to cancel this booking.", preferredStyle: .alert);
        let confirmDelete = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
            API().post(url: myURL + "iosBooking/deleteFromUser", headerToSend: Utilities().getToken(), dataToSend: ["bookingId": booking.id]) { res in
                if res["statusCode"] as! Int == 200 {
                    self.allOfIt.remove(at: row);
                }
            }
        }
        let nevermind = UIAlertAction(title: "Oops, no!", style: .cancel, handler: nil);
        alertController.addAction(confirmDelete);
        alertController.addAction(nevermind);
        self.present(alertController, animated: true, completion: nil);
    }
    
    var allOfIt: [Any] = [] {
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
        collectionView.register(UserGroupsCell.self, forCellWithReuseIdentifier: "UserGroupCell");
        collectionView.register(NoBookingsCell.self, forCellWithReuseIdentifier: "NB");
        collectionView.backgroundColor = .mainLav;
    }
    
    
    func getBookings() {
        API().get(url: myURL + "getBookings/ios", headerToSend: Utilities().getToken()) { (res) in
            self.allOfIt = [];
            var bookings: [Booking] = [];
            if let bookingsBack = res["bookings"] as? [[String: Any]] {
                for booking in bookingsBack {
                    print(booking);
                    let actualBooking = Booking(dic: booking);
                    self.allOfIt.append(actualBooking)
                }
               
            }
            if let groupsBack = res["groups"] as? [[String: Any]] {
                var realGroups: [Group] = [];
                for group in groupsBack {
                    let actualGroup = Group(dic: group);
                    self.allOfIt.append(actualGroup);
                }
            }
        }
    }
}

extension UserBookings {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if allOfIt.count > 0 {
            return allOfIt.count;
        }
        else {
            return 1;
        }
}

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let noBookingsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NB", for: indexPath) as! NoBookingsCell;
        if allOfIt.count == 0 {
            noBookingsCell.configureCell();
            return noBookingsCell;
            }
        else {
            if allOfIt[indexPath.row] is Group {
                let groupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserGroupCell", for: indexPath) as! UserGroupsCell;
                groupCell.row = indexPath.row;
                groupCell.group = allOfIt[indexPath.row] as! Group;
                groupCell.leaveDelegate = self;
                groupCell.configureCell();
                return groupCell;
            }
            if allOfIt[indexPath.row] is Booking {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserBookingsCell", for: indexPath) as! UserBookingsCollectionCell;
                cell.row = indexPath.row;
                cell.booking = allOfIt[indexPath.row] as! Booking;
                cell.cancelDelegate = self;
                cell.configureCell();
                return cell;
            }
            
            }
        return noBookingsCell;
        }
    }
    


extension UserBookings: UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 290);
    }
}
