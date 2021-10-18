//
//  ServiceSelectedTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/29/21.
//  Copyright © 2021 Michael Perrone. All rights reserved.
//

import UIKit

class ServiceSelectedTableCell: ServicesSelectCell {
    lazy var minusServiceButton: UIButton = {
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
        addSubview(minusServiceButton);
        minusServiceButton.padTop(from: topAnchor, num: 1);
        minusServiceButton.padRight(from: rightAnchor, num: 0);
        serviceName.textColor = .mainLav;
        serviceName.backgroundColor = .darkGray;
    }
    
    @objc func minusThisService() {
        delegate?.minusService(service: self.service!);
    }
}
