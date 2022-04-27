//
//  ConnectCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/8/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class ConnectCell: UICollectionViewCell {
    
    lazy var recommendButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setImage(UIImage(named: "recodo"), for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(recommend), for: .touchUpInside);
        return uib;
    }()
    
    lazy var inviteButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setImage(UIImage(named: "inv"), for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(recommend), for: .touchUpInside);
        return uib;
    }()
    
    @objc func recommend() {
        print("recommended");
    }
    
    func configCell() {
        backgroundColor = .mainLav;
        contentView.addSubview(inviteButton);
        inviteButton.padBottom(from: contentView.bottomAnchor, num: 2)
        inviteButton.padRight(from: contentView.rightAnchor, num: 20);
        contentView.addSubview(recommendButton);
        recommendButton.padBottom(from: contentView.bottomAnchor, num: 2)
        recommendButton.padRight(from: inviteButton.leftAnchor, num: 40);
    }
    
}
