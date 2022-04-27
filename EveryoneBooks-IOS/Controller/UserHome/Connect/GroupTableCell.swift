//
//  GroupTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/11/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class GroupTableCell: UITableViewCell {
    
    weak var joinDel: GroupJoinDelegate?
    
    var group: Group? {
        didSet {
            groupNameText.text = group?.type!;
            groupTimeText.text = group?.time!;
            dateText.text = group?.date!;
        }
    }
    
    private let groupNameText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    private let groupTimeText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    private let dateText = Components().createNotAsLittleText(text: "", color: .mainLav);
    
    private let joinButton: UIButton = {
        let uib = Components().createIncredibleButton(title: "Join Group", width: 120, fontSize: 18, height: 30);
        uib.addTarget(self, action: #selector(joinHit), for: .touchUpInside);
        return uib;
    }();
    
    @objc func joinHit() {
        joinDel?.joinGroup(groupId: group!.id!, price: group!.price!)
    }
    
    
    
    func configureCell() {
        backgroundColor = .mainLav;
        contentView.addSubview(groupNameText);
        groupNameText.padLeft(from: contentView.leftAnchor, num: 5);
        groupNameText.padTop(from: contentView.topAnchor, num: 5);
        contentView.addSubview(groupTimeText);
        groupTimeText.padTop(from: groupNameText.bottomAnchor, num: 5);
        groupTimeText.padLeft(from: groupNameText.leftAnchor, num: 0);
        contentView.addSubview(dateText);
        dateText.padRight(from: contentView.rightAnchor, num: 10);
        dateText.padTop(from: contentView.topAnchor, num: 5);
        contentView.addSubview(joinButton);
        joinButton.padRight(from: contentView.rightAnchor, num: 15);
        joinButton.padTop(from: dateText.bottomAnchor, num: 5);
      
    }
    
}
