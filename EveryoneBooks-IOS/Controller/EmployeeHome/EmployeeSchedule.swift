//
//  EmployeeSchedule.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/8/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol EmployeeBookingCellProtocol: EmployeeSchedule {
    func goToBooking(booking: Booking);
}

class EmployeeSchedule: UIViewController, EmployeeBookingCellProtocol {
    
    func goToBooking(booking: Booking) {
        let vbvc = ViewBookingViewController();
        print(booking);
        print("BOOKING");
        vbvc.booking = booking;
        vbvc.modalPresentationStyle = .fullScreen;
        navigationController?.pushViewController(vbvc, animated: true);
    }
    
    
    private var shiftAddDate: String?;
    
    var bct: String? {
        didSet {
            bookingsCollection.bct = self.bct;
        }
    }
    
    var bookings: [Booking]? {
        didSet {
            bookingsCollection.bookings = self.bookings;
        }
    }
    
    @objc func dateChanged() {
        getStringDate()
        getBookings(date: self.shiftAddDate!)
    }
    
    private let datePickerForShiftAdd: MyDatePicker = {
        let dp = MyDatePicker();
        dp.addTarget(self, action: #selector(dateChanged), for: .valueChanged);
        return dp;
    }();
    
    private let scheduleText: UITextView = {
        let uitv = Components().createSimpleText(text: "Schedule Date: ");
        uitv.backgroundColor = .mainLav;
        uitv.font = .boldSystemFont(ofSize: 20);
        return uitv;
    }()
    
    private let bookingsShiftText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.backgroundColor = .mainLav;
        uitv.font = .boldSystemFont(ofSize: 18);
        uitv.setWidth(width: fullWidth / 1.2);
        return uitv;
    }()
    
    private let bookingsCollection: EmployeeBookingsCollection = {
        let layout = UICollectionViewFlowLayout();
        let ebt = EmployeeBookingsCollection();
        return ebt;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        bookingsCollection.employeeCellDelegate = self;
        handleLogo()
        configureView()
        getTodaysDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        getNewBookings();
        
    }
    
