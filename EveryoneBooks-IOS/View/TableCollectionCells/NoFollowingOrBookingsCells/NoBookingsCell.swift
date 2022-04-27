//
//  NoBookingsCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/10/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//
import UIKit

class NoBookingsCell: UICollectionViewCell {
    
    private let title: UITextView = {
        let uitv = Components().createNotAsLittleText(text: "You do not have any bookings at this time", color: .mainLav);
        
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
