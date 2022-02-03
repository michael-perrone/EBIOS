//
//  AdminBooking.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/3/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol ReloadTableAfterBooking: AdminBookings {
    func reloadTable();
}


protocol BookingClickedProtocol: AdminBookings {
    func viewBookingInfo(booking: Booking);
}

class AdminBookings: UIViewController, ReloadTableAfterBooking, BookingClickedProtocol{
    
  
    
    func viewBookingInfo(booking: Booking) {
        DispatchQueue.main.async {
            let vbvc = ViewBookingViewController();
            vbvc.booking = booking;
            vbvc.modalPresentationStyle = .fullScreen;
            self.navigationController?.pushViewController(vbvc, animated: true);
        }
    }
    
    func reloadTable() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        let dateNeeded = df.string(from: datePicker.date);
        getBookings(date: dateNeeded);
        self.roomAreaTable.date = dateNeeded;
    }
    
    var bookings: [[Booking]]? {
        didSet {
            self.roomAreaTable.bookings = self.bookings;
            self.roomAreaTable.bookingClickedDelegate = self;
        }
    }
    
    var bct: String?;
    
    var timeSlots: Int?;
    
    private let datePicker: UIDatePicker = {
        let dp = MyDatePicker();
        //  if #available(iOS 13.4, *) {
        //    dp.preferredDatePickerStyle = .wheels;
        //}
        dp.addTarget(self, action: #selector(dateChanged), for: .valueChanged);
        return dp;
    }() 
    
    private let roomAreaTable: RoomAreaCollectionView = {
        let ratv = RoomAreaCollectionView();
        ratv.backgroundColor = .mainLav;
        return ratv;
    }();
    
    private var bcn: Int?;
    
    private let border = Components().createBorder(height: 2, width: fullWidth, color: .darkGray);
    
    @objc func dateChanged() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        let dateNeeded = df.string(from: datePicker.date);
        getBookings(date: dateNeeded);
        self.roomAreaTable.date = dateNeeded;
    }
    
    lazy var createBookingButton: UIButton = {
        let uib = Components().createAddBooking();
        uib.addTarget(self, action: #selector(showCreateBooking), for: .touchUpInside);
        return uib;
    }()
    
    private var eq: String?;
    
    @objc func showCreateBooking() {
        let createBooking = CreateBooking();
        if let eq = eq, let bct = bct {
            createBooking.bct = bct;
            createBooking.eq = eq;
        }
        createBooking.delegate = self;
        createBooking.modalPresentationStyle = .fullScreen;
        self.present(createBooking, animated: true, completion: nil);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        let dateNeeded = df.string(from: datePicker.date);
        getBookings(date: dateNeeded);
        self.roomAreaTable.date = dateNeeded;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        navigationItem.title = "Schedule";
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createBookingButton);
        configureView()
      
    }
    
    func configureView() {
        view.addSubview(datePicker);
        datePicker.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        datePicker.centerTo(element: view.centerXAnchor);
        datePicker.setHeight(height: 70);
        view.addSubview(roomAreaTable);
        roomAreaTable.setWidth(width: fullWidth);
        roomAreaTable.padTop(from: datePicker.bottomAnchor, num: 20);
        roomAreaTable.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 0);
        roomAreaTable.centerTo(element: view.centerXAnchor);
        view.addSubview(border);
        border.padTop(from: roomAreaTable.topAnchor, num: -2);
        border.centerTo(element: view.centerXAnchor);
        navigationController?.navigationBar.barTintColor = .mainLav;
    }
    
    func getBookings(date: String) {
        let dateToSend: [String: String] = ["date": date];
        API().post(url: myURL + "adminSchedule", headerToSend: Utilities().getAdminToken(), dataToSend: dateToSend) { (res) in
            if res["statusCode"] as? Int == 200 {
                if let bct = res["bct"] as? String {
                    self.roomAreaTable.bct = bct;
                    self.bct = bct;// getting bookingColumnType
                }
                if let open = res["open"] as? String, let close = res["close"] as? String {
                    let num = Utilities().getTimeNum(startTime: open, endTime: close);
                    self.roomAreaTable.openTime = open;
                    self.roomAreaTable.closeTime = close;
                    self.roomAreaTable.timeSlotNum = num;
                }
                
                if let bcn = res["bcn"] as? String {
                    if let eq = res["eq"] as? String {
                        print(eq);
                        print("EQ IN RES")
                        if eq == "n" {
                            self.bcn = Int(bcn);
                            self.eq = eq;
                        }
                    }
                    if let bookings = res["bookings"] as? [[String: Any]] {
                        var bookingsArray: [Booking] = []; // empty bookings array
                        for booking in bookings {
                            let newBooking = Booking(dic: booking);
                            bookingsArray.append(newBooking);
                        }
                        let bcnInt = Int(bcn)
                        var i = 1;
                        var arrayOfBookingArrays: [[Booking]] = [];
                        if let bcnUnwrapped = bcnInt {
                            while i <= bcnUnwrapped {
                                var bookingArrayToBeAppended: [Booking] = [];
                                for individualBooking in bookingsArray {
                                     if Int(individualBooking.bcn!) == i {
                                        bookingArrayToBeAppended.append(individualBooking);
                                    }
                                }
                                arrayOfBookingArrays.append(bookingArrayToBeAppended);
                                i = i + 1;
                            }
                            self.bookings = arrayOfBookingArrays;
                        }
                        else {
                            print("No")
                        }
                    } else {
                        print("Double no")
                    }
                }
            }
        }
    }
}
