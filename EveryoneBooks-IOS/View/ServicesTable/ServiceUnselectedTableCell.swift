//
//  ServicesUnselectedTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/29/21.
//  Copyright © 2021 Michael Perrone. All rights reserved.
//

import UIKit

class ServiceUnselectedTableCell: ServicesSelectCell {
    
    var bColor: UIColor?;
    var tColor: UIColor?
    
    lazy var addService: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)]), for: .normal);
        uib.setHeight(height: 34);
        uib.setWidth(width: 34);
        uib.showsTouchWhenHighlighted = true;
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(addThisService), for: .touchUpInside);
        return uib;
    }()
    
    func configureColor() {
        if let bColorHere = bColor {
            backgroundColor = bColorHere;
        }
        else {
            backgroundColor = .literGray;
        }
        if let tColorHere = tColor {
            serviceName.backgroundColor = tColorHere;
        }
        else {
            backgroundColor = .mainLav;
        }
        addSubview(addService);
        addService.padTop(from: topAnchor, num: 4);
        addService.padRight(from: rightAnchor, num: 0);
    }
    
    
    @objc func addThisService() {
            delegate?.addService(service: self.service!);
    }
}
