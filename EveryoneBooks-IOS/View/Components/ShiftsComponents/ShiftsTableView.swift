//
//  ShiftsTableView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/12/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class ShiftsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
   
    var shifts: [Shift]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
        
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame:frame, style: UITableView.Style.grouped);
        register(ShiftsTableViewCell.self, forCellReuseIdentifier: "celly2baby");
        dataSource = self;
        delegate = self;
        backgroundColor = .mainLav;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let shifts = shifts {
            return shifts.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celly2baby", for: indexPath) as! ShiftsTableViewCell;
        
        if let shifts = shifts {
            cell.shift = shifts[indexPath.row];
            cell.selectionStyle = .none
            cell.configure();
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let shifts = shifts {
            if editingStyle == .delete {
                print(shifts[indexPath.row].id)
            }
        }
    }
}
