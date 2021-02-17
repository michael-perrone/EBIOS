//
//  ProductTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/27/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation
import UIKit

class ProductTableCell: UITableViewCell {
    
    var product: Product? {
        didSet {
            productNameText.text = product!.name;
            productPriceText.text = "$" + String(product!.price);
        }
    }
    
    private let productNameText: UILabel = {
        let uil = UILabel();
        uil.numberOfLines = 1;
        uil.font = .systemFont(ofSize: 20);
        return uil;
    }()
    
    private let productPriceText: UILabel = {
        let uil = UILabel()
        uil.setWidth(width: 85);
        uil.numberOfLines = 1;
        uil.font = .systemFont(ofSize: 20);
        return uil;
    }();
    
    func configureCell() {
        contentView.addSubview(productNameText);
        productNameText.padLeft(from: contentView.leftAnchor, num: 10);
        productNameText.padTop(from: contentView.topAnchor, num: 8);
        backgroundColor = .white;
        contentView.addSubview(productPriceText);
        productPriceText.padRight(from: contentView.rightAnchor, num: 10);
        productPriceText.padTop(from: contentView.topAnchor, num: 8);
        productNameText.padRight(from: productPriceText.leftAnchor, num: 8);
    }
}
