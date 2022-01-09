//
//  ProductSelectedTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/27/21.
//  Copyright © 2021 Michael Perrone. All rights reserved.
//

import UIKit

class ProductSelectedTableCell: ProductsSelectCell {
    
    lazy var minusProductButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainLav, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)]), for: .normal);
        uib.setHeight(height: 34);
        uib.setWidth(width: 34);
        uib.showsTouchWhenHighlighted = true;
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(minusThisService), for: .touchUpInside);
        return uib;
    }()
    
    func configureColor() {
        backgroundColor = .darkGray;
        addSubview(minusProductButton);
        minusProductButton.padTop(from: topAnchor, num: 1);
        minusProductButton.padRight(from: rightAnchor, num: 0);
        productName.textColor = .mainLav;
        productName.backgroundColor = .darkGray;
    }
    
    @objc func minusThisService() {
        delegate?.minusProduct(product: self.product!);
    }
}
