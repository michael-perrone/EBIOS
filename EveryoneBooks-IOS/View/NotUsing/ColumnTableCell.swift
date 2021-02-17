//
//  ColumnTableCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/2/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class ColumnTableCell: UITableViewCell {

     private let timeText: UITextView = {
         let uitv = Components().createSimpleText(text: "");
         uitv.font = .boldSystemFont(ofSize: 18);
         return uitv;
     }()
    
    var time: String? {
        didSet {
            timeText.text = time;
        }
    }
    
    func setTime(time: String) {
          self.time = time;
      }
      
      func getTime() -> String {
          guard let time = time else {return ""};
          return time;
      }

    var booked: Bool? {
        didSet {
            if booked! {
                backgroundColor = .red;
            }
            else {
                backgroundColor = .literGray;
            }
        }
    }
    
    
    
}
