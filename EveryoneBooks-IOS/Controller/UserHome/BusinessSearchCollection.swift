//
//  BusinessSearchCollection.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/21/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol BusinessSearchDelegate: BusinessSearchCollection {
    func showBusiness(bpId: String)
    func followBusiness(index: Int)
    func unFollowBusiness(idParameter: String)
    func goToBook(business: Business)
}

class BusinessSearchCollection: UICollectionViewController, BusinessSearchDelegate  {
    
    func showBusiness(bpId: String) {
        let bpController = BusinessPageController();
        bpController.businessId = bpId;
        let nav = UINavigationController(rootViewController: bpController);
        nav.modalPresentationStyle = .fullScreen;
        nav.modalTransitionStyle = .crossDissolve;
        self.present(nav, animated: true, completion: nil);
    }
    
    func goToBook(business: Business) {
        let userBookingSomething = UserBookingSomething();
        userBookingSomething.comingFromBusinessPage = false;
        userBookingSomething.business = business;
        navigationController?.pushViewController(userBookingSomething, animated: true);
    }
    
    func followBusiness(index: Int) {
        businessesFollowing?.append((businesses![index].id)!);
    }
    
    func unFollowBusiness(idParameter: String) {
        businessesFollowing?.removeAll(where: { (id) -> Bool in
            return id == idParameter;
        })
    }
    
    var businesses: [Business]? {
        didSet {
            getFollowing()
        }
    }
    
    var businessesFollowing: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData();
            }
        }
    }
    
    lazy var xButton: UIButton = {
        let uib = Components().createXButton();
        uib.addTarget(self, action: #selector(cancelButton), for: .touchUpInside);
        return uib;
    }()
    
    @objc func cancelButton() {
        self.dismiss(animated: true, completion: nil);
    }
   
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        collectionView.register(BusinessSearchCell.self, forCellWithReuseIdentifier: "BusinessSearchCell");
        collectionView.register(NoBusinessSearchCell.self, forCellWithReuseIdentifier: "NF");
        collectionView.backgroundColor = .mainLav;
        navigationController?.navigationBar.barTintColor = .mainLav;
        let logoView = UIImageView(image: UIImage(named: "logo-small"));
        logoView.setHeight(height: 36);
        logoView.setWidth(width: 36);
        navigationItem.titleView = logoView;
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: xButton);
        
    }

    func getFollowing() {
        API().get(url: "http://localhost:4000/api/userProfile/following", headerToSend: Utilities().getToken()) { (res) in
            guard let businessesFollowingBack = res["businessesFollowing"] as? [String] else {return};
            var realBusinessesFollowing: [String] = [];
            var businessesArray: [String] = [];
            for business in self.businesses! {
                businessesArray.append(business.id as! String);
            }
            for businessFollowing in businessesFollowingBack {
                if businessesArray.contains(businessFollowing) {
                    realBusinessesFollowing.append(businessFollowing);
                }
            }
            self.businessesFollowing = businessesFollowingBack;
        }
    }
}

extension BusinessSearchCollection {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let businesses = businesses {
            if businesses.count == 0 {
                return 1;
            }
            else {
                return businesses.count;
            }
    }
        return 1;
}

override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessSearchCell", for: indexPath) as! BusinessSearchCell;
    if let businesses = businesses {
        if businesses.count == 0 {
            let notFollowingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NF", for: indexPath) as! NoBusinessSearchCell;
            notFollowingCell.configureCell();
            return notFollowingCell;
        }
        if let businessesFollowing = self.businessesFollowing {
            if businessesFollowing.count == 0 {
                cell.following = false;
            }
            else {
                if businessesFollowing.contains(businesses[indexPath.row].id!)  {
                        cell.following = true;
                    }
                    
                else {
                        cell.following = false;
                }
            }
        }
        cell.webText.text = businesses[indexPath.row].website;
        cell.phoneText.text = businesses[indexPath.row].phone;
        cell.businessName.text = businesses[indexPath.row].nameOfBusiness;
        cell.streetText.text = businesses[indexPath.row].street;
        cell.cityText.text = businesses[indexPath.row].city ;
        cell.stateText.text = businesses[indexPath.row].state ;
        cell.zipText.text = businesses[indexPath.row].zip;
        cell.bID = businesses[indexPath.row].id as! String;
        cell.business = businesses[indexPath.row];
        cell.index_ = indexPath.row;
        cell.configureView();
        cell.delegate = self;
    }
    return cell;
    }
}

extension BusinessSearchCollection: UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 310);
    }
}



