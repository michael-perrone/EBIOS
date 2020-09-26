//
//  EmployeesAvailableTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/19/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol EmployeeTableViewDelegate: EmployeesAvailableTable {
    func bookEmployee(employeeId: String)
}

class EmployeesAvailableTable: UITableView, UITableViewDataSource, UITableViewDelegate, EmployeeTableViewDelegate {
    
    var fakeData = ["1", "2", "3", "4", "5", "1", "2", "3", "4", "5"];
    
    var otherDelegate: EmployeesTable?;
    
    var timeChosen: String?;
    
    var businessId: String?;
       
    var dateChosen: String?;
       
    var services: [Service]?

    func bookEmployee(employeeId: String) {
        var serviceIdsArray: [String] = [];
        
        for service in services! {
            serviceIdsArray.append(service.id);
        }
        if let timeStart = self.timeChosen, let date = self.dateChosen, let businessId = businessId {
            let data = ["timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": businessId] as [String : Any];
            API().post(url: myURL + "iosBooking/user", headerToSend: Utilities().getToken(), dataToSend: data) { (res) in
                if res["statusCode"] as! Int == 200{
                    self.otherDelegate?.bookHit()
                } else {
                    print("something musta went wrong")
                }
            }
        }
    }
    
       var employees: [Employee]? {
           didSet {
            print("employees updated");
            print(self.employees)
               DispatchQueue.main.async {
                   self.reloadData();
               }
           }
       }
       
       override init(frame: CGRect, style: UITableView.Style) {
           super.init(frame:frame, style: UITableView.Style.grouped);
           
           dataSource = self;
           delegate = self;
           register(EmployeeAvailableCell.self, forCellReuseIdentifier: "employeeCell");
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if let employees = employees {
            print("before count");
            print(employees.count)
                return employees.count;
           }
           else {
               return 0;
           }
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeAvailableCell;
        if let employees = employees {
            print(employees)
            print("EMPLOYEES JUST PRINTED TABLE")
            cell.employee = employees[indexPath.row];
            cell.configureCell();
            cell.delegate = self;
            cell.selectionStyle = .none
        }
        return cell;
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 48;
       }
   }
