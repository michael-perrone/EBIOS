//
//  Menu.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/13/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class Menu: UIView {
    
    var selectionItems: [SelectionItem];
    
    var cancelDelegate: SlideTabBarProtocol?;
    
    var cellClickedDelegate: MenuCellClicked? {
        didSet {
            self.menuTable.cellClickedDelegate = self.cellClickedDelegate;
        }
    }
    
    init(selectionItems: [SelectionItem]) {
        self.selectionItems = selectionItems;
        super.init(frame: CGRect.zero);
        configueMenu()
        backgroundColor = .white;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nameText: UILabel = {
        let uitv = UILabel()
        uitv.backgroundColor = .white;
        uitv.font = .systemFont(ofSize: 20);
        if Utilities().getAdminToken() != "nil" {
            uitv.text = Utilities().decodeAdminToken()!["bn"] as! String;
        }
        else if Utilities().getToken() != "nil" {
            uitv.text = Utilities().decodeUserToken()!["userName"] as! String;
        }
        else if Utilities().getEmployeeToken() != "nil" {
             uitv.text = Utilities().decodeEmployeeToken()!["fullName"] as! String;
        }
        
        return uitv;
    }()
    
    lazy var menuTable: MenuTable = {
        let mt = MenuTable(selectionItems: selectionItems)
        return mt;
    }()
    
    private let cancelButton: UIButton = {
        let uib = Components().createXButton();
        uib.addTarget(self, action: #selector(slideBack), for: .touchUpInside);
        return uib;
    }()
    
    private let rightBorder = Components().createBorder(height: fullHeight, width: 1.2, color: .gray);
    
    @objc func slideBack() {
        print("does this work")
        cancelDelegate?.slideBack()
    }
    
    func configueMenu() {
        addSubview(menuTable);
        menuTable.setWidth(width: fullWidth / 1.45);
        menuTable.setHeight(height: CGFloat(selectionItems.count * 48));
        menuTable.padTop(from: safeAreaLayoutGuide.topAnchor, num: 50);
        menuTable.padLeft(from: leftAnchor, num: 0);
       
        addSubview(cancelButton);
        cancelButton.padRight(from: rightAnchor, num: 7);
        cancelButton.padTop(from: topAnchor, num: fullHeight * fullHeight * fullHeight / 20000000);
        cancelButton.setWidth(width: 40);
        addSubview(nameText);
        nameText.padTop(from: safeAreaLayoutGuide.topAnchor, num: 16);
        nameText.padLeft(from: leftAnchor, num: 16);
        nameText.padRight(from: cancelButton.leftAnchor, num: 10)
        addSubview(rightBorder);
        rightBorder.padRight(from: rightAnchor, num: 1.2);
        rightBorder.padTop(from: topAnchor, num: 0);
    }

}
