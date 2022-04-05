//
//  CustomerTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/23/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class CustomerTableCell: UITableViewCell {
    
    var customer: Customer? {
        didSet {
            customerText.text = customer?.name;
        }
    }
    
    private let customerText = Components().createNotAsLittleText(text: "", color: .mainLav);

    func setupCell() {
        contentView.addSubview(customerText);
        customerText.padLeft(from: contentView.leftAnchor, num: 15);
        customerText.padTop(from: contentView.topAnchor, num: 3);
        contentView.setWidth(width: fullWidth)
        backgroundColor = .mainLav;
    }

}
