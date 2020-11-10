//
//  EditBusinessProfile.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/7/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EditBusinessProfile: UITabBarController {
    
    var message = "";
    
    private let doneButton: UIButton = {
        let uib = Components().createNormalButton(title: "Done");
        uib.setHeight(height: 44);
        uib.setWidth(width: 90);
        uib.addTarget(self, action: #selector(doneHit), for: .touchUpInside)
        return uib;
    }();
    
 
    @objc func doneHit() {
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func helpHit() {
        let editBusinessHelp = EditBusinessHelp();
        editBusinessHelp.modalPresentationStyle = .fullScreen;
        editBusinessHelp.modalTransitionStyle = .crossDissolve;
        self.present(editBusinessHelp, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainLav;
        configureTabs()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        getProfile()
    }
    

    func configureTabs() {
        let addEmployees = Components().createNavBarItemController(image: UIImage(named: "employee"), viewController: AddEmployees(), title: "Employees");
        let addServices = Components().createNavBarItemController(image: UIImage(named: "ds"), viewController: AddServices(), title: "Services")
        let products = Components().createNavBarItemController(image: UIImage(named: "product"), viewController: Products(), title: "Products");
        viewControllers = [addEmployees, addServices, products]
    }
    
    func getProfile() {
        let url = myURL + "businessProfile/myBusinessForProfile";
        
    }
}
