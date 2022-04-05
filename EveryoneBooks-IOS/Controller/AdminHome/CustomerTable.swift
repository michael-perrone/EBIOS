//
//  CustomerTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/23/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class CustomerTable: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var customers: [Customer]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    weak var del: CustomerTableDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain);
        register(CustomerTableCell.self, forCellReuseIdentifier: "customerCell");
        delegate = self;
        dataSource = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let customers = customers {
            return customers.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! CustomerTableCell;
        if let customers = customers {
            cell.customer = customers[indexPath.row];
            print(cell.customer);
            cell.setupCell()
            cell.selectionStyle = .none;
            return cell;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let customers = customers {
            if editingStyle == .delete {
                del?.deleteCustomer(customerId: customers[indexPath.row].id!, index: indexPath.row)
            }
        }
    }
}

