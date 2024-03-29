import UIKit

protocol EmployeeTableViewDelegate: EmployeesAvailableTable {
    func bookEmployee(employeeId: String)
}

class EmployeesAvailableTable: UITableView, UITableViewDataSource, UITableViewDelegate, EmployeeTableViewDelegate {
    
    weak var otherDelegate: EmployeesTable?;
    
    weak var otherOtherDelegate: BookingHit?;
    
    var cost = "" {
        didSet {
            
        }
    }
    
    var dates: [String]?;
    
    var eq: Bool?
    
    var timeChosen: String?;
    
    var businessId: String?;
       
    var dateChosen: String?;
       
    var services: [Service]?;
    
    var fromBusiness: Bool?;
    
    var phone: String?;
    
    var fullName: String?;
    
    var newGuestInfoSaved = false;
    
    var isNewGuestBeingRegistered = false;
    
    var selectedBcn: Int?
    
    func bookEmployee(employeeId: String) {
        if let dates = dates {
            if dates.count > 0 {
                bookEmployeeClone(employeeId: employeeId);
            }
        }
        else {
            bookEmployeeSingle(employeeId: employeeId);
        }
    }
    
    func bookEmployeeClone(employeeId: String) {
            var serviceIdsArray: [String] = [];
            for service in services! {
                serviceIdsArray.append(service.id);
            }
            if let timeStart = self.timeChosen, let date = self.dateChosen, let businessId = businessId {
                if let fromBusiness = fromBusiness {
                    if let phone = phone {
                        if !newGuestInfoSaved {
                            if !isNewGuestBeingRegistered {
                                var data: [String: Any];
                                if let selectedBcn = selectedBcn {
                                    data = ["phone": phone ,"timeStart": timeStart, "date": date, "dates": dates!, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": Utilities().decodeAdminToken()!["businessId"], "bcn": selectedBcn, "cost": cost]
                                }
                                else {
                                    data = ["phone": phone ,"timeStart": timeStart, "date": date, "dates": dates!, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": Utilities().decodeAdminToken()!["businessId"], "cost": cost]
                                }
                                API().post(url: myURL + "iosBooking/admin/clone", dataToSend: data) { (res) in
                                    if res["statusCode"] as! Int == 200 {
                                        self.otherOtherDelegate?.bookHit();
                                    }
                                    else if res["statusCode"] as! Int == 406 {
                                        self.otherOtherDelegate?.badPhone();
                                    }
                                    else if res["statusCode"] as! Int == 409 {
                                        self.otherOtherDelegate?.bcnNotSelected();
                                    }
                                }
                            }
                            else {
                                self.otherOtherDelegate?.notFinished();
                            }
                        }
                        else {
                            let data: [String: Any];
                            if let selectedBcn = selectedBcn {
                                data = ["phone": phone, "name": fullName, "timeStart": timeStart, "date": date, "dates": dates!, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": Utilities().decodeAdminToken()!["businessId"], "bcn": selectedBcn, "cost": cost];
                            }
                            else {
                                data = ["phone": phone, "name": fullName, "timeStart": timeStart, "date": date, "dates": dates!, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": Utilities().decodeAdminToken()!["businessId"], "cost": cost];
                                
                            }
                            API().post(url: myURL + "iosBooking/admin/newGuest/clone", dataToSend: data) { (res) in
                                if res["statusCode"] as! Int == 200 {
                                    self.otherOtherDelegate?.bookHit();
                                }
                                else {
                                    if res["statusCode"] as! Int == 409 {
                                        self.otherOtherDelegate?.alreadyRegisted();
                                    }
                                }
                            }
                        }
                    }
                    else {
                        otherOtherDelegate!.noPhone()
                }
            }
            else {
                let data = ["timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": businessId] as [String : Any];
            //   if self.eq! {
    //                API().post(url: myURL + "iosBooking/user", headerToSend: Utilities().getToken(), dataToSend: data) { (res) in
    //                    print(res)
    //                    if res["statusCode"] as! Int == 200 {
    //                        self.otherDelegate?.bookHit()
    //                    } else {
    //                        print("here")
    //                        self.otherOtherDelegate?.badPhone();
    //                    }
    //                }
             //   }
            //    else {
                    API().post(url: myURL + "iosBooking/sendNotiFromUser", headerToSend: Utilities().getToken(), dataToSend: data) { (res) in
                        if res["statusCode"] as! Int == 200 {
                            self.otherDelegate?.userNotiSent()
                        }
                    }
          //      }
            }
        }
    }

    
    func bookEmployeeSingle(employeeId: String) {
        var serviceIdsArray: [String] = [];
        for service in services! {
            serviceIdsArray.append(service.id);
        }
        if let timeStart = self.timeChosen, let date = self.dateChosen, let businessId = businessId {
            if let fromBusiness = fromBusiness {
                if let phone = phone {
                    if !newGuestInfoSaved {
                        if !isNewGuestBeingRegistered {
                            var data: [String: Any];
                            if let selectedBcn = selectedBcn {
                                data = ["phone": phone ,"timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": Utilities().decodeAdminToken()!["businessId"], "bcn": selectedBcn, "cost": cost]
                            }
                            else {
                                data = ["phone": phone ,"timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": Utilities().decodeAdminToken()!["businessId"], "cost": cost]
                            }
                            API().post(url: myURL + "iosBooking/admin", dataToSend: data) { (res) in
                                if res["statusCode"] as! Int == 200 {
                                    self.otherOtherDelegate?.bookHit();
                                }
                                else if res["statusCode"] as! Int == 406 {
                                    self.otherOtherDelegate?.badPhone();
                                }
                                else if res["statusCode"] as! Int == 409 {
                                    self.otherOtherDelegate?.bcnNotSelected();
                                }
                            }
                        }
                        else {
                            self.otherOtherDelegate?.notFinished();
                        }
                    }
                    else {
                        let data: [String: Any];
                        if let selectedBcn = selectedBcn {
                            data = ["phone": phone, "name": fullName, "timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": Utilities().decodeAdminToken()!["businessId"], "bcn": selectedBcn, "cost": cost];
                        }
                        else {
                            data = ["phone": phone, "name": fullName, "timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": Utilities().decodeAdminToken()!["businessId"], "cost": cost];
                        }
                        API().post(url: myURL + "iosBooking/admin/newGuest", dataToSend: data) { (res) in
                            if res["statusCode"] as! Int == 200 {
                                self.otherOtherDelegate?.bookHit();
                            }
                            else {
                                if res["statusCode"] as! Int == 409 {
                                    self.otherOtherDelegate?.alreadyRegisted();
                                }
                            }
                        }
                    }
                }
                else {
                    otherOtherDelegate!.noPhone()
            }
        }
        else {
            let data = ["timeStart": timeStart, "date": date, "serviceIds": serviceIdsArray, "employeeId": employeeId, "businessId": businessId] as [String : Any];
        //   if self.eq! {
//                API().post(url: myURL + "iosBooking/user", headerToSend: Utilities().getToken(), dataToSend: data) { (res) in
//                    print(res)
//                    if res["statusCode"] as! Int == 200 {
//                        self.otherDelegate?.bookHit()
//                    } else {
//                        print("here")
//                        self.otherOtherDelegate?.badPhone();
//                    }
//                }
         //   }
        //    else {
                API().post(url: myURL + "iosBooking/sendNotiFromUser", headerToSend: Utilities().getToken(), dataToSend: data) { (res) in
                    if res["statusCode"] as! Int == 200 {
                        self.otherDelegate?.userNotiSent()
                    }
                }
      //      }
        }
    }
}
    
    
    
    
    
    
    
       var employees: [Employee]? {
           didSet {
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
                return employees.count;
           }
           else {
               return 0;
           }
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeAvailableCell;
        if let employees = employees {
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
