//
//  ServicesTextTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 9/11/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class ServicesTextTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var services: [String]? = [] {
        didSet {
            self.reloadData();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let services = services {
            return services.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "Cell", for: indexPath);
        if let services = services {
            
            cell.textLabel?.text = services[indexPath.row];
            cell.backgroundColor = .mainLav;
            cell.textLabel?.font = .boldSystemFont(ofSize: 14);
            cell.selectionStyle = .none;
        }
        return cell;
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.plain);
        register(UITableViewCell.self, forCellReuseIdentifier: "Cell");
        backgroundColor = .mainLav;
        delegate = self;
        dataSource = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
