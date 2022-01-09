//
//  EmployeeAddTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/12/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeeAddTable: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var employees: [Employee]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    var pending: Bool?;
    
    var deleteDelegate: DeleteEmployeesProtocol?;
    
    public let table: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: UITableView.Style.insetGrouped);
        return table;
    }();

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: UITableView.Style.insetGrouped);
        dataSource = self;
        delegate = self;
        register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        backgroundColor = .mainLav;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let employees = employees {
            return employees.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        if let employees = employees {
            if employees.count > 0 {
                cell.selectionStyle = .none
                cell.textLabel?.text = employees[indexPath.row].fullName;
            }
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let employeesIn = employees {
            if let pending = pending {
                if employeesIn.count > 0 {
                    if editingStyle == .delete {
                        if pending {
                            deleteDelegate?.deleteEmployeeFromPending(employee: employeesIn[indexPath.row], indexPath: [indexPath], row: indexPath.row);
                        }
                        else {
                            deleteDelegate?.deleteEmployeeFromWorking(employee: employeesIn[indexPath.row], indexPath: [indexPath], row: indexPath.row);
                        }
                    }
                }
            }
        }
    }
}
