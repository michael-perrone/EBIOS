//
//  EmployeeShiftsTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 9/3/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeeBookingsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
  
    var bookings: [Booking]?;
    
    var bct: String?;
    
    private let cell1 = "12121212";
    
    override init(frame: CGRect, style: UITableView.Style) {
           super.init(frame:frame, style: UITableView.Style.grouped);
           register(EmployeeBookingsCell.self, forCellReuseIdentifier: cell1);
           dataSource = self;
           delegate = self;
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bookings = self.bookings {
            return bookings.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cell1, for: indexPath) as! EmployeeBookingsCell;
        if let bookings = self.bookings {
            cell.booking = bookings[indexPath.row]
            cell.configureCell();
            cell.setWidth(width: fullWidth);
            cell.bct = self.bct;
            cell.selectionStyle = .none;
            cell.backgroundColor = .green;
            return cell;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250;
    }

}
