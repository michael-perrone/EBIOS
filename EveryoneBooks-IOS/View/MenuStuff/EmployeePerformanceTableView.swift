//
//  EmployeePerformanceCollectionView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/2/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation
import UIKit

class EmployeePerformanceTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain);
        register(AdminEmployeePerformanceCell.self, forCellReuseIdentifier: "dc");
        backgroundColor = .mainLav;
        delegate = self;
        dataSource = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var performanceData: [[String: Any]]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.performanceData {
            return data.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "dc", for: indexPath) as! AdminEmployeePerformanceCell;
        cell.selectionStyle = .none;
        if let data = self.performanceData {
            cell.data = data[indexPath.row];
            cell.configureCell()
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230;
    }
}
