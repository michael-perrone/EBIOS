//
//  ServicesDisplayTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/1/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class ServicesDisplayTable: UITableView, UITableViewDataSource {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: UITableView.Style.insetGrouped);
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var services: [Service]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    func configureView() {
        backgroundColor = .clear;
        setWidth(width: UIScreen.main.bounds.width / 1.3);
        setHeight(height: 260);
        dataSource = self;
        register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let services = services {
            if services.count > 0 {
                return services.count;
            }
            else {
                return 0;
            }
        }
            else {
                return 0;
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        if let services = services {
            if services.count > 0 {
                cell.selectionStyle = .none
                cell.textLabel?.text = services[indexPath.row].serviceName;
            }
        }
        return cell;
    }

}
