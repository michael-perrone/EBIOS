//
//  ServiesChosenTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/25/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class ServicesChosenTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var backColor: UIColor?
    
    var fontSize: CGFloat?
    
    var servicesChosen: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }

 override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame:frame, style: UITableView.Style.grouped);
        dataSource = self;
        delegate = self;
        register(UITableViewCell.self, forCellReuseIdentifier: "serviceChosenCell");
        backgroundColor = .green;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let services = servicesChosen {
             return services.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.tableFooterView = UIView(frame: frame)
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceChosenCell", for: indexPath);
        cell.backgroundColor = .mainLav;
        if let services = servicesChosen {
            cell.selectionStyle = .none
            cell.textLabel?.text = services[indexPath.row];
            if let font = fontSize {
                cell.textLabel?.font = .boldSystemFont(ofSize: font)
            }
            if let background = backColor {
                cell.backgroundColor = background;
            }
        }
        
        return cell;
    }
}
