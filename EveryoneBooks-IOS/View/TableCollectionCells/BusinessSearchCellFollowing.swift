//
//  BusinessSearchCellFollowing.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/8/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import Foundation
import UIKit

class BusinessSearchCellFollowing: BusinessSearchCell {
    
    lazy var unFollowButton: UIButton = {
        let uib = Components().createNormalButton(title: "Unfollow");
        uib.setHeight(height: 44);
        uib.setWidth(width: 100);
        uib.backgroundColor = .mainLav;
        uib.addTarget(self, action: #selector(unfollow), for: .touchUpInside)
        return uib;
    }()
    
    @objc func unfollow() {
        let data = ["businessId": bID!, "userId": Utilities().getUserId()!]
        API().post(url: "http://localhost:4000/api/userSubscribe/unfollow", dataToSend: data) { (res) in
            if res["statusCode"] as? Int == 200 {
                DispatchQueue.main.async {
                    self.delegate?.unFollowBusiness(idParameter: self.bID!)
                }
            }
        }
    }
    
    func extra() {
        addSubview(unFollowButton);
        unFollowButton.padBottom(from: bottomAnchor, num: 20);
        unFollowButton.padLeft(from: leftAnchor, num: 20);
        followButton.isHidden = true;
    }
}
