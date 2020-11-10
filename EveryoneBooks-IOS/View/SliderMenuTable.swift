//
//  SliderMenuTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/2/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class SliderMenuTable: UITableView, UITableViewDataSource, UITableViewDelegate {
 
    var items: [SelectionItem]?
    
   // var otherDelegate: SliderMenuDelegate?;

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.plain);
        register(SliderMenuCell.self, forCellReuseIdentifier: "S");
        dataSource = self;
        delegate = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items {
            return items.count;
        }
        else {
            return 0;
        }
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "S", for: indexPath) as! SliderMenuCell;
        if let items = items {
            cell.item = items[indexPath.row];
        }
      //  if let other = self.otherDelegate {
     //       cell.delegate = other;
     //   }
        return cell;
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48;
    }
    
}
