//
//  NoBusinessesFollowingCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/8/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class NoBusinessesFollowingCell: UICollectionViewCell {
    
    private let title: UITextView = {
        let uitv = Components().createNotAsLittleText(text: "You are not following any businesses at this time.", color: .mainLav);
        return uitv;
    }()
    
    func configureCell() {
        contentView.addSubview(title);
        title.padTop(from: contentView.topAnchor, num: 10);
        title.centerTo(element: contentView.centerXAnchor);
        setWidth(width: fullWidth);
        setHeight(height: 100);
    }
}