    func getBookings(date: String) {
        let employeeId = Utilities().decodeEmployeeToken()!["id"];
        API().post(url: myURL + "shifts/getEmployeeBookingsForDay", dataToSend: ["employeeId" : employeeId, "date": date]) { (res) in
            
            if res["statusCode"] as! Int == 406 {
                DispatchQueue.main.async {
                    self.bookingsCollection.isHidden = true;
                    self.bookingsShiftText.text = "You are not scheduled for today."
                    self.bookingsShiftText.isHidden = false;
                }
                return;
            }
            else if res["statusCode"] as! Int == 206 {
                if let shiftTimes = res["shiftTimes"] as? [String: String], let otherBct = res["bct"] as? String, let otherBcn = res["bcn"] as? String, let breakStart = res["breakStart"] as? String, let breakEnd = res["breakEnd"] as? String {
                    
                    let timeStart: String = shiftTimes["start"]!;
                    let timeEnd: String = shiftTimes["end"]!;
                    let fin = "You are scheduled to work on this day from " + timeStart + "-" + timeEnd + " but your book is currently empty. You are scheduled to be in " + otherBct + " " + otherBcn + ". You have a break from " + breakStart + "-" + breakEnd + ".";
                    DispatchQueue.main.async {
                        self.bookingsCollection.isHidden = true;
                        self.bookingsShiftText.text = fin;
                        self.bookingsShiftText.isHidden = false;
                    }
                    return;
                }
            }
            else if res["statusCode"] as! Int == 202 {
                if let shiftTimes = res["shiftTimes"] as? [String: String], let breakStart = res["breakStart"] as? String, let breakEnd = res["breakEnd"] as? String {
                    let timeStart: String = shiftTimes["start"]!;
                    
                    let timeEnd: String = shiftTimes["end"]!;
                    let fin = "You are scheduled to work on this day from " + timeStart + "-" + timeEnd + " but your book is currently empty. You have a break from " + breakStart + "-" + breakEnd + ".";
                    DispatchQueue.main.async {
                        self.bookingsCollection.isHidden = true;
                        self.bookingsShiftText.text = fin;
                        self.bookingsShiftText.isHidden = false;
                    }
                    return;
                }
            }
            else if res["statusCode"] as! Int == 201 {
                
                if let shiftTimes = res["shiftTimes"] as? [String: String], let otherBct = res["bct"] as? String, let otherBcn = res["bcn"] as? String {
                    let timeStart: String = shiftTimes["start"]!;
                    let timeEnd: String = shiftTimes["end"]!;
                    let fin = "You are scheduled to work on this day from " + timeStart + "-" + timeEnd + " but your book is currently empty. You are scheduled to be in " + otherBct  + " " + otherBcn + ".";
                    DispatchQueue.main.async {
                        self.bookingsCollection.isHidden = true;
                        self.bookingsShiftText.text = fin;
                        self.bookingsShiftText.isHidden = false;
                    }
                    return;
                }
               else if let shiftTimes = res["shiftTimes"] as? [String: String], let otherBct = res["bct"] as? String, let otherBcn = res["bcn"] as? String {
                    let timeStart: String = shiftTimes["start"]!;
                    let timeEnd: String = shiftTimes["end"]!;
                    let fin = "You are scheduled to work on this day from " + timeStart + "-" + timeEnd + " but your book is currently empty. You are scheduled to be in " + otherBct  + " " + otherBcn + ".";
                    DispatchQueue.main.async {
                        self.bookingsCollection.isHidden = true;
                        self.bookingsShiftText.text = fin;
                        self.bookingsShiftText.isHidden = false;
                    }
                    return;
                }
            }
            else if res["statusCode"] as! Int == 203 {
                if let shiftTimes = res["shiftTimes"] as? [String: String] {
                    let timeStart: String = shiftTimes["start"]!;
                    let timeEnd: String = shiftTimes["end"]!;
                    let fin = "You are scheduled to work on this day from " + timeStart + "-" + timeEnd + " but your book is currently empty."
                    DispatchQueue.main.async {
                        self.bookingsCollection.isHidden = true;
                        self.bookingsShiftText.text = fin;
                        self.bookingsShiftText.isHidden = false;
                    }
                    return;
                }
            }
            else if res["statusCode"] as! Int == 205 {
                let fin = "You have no bookings scheduled for today!";
                DispatchQueue.main.async {
                    self.bookingsCollection.isHidden = true;
                    self.bookingsShiftText.text = fin;
                    self.bookingsShiftText.isHidden = false;
                }
                return;
            }
            if let breakTime = res["breakTime"] as? String {
                self.bookingsCollection.breakTime = breakTime;
                self.bookingsCollection.isBreak = true;
            }
            DispatchQueue.main.async {
                self.bookingsCollection.isHidden = false;
                self.bookingsShiftText.isHidden = true;
            }
            self.bct = res["bct"] as? String;
            var emptyBookingsArray: [Booking] = [];
            if let bookingsBack = res["bookings"] as? [[String: Any]] {
                
                for individualBooking in bookingsBack {
                    let newBooking = Booking(dic: individualBooking);
                    emptyBookingsArray.append(newBooking);
                }
                self.bookings = emptyBookingsArray;
            }
        }
    }
    
    func configureView() {
        view.addSubview(scheduleText);
        scheduleText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 15);
        scheduleText.centerTo(element: view.centerXAnchor);
        view.addSubview(datePickerForShiftAdd);
        datePickerForShiftAdd.padTop(from: scheduleText.bottomAnchor, num: 8);
        datePickerForShiftAdd.centerTo(element: view.centerXAnchor);
        view.addSubview(bookingsCollection);
        bookingsCollection.centerTo(element: view.centerXAnchor);
        bookingsCollection.padTop(from: datePickerForShiftAdd.bottomAnchor, num: 10);
        bookingsCollection.padBottom(from: view.safeAreaLayoutGuide.bottomAnchor, num: 0);
        bookingsCollection.setWidth(width: fullWidth);
        bookingsCollection.alwaysBounceVertical = true;
        view.addSubview(bookingsShiftText);
        bookingsShiftText.padTop(from: datePickerForShiftAdd.bottomAnchor, num: 10);
        bookingsShiftText.centerTo(element: view.centerXAnchor);
    }
    
  
    
    func handleLogo() {
        navigationController?.navigationBar.backgroundColor = .mainLav;
               navigationController?.navigationBar.barTintColor = .mainLav;
               let logoView = UIImageView(image: UIImage(named: "logo-small"));
               logoView.setHeight(height: 36);
               logoView.setWidth(width: 36);
               navigationItem.titleView = logoView;
    }
    
    func getStringDate() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        self.shiftAddDate = df.string(from: datePickerForShiftAdd.date);
    }
    
    func getTodaysDate() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        let dateString = df.string(from: Date());
        getBookings(date: dateString)
    }
    
    func getNewBookings() {
        let df = DateFormatter();
        df.dateFormat = "MMM dd, yyyy";
        getBookings(date: df.string(from: datePickerForShiftAdd.date));
    }
}
