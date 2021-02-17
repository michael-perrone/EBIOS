//
//  DropDown.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/16/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol ServicesTableDelegate: ServicesTable {
    func addService(service: Service)
    func minusService(service: Service)
}

class ServicesTable: UITableView, UITableViewDelegate, UITableViewDataSource, ServicesTableDelegate  {
   
    func minusService(service: Service) {
        selectedServices.removeAll(where: { (eachService) -> Bool in
           return service.id == eachService.id
        })
    }
    
    func addService(service: Service) {
        selectedServices.append(service)
    }

    var selectedServices: [Service] = [];
    
    var data: [Service]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.grouped)
        delegate = self;
        dataSource = self;
        register(ServicesSelectCell.self, forCellReuseIdentifier: "Cell");
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unwrappedData = data {
            return unwrappedData.count;
        }
        else {
            return 0;
        }
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ServicesSelectCell;
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        if let data = data {
            cell.service = data[indexPath.row];
            cell.delegate = self;
            cell.configureCell()
            cell.selectionStyle = .none;
        }
        return cell;
    }

}
