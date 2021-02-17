//
//  EditServicesTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/9/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EditServicesTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var services: [Service]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    weak var otherDelegate: EditServicesDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.plain);
        delegate = self;
        dataSource = self;
        isScrollEnabled = false;
        
        register(EditingServicesCell.self, forCellReuseIdentifier: "H");
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var any = "D";
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let services = services {
            print("INSIDE OF EDITSERVICESTABLE");
            print(services)
            print("below services")
            return services.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "H", for: indexPath) as! EditingServicesCell;
        cell.selectionStyle = .none;
        if let services = self.services {
            cell.service = services[indexPath.row];
            cell.delegate = otherDelegate;
            cell.configureCell()
            cell.neededIndex = indexPath.row;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40;
    }


}
