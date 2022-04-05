//
//  GenericCollectionHorizontalCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/22/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class GenericCollectionHorizontalCell: UICollectionViewCell {
    
    var item: HorItem? {
        didSet {
            textView.text = item?.title;
        }
    }
    
    var index: Int?;
    
    var selectedCell: Bool = false {
        didSet {
            if selectedCell {
                DispatchQueue.main.async {
                    self.backgroundColor = .darkGray2;
                    self.textView.textColor = .mainLav;
                }
            }
        }
    }
    
    weak var del: SelectCell?;
    
    private let textView = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    func configureCell() {
        contentView.addSubview(textView);
        textView.isUserInteractionEnabled = false;
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        textView.padTop(from: contentView.topAnchor, num: 0);
        textView.centerTo(element: centerXAnchor);
        textView.addGestureRecognizer(tap);
        contentView.addGestureRecognizer(tap);
        addGestureRecognizer(tap);
    }
    
    
    
    @objc func cellTapped() {
        del?.selectCell(index: index!, item: item!);
    }
}
