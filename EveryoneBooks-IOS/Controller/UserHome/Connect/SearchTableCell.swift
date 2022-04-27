//
//  SearchTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/10/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {
        
    var name: String? {
        didSet {
            nameText.text = name;
        }
    }
    
    private let nameText = Components().createNotAsLittleText(text: "");
    
    func configureCell() {
        contentView.addSubview(nameText);
        nameText.padTop(from: contentView.topAnchor, num: 8);
        nameText.padLeft(from: contentView.leftAnchor, num: 10);
    }
}
