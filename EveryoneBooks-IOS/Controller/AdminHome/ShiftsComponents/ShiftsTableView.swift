//
//  ShiftsTableView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/12/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class ShiftsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var bct: String? {
        didSet {
            print(bct)
        }
    }
   
    var shifts: [Shift]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    weak var editingDelegate: EditingProtocol?;
        
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
            cell.bct = self.bct;
            cell.shift = shifts[indexPath.row];
            cell.selectionStyle = .none
            cell.configure();
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { action, view, completion in
            if let shifts = self.shifts {
                self.editingDelegate?.editShift(shift: shifts[indexPath.row]);
            }
            completion(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            if let shifts = self.shifts {
                self.removeShift(shiftId: shifts[indexPath.row].id, index: indexPath.row)
            }
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    
    // MARK: - Helper
    
    func removeShift(shiftId: String, index: Int) {
        API().post(url: myURL + "shifts/deleteOne", headerToSend: Utilities().getAdminToken(), dataToSend: ["shiftId": shiftId]) { (res) in
            if res["statusCode"] as! Int == 200 { 
                self.shifts?.remove(at: index);
            }
            else {
                print("uh oh")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74;
    }
}
