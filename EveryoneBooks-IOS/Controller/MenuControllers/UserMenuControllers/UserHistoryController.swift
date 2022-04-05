//
//  UserHistoryController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/1/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class UserHistoryController: UIViewController {

    private let exitButton: UIButton = {
        let exitButton = Components().createXButton();
        exitButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside);
        return exitButton;
    }();
    
    private var bookings: [Booking]? {
        didSet {
            bookingHistoryTable.bookings = self.bookings;
        }
    }
    
    private let headerText: UITextView = {
        let headerText = UITextView();
        headerText.isEditable = false;
        headerText.isScrollEnabled = false;
        headerText.font = .boldSystemFont(ofSize: 22);
        headerText.text = "Booking History";
        headerText.backgroundColor = .mainLav;
        return headerText;
    }()
    
    private let bookingHistoryTable = BookingHistoryTable();
    
    @objc func dismissMe() {
        self.dismiss(animated: true, completion: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainLav;
        setup();
        getBookingsHistory();
    }
    
    func setup() {
        view.addSubview(exitButton);
        exitButton.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 8);
        exitButton.padRight(from: view.rightAnchor, num: 20);
        view.addSubview(headerText);
        headerText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 12);
        headerText.padLeft(from: view.leftAnchor, num: 80);
        view.addSubview(bookingHistoryTable);
        bookingHistoryTable.padTop(from: headerText.bottomAnchor, num: 20);
        bookingHistoryTable.centerTo(element: view.centerXAnchor);
        bookingHistoryTable.setHeight(height: fullHeight / 1.4);
        bookingHistoryTable.setWidth(width: fullWidth);
    }
    
    func getBookingsHistory() {
        API().get(url: myURL + "getBookings/userHistory", headerToSend: Utilities().getToken()) { res in
            if res["statusCode"] as! Int == 200 {
                if let pastBookings = res["bookings"] as? [[String: Any]] {
                    var pastBookingsArray: [Booking] = [];
                    for pastBooking in pastBookings {
                        pastBookingsArray.append(Booking(dic: pastBooking));
                    }
                    self.bookings = pastBookingsArray;
                }
            }
        }
    }
}
