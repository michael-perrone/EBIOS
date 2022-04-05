//
//  UserHomeController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/1/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class UserProfileController: UIViewController {
    
    private let exitButton: UIButton = {
        let exitButton = Components().createXButton();
        exitButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside);
        return exitButton;
    }();
    
    @objc func dismissMe() {
        self.dismiss(animated: true, completion: nil);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainLav;
        setup();
    }
    
    func setup() {
        view.addSubview(exitButton);
        exitButton.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 20);
        exitButton.padRight(from: view.rightAnchor, num: 20);
    }
}
