//
//  NoPastBookingsCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/2/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class NoPastBookingsCell: UITableViewCell {
    
    private let noBookingsText = Components().createSimpleText(text: "You have no past bookings!");

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(noBookingsText);
        noBookingsText.padTop(from: contentView.topAnchor, num: 2);
        noBookingsText.centerTo(element: contentView.centerXAnchor);
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
