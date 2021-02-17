//
//  UserHomeViewController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/5/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class UserHomeViewController: SlideTabBarController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTabs()
        // Do any additional setup after loading the view.
    }
    

    func configureUI() {
        view.backgroundColor = .literGray;
     }
     
     func configureTabs() {
        let businessSearch = Components().createNavBarItemController(image: UIImage(named: "business-search"), viewController: BusinessSearch(), title: "Search");
        let businessesFollowing = BusinessesFollowingCollection(collectionViewLayout: UICollectionViewFlowLayout());
        businessesFollowing.delto = self;
        let businessFollowing = Components().createNavBarItemController(image: UIImage(named: "business-tab-bar"), viewController: businessesFollowing, title: "Following");
        let userBookingsCollection = UserBookings(collectionViewLayout: UICollectionViewFlowLayout());
        let userBookings = Components().createNavBarItemController(image: UIImage(named: "service-bell-tab-bar"), viewController: userBookingsCollection, title: "Bookings")
        viewControllers = [businessSearch, userBookings, businessFollowing];
        view.setHeight(height: UIScreen.main.bounds.height);
        view.setWidth(width: UIScreen.main.bounds.width)
        tabBar.backgroundColor = .mainLav;
        tabBar.barTintColor = .mainLav;
    }
}



