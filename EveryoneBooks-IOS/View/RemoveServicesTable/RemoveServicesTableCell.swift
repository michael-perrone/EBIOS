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
            serviceText.text = service!.serviceName;
            let actualCostText = String(format: "%.2f", service!.cost);
            let actualCostTextWithDollarSign = "$" + actualCostText;
            costText.text = actualCostTextWithDollarSign;
            print("HELLLLLO")
        }
    }
    
    func configureCell() {
        addSubview(serviceText);
        serviceText.padLeft(from: leftAnchor, num: 5);
        serviceText.padTop(from: topAnchor, num: 2);
        addSubview(costText);
        costText.padRight(from: rightAnchor, num: 10);
        costText.padTop(from: topAnchor, num: 2);
        costText.backgroundColor = .clear;
        serviceText.backgroundColor = .clear;
    }
    
    let serviceText = Components().createSimpleText(text: "");
    
    let costText = Components().createSimpleText(text: "");
    
}
