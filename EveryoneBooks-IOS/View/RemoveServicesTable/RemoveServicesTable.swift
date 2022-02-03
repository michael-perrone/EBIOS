//
//  RemoveServicesTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 1/4/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class RemoveServicesTable: UITableView, UITableViewDelegate, UITableViewDataSource {

    weak var deleteDelegate: DeleteServiceProtocol?;
    
    var services: [Service]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: UITableView.Style.insetGrouped);
        dataSource = self;
        delegate = self;
        register(RemoveServicesTableCell.self, forCellReuseIdentifier: "RSTC");
        backgroundColor = .clear;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let services = services {
            return services.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let removeServicesCell = dequeueReusableCell(withIdentifier: "RSTC", for: indexPath) as! RemoveServicesTableCell;
        if let services = services {
            removeServicesCell.service = services[indexPath.row];
            removeServicesCell.configureCell();
        }
        
        return removeServicesCell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let services = services {
            if editingStyle == .delete {
                deleteDelegate?.deleteService(service: services[indexPath.row], indexPath: [indexPath], row: indexPath.row)
            }
        }
    }
}
