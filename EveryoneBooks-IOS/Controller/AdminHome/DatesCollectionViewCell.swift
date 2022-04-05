//
//  DatesCollectionViewCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/14/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class DatesCollectionViewCell: UICollectionViewCell {
    
    var date: String? {
        didSet {
            dateText.text = date!;
        }
    }
    
    private let dateText = Components().createNotAsLittleText(text: "", color: .mainLav);

    func setupCell() {
        contentView.addSubview(dateText);
        dateText.padTop(from: contentView.topAnchor, num: 1);
        dateText.padLeft(from: contentView.leftAnchor, num: 2);
    }

}
