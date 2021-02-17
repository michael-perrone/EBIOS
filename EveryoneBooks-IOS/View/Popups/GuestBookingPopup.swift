//
//  GuestBookingPopup.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/29/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class GuestBookingPopup: UIView {

    var guestNameString: String?;
    
    var guestPhoneNumber: String?;

    let nameTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Full Name", fontSize: 18);
        return uitf;
    }()
    
    lazy var nameInput: UIView = {
        let uiv = Components().createInput(textField: nameTextField, view: nil, width: fullWidth / 1.3);
        return uiv;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero);
        setHeight(height: fullHeight / 3);
        setWidth(width: fullWidth / 1.3);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
