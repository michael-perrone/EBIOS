//
//  BcnSelectorTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 1/22/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class BcnSelectorCollectionSelectedCell: UICollectionViewCell {
    
    weak var del: BookingHit?;
     
     var bcn: Int? {
         didSet {
             bcnText.text = String(bcn!);
         }
     }

     
     let bcnText = Components().createSimpleText(text: "");
     
     func layoutCell() {
         contentView.addSubview(bcnText);
         bcnText.centerTo(element: contentView.centerXAnchor);
         bcnText.padTop(from: contentView.topAnchor, num: 5);
         bcnText.setHeight(height: 40);
         bcnText.setWidth(width: 40);
         let tapped = UITapGestureRecognizer(target: self, action: #selector(iveBeenTapped));
         contentView.addGestureRecognizer(tapped);
         bcnText.addGestureRecognizer(tapped);
         bcnText.textAlignment = .center;
         bcnText.backgroundColor = .darkGray2;
         bcnText.textColor = .mainLav;
         contentView.setHeight(height: 40);
         contentView.setWidth(width: 40);
     }
     
     @objc func iveBeenTapped() {
         del?.selectBcn(num: bcn!);
     }
 }
