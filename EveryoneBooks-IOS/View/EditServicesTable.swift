//
//  EditServicesTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/9/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EditServicesTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var services: [Service]? {
        didSet {
            self.reloadData();
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.insetGrouped);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var any = "D";
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let services = services {
            return services.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: any, for: indexPath) as! EditingServicesCell;
        if let services = self.services {
            cell.service = services[indexPath.row];
        }
        return cell;
    }

}
