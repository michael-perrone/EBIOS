//
//  EmployeeAvailableCellTableViewCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 7/19/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EmployeeAvailableCell: UITableViewCell {
    
    var employee: Employee? {
        didSet {
            employeeNameText.text = employee?.fullName;
        }
    }
    
    weak var delegate: EmployeeTableViewDelegate?;
    
    private let employeeNameText: UITextView = {
        let employeeNameText = Components().createSimpleText(text: "");
        employeeNameText.font = .boldSystemFont(ofSize: 18);
        employeeNameText.backgroundColor = .mainLav;
        return employeeNameText;
    }()
    
    lazy var bookButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.tintColor = .black;
        uib.setAttributedTitle(NSAttributedString(string: "Book", attributes: [NSAttributedString.Key.font :  UIFont.boldSystemFont(ofSize: 18)]), for: .normal)
        uib.addTarget(self, action: #selector(bookService), for: .touchUpInside);
        uib.showsTouchWhenHighlighted = true;
        return uib;
    }()
    
    @objc func bookService() {
        delegate?.bookEmployee(employeeId: self.employee!.id);
    }
    
    
    func configureCell() {
        backgroundColor = .mainLav;
        addSubview(employeeNameText);
        employeeNameText.padTop(from: topAnchor, num: 8);
        employeeNameText.padLeft(from: leftAnchor, num: 25);
        addSubview(bookButton)
        bookButton.padRight(from: rightAnchor, num: 25);
        bookButton.padTop(from: topAnchor, num: 8);
    }
}
