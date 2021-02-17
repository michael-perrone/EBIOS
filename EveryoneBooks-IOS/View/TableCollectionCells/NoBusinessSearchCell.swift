//
//  NoBusinessSearchCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/23/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class NoBusinessSearchCell: UICollectionViewCell {
    
    private let text: UITextView = {
        let uitv = Components().createSimpleText(text: "No Businesses were found in your search.");
        uitv.setWidth(width: fullWidth / 1.2);
        return uitv;
    }()
    
    func configureCell() {
        contentView.addSubview(text);
        text.padTop(from: contentView.topAnchor, num: 6);
        text.centerTo(element: contentView.centerXAnchor);
    }
    
    
}
