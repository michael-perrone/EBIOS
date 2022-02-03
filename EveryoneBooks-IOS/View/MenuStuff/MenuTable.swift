//
//  MenuTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/13/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class MenuTable: UITableView, UITableViewDelegate, UITableViewDataSource {
 
    var selectionItems: [SelectionItem];
    
    var cellClickedDelegate: MenuCellClicked?
    
    init(selectionItems: [SelectionItem]) {
        self.selectionItems = selectionItems;
        super.init(frame: CGRect.zero, style: UITableView.Style.plain)
        register(MenuCell.self, forCellReuseIdentifier: "MENUCELL")
        backgroundColor = .mainLav;
        dataSource = self;
        delegate = self;
        isScrollEnabled = false;
    }
    
    
    @objc func logout() {
        cellClickedDelegate?.logout();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectionItems.count > 0 {
            return selectionItems.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = dequeueReusableCell(withIdentifier: "MENUCELL", for: indexPath) as! MenuCell;
        menuCell.selectionItem = selectionItems[indexPath.row];
        menuCell.configureCell();
        menuCell.selectionStyle = .none;
        if let ccd = cellClickedDelegate {
            menuCell.clickedDelegate = ccd;
        }
        return menuCell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectionItems[indexPath.row].title == "Logout" {
            cellClickedDelegate?.logout();
        }
        else {
            cellClickedDelegate?.cellClicked(vc: selectionItems[indexPath.row].vc!);
        }
    }
    
}
