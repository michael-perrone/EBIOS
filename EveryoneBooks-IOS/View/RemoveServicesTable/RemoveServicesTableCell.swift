//
//  RemoveServicesTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 1/4/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class RemoveServicesTableCell: UITableViewCell {
    
    var service: Service? {
        didSet {
            serviceText.text = Utilities().cutStringIfNeeded(string: service!.serviceName, num: 30);
            let actualCostText = String(format: "%.2f", service!.cost);
            let actualCostTextWithDollarSign = "$" + actualCostText;
            costText.text = actualCostTextWithDollarSign;
        }
    }
    
    func configureCell() {
        addSubview(serviceText);
        serviceText.padLeft(from: leftAnchor, num: 5);
        serviceText.padBottom(from: bottomAnchor, num: 2);
        addSubview(costText);
        costText.padRight(from: rightAnchor, num: 10);
        costText.padTop(from: topAnchor, num: 5);
        costText.backgroundColor = .clear;
        serviceText.backgroundColor = .clear;
        backgroundColor = .mainLav;
    }
    
    let serviceText = Components().createNotAsLittleText(text: "");
    
    let costText = Components().createNotAsLittleText(text: "");
    
}
