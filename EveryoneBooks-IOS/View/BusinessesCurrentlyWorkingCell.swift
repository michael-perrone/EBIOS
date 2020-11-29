//
//  BusinessesWorkingAtCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/23/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class BusinessesCurrentlyWorkingCell: UICollectionViewCell {
    
    var business: Business? {
        didSet {
            businessNameText.text = self.business!.nameOfBusiness;
        }
    }
    
    var index: Int?;
    
    weak var delegate: EmployeeProfileDelegate?;
    
    private var businessNameText = Components().createSimpleText(text: "");
    
    lazy var leaveButton: UIButton = {
        let uib = UIButton(type: .system);
        let attributedTitle = NSAttributedString(string: "X", attributes: [.font : UIFont(name: "MarkerFelt-Wide", size: 40)]);
        uib.setAttributedTitle(attributedTitle, for: .normal);
        uib.showsTouchWhenHighlighted = true;
        uib.setHeight(height: 35
        );
        uib.setWidth(width: 35);
        uib.tintColor = .red;
        uib.addTarget(self, action: #selector(leaveBusiness), for: .touchUpInside);
        return uib;
    }()
    
    @objc func leaveBusiness() {
        delegate!.leaveBusiness(bId: business!.id!, businessName: business!.nameOfBusiness!, index: index!);
    }
    
    func configureLayout() {
        contentView.addSubview(businessNameText);
        businessNameText.padLeft(from: contentView.leftAnchor, num: fullWidth / 10);
        businessNameText.padTop(from: contentView.topAnchor, num: 12);
        contentView.addSubview(leaveButton);
        leaveButton.padTop(from: contentView.topAnchor, num: 12);
        leaveButton.padRight(from: contentView.rightAnchor, num: 25);
    }
}
