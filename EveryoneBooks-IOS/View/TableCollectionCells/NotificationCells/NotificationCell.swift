//
//  NotificationCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 8/2/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class NotificationCell: UICollectionViewCell {
    
    var noti: RequestAnswerNotification?;
    
     let notiMessage: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        uitv.textColor = .black;
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
     let dateOfNoti: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 12);
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
     let openEnv: UIImageView = {
        let uiiv = UIImageView();
        uiiv.image = UIImage(named: "open-env");
        uiiv.setHeight(height: 32);
        uiiv.setWidth(width: 32)
        return uiiv;
    }()
    
     let closeEnv: UIImageView = {
          let uiiv = UIImageView();
          uiiv.image = UIImage(named: "closed-env");
          uiiv.setHeight(height: 32);
          uiiv.setWidth(width: 32)
          return uiiv;
      }()

}
