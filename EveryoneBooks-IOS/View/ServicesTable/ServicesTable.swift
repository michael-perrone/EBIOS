//
//  DropDown.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/16/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol ServicesTableDelegate: ServicesTable {
    func addService(service: Service)
    func minusService(service: Service)
}

class ServicesTable: UITableView, UITableViewDelegate, UITableViewDataSource, ServicesTableDelegate  {
   
    func minusService(service: Service) {
        selectedServices.removeAll(where: { (eachService) -> Bool in
           return service.id == eachService.id
        })
        reloadData();
    }
    
    func addService(service: Service) {
        selectedServices.append(service);
        reloadData();
    }
    /// Delegate Functions
    
    var shortText: Bool = false;

    var selectedServices: [Service] = [];
    
    var data: [Service]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    var unselectedCellBackgroundColor: UIColor?;
    
    var unselectedCellTextColor: UIColor?;
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.grouped)
        delegate = self;
        dataSource = self;
        register(ServiceSelectedTableCell.self, forCellReuseIdentifier: "SC");
        register(ServiceUnselectedTableCell.self, forCellReuseIdentifier: "UC");
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unwrappedData = data {
            return unwrappedData.count;
        }
        else {
            return 0;
        }
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = data {
            
            if selectedServices.contains(where: { (service) -> Bool in
                service.id == data[indexPath.row].id
            }) {
                let unSelectedCell = dequeueReusableCell(withIdentifier: "SC", for: indexPath) as! ServiceSelectedTableCell;
                unSelectedCell.service = data[indexPath.row];
                unSelectedCell.delegate = self;
                if shortText {
                    unSelectedCell.shortText = true;
                }
                unSelectedCell.configureName();
                unSelectedCell.configureColor();
                unSelectedCell.selectionStyle = .none;
                return unSelectedCell;
            }
            else {
                let selectedCell = dequeueReusableCell(withIdentifier: "UC", for: indexPath) as! ServiceUnselectedTableCell;
                if let bColorComingIn = unselectedCellBackgroundColor {
                    selectedCell.bColor = bColorComingIn;
                }
                if let tColorComingIn = unselectedCellTextColor {
                    selectedCell.tColor = tColorComingIn;
                }
                
                selectedCell.service = data[indexPath.row];
                selectedCell.delegate = self;
                if shortText {
                    selectedCell.shortText = true;
                }
                selectedCell.configureName();
                selectedCell.configureColor();
                selectedCell.selectionStyle = .none;
                return selectedCell;
            }
        }
        else {
            return UITableViewCell();
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedServices.contains(where: { service in
            service.id == data![indexPath.row].id
        }) {
            minusService(service: data![indexPath.row]);
        }
        else {
            addService(service: data![indexPath.row])
        }
    }
}
