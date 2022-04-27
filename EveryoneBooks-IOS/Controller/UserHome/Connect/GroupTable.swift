//
//  GroupTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/11/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class GroupTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var groups: [Group]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    var joinDelegate: GroupJoinDelegate?;
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain);
        dataSource = self;
        delegate = self;
        register(GroupTableCell.self, forCellReuseIdentifier: "GroupTableCell");
        allowsSelection = false;
        delaysContentTouches = false;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let groups = groups {
            return groups.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "GroupTableCell", for: indexPath) as! GroupTableCell;
        if let groups = groups {
            if let joinDelegate = joinDelegate {
                cell.joinDel = joinDelegate;
            }
            cell.group = groups[indexPath.row];
            cell.configureCell();
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("yoooo")
        }
    }
}
