//
//  SelectedGenericHorizontalCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/22/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class SelectedGenericHorizontalCell: UICollectionViewCell {
        
    var item: HorItem? {
            didSet {
                textView.text = item?.title;
            }
        }
    
    var index: Int?
        
    weak var del: SelectCell?;
        
    private let textView = Components().createNotAsLittleText(text: "", color: .mainLav);
        
    func configureCell() {
        contentView.addSubview(textView);
        textView.isUserInteractionEnabled = false;
        textView.padTop(from: contentView.topAnchor, num: 0);
        textView.centerTo(element: centerXAnchor);
        backgroundColor = .darkGray2;
        textView.backgroundColor = .darkGray2;
        textView.textColor = .mainLav;
    }
}
