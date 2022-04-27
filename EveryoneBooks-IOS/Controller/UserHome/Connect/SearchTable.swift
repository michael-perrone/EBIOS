//
//  SearchTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/10/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class SearchTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var users: [Customer]?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain);
        register(SearchTableCell.self, forCellReuseIdentifier: "STC");
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = users {
            return users.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "STC", for: indexPath) as! SearchTableCell;
        cell.configureCell();
        return cell;
    }
}
