//
//  EmployeeSchedule.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/8/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeeSchedule: UIViewController {
    
    private var shiftAddDate: String?;
    
    var bct: String? {
        didSet {
            bookingsTable.bct = self.bct;
        }
    }
    
    var bookings: [Booking]? {
        didSet {
            bookingsTable.bookings = self.bookings;
            DispatchQueue.main.async {
                self.bookingsTable.reloadData()
            }
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
        uitv.backgroundColor = .literGray;
        uitv.font = .boldSystemFont(ofSize: 28);
        return uitv;
    }()
    
    private let bookingsShiftText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.backgroundColor = .literGray;
        uitv.font = .boldSystemFont(ofSize: 18);
        uitv.setWidth(width: fullWidth / 1.2);
        return uitv;
    }()
    
    private let bookingsTable: EmployeeBookingsTable = {
        let ebt = EmployeeBookingsTable();
        ebt.setWidth(width: fullWidth / 1.03);
        ebt.setHeight(height: fullWidth * 1.1);
        return ebt;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLogo()
        configureView()
        getTodaysDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    func getBookings(date: String) {
        let employeeId = Utilities().decodeEmployeeToken()!["id"];
        API().post(url: myURL + "shifts/getEmployeeBookingsForDay", dataToSend: ["employeeId" : employeeId, "date": date]) { (res) in
            print(res)
            if res["statusCode"] as! Int == 406 {
                DispatchQueue.main.async {
                    self.bookingsTable.isHidden = true;
                    self.bookingsShiftText.text = "You are not scheduled for today."
                }
                return;
            }
            else if res["statusCode"] as! Int == 206 {
                if let shiftTimes = res["shiftTimes"] as? [String: String] {
                    let timeStart: String = shiftTimes["start"]!;
                    let timeEnd: String = shiftTimes["end"]!;
                    let fin = "You are scheduled to work on this day from " + timeStart + "-" + timeEnd + " but your book is currently empty.";
                    DispatchQueue.main.async {
                        self.bookingsTable.isHidden = true;
                        self.bookingsShiftText.text = fin;
                    }
                    return;
                }
            }
            DispatchQueue.main.async {
                self.bookingsTable.isHidden = false;
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
        view.addSubview(bookingsTable);
        bookingsTable.centerTo(element: view.centerXAnchor);
        bookingsTable.padTop(from: datePickerForShiftAdd.bottomAnchor, num: 10)
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
}
