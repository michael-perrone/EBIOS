//
//  BusinessSearchCollection.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/21/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol OtherCollectionViewCellDelegate: BusinessesFollowingCollection {
    func showBusiness(bpId: String)
    
    func removeBusiness(index: Int);
    
    func bookAtBusiness(business: Business)
}

class BusinessesFollowingCollection: UICollectionViewController, OtherCollectionViewCellDelegate {

    func bookAtBusiness(business: Business) {
        let userBookingSomething = UserBookingSomething();
        userBookingSomething.comingFromBusinessPage = false;
        userBookingSomething.business = business;
        delto?.hideWheel()
        navigationController?.pushViewController(userBookingSomething, animated: true);
    }
    
    func removeBusiness(index: Int) {
        businesses?.remove(at: index)
    }
    
    func showBusiness(bpId: String) {
        let bpController = BusinessPageController();
        bpController.businessId = bpId;
        let nav = UINavigationController(rootViewController: bpController);
        nav.modalPresentationStyle = .fullScreen;
        nav.modalTransitionStyle = .crossDissolve;
        self.present(nav, animated: true, completion: nil);
    }
    
    lazy var barButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setImage(UIImage(named: "business-search"), for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(goToBusinesSearch), for: .touchUpInside);
        return uib;
    }()
    
    @objc func goToBusinesSearch() {
        let businessSearch = Components().createNavBarItemController(image: UIImage(named: "business-search"), viewController: BusinessSearch(), title: "Search");
        self.present(businessSearch, animated: true, completion: nil);
    }
    
    var delto: HideWheel?;
    
    var businesses: [Business]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
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
   
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        self.getFollowing();
        if let delto = delto {
            self.delto?.showWheel()
        }
    }
    
    func configureUI() {
        collectionView.register(BusinessesFollowingCollectionViewCell.self, forCellWithReuseIdentifier: "BusinessFollowingCell");
        collectionView.register(NoBusinessesFollowingCell.self, forCellWithReuseIdentifier: "NoFollowingCell");
        collectionView.backgroundColor = .mainLav;
        navigationController?.navigationBar.backgroundColor = .mainLav;
        navigationController?.navigationBar.barTintColor = .mainLav;
        navigationItem.title = "Following";
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton);
    }

    func getFollowing() {
            API().get(url: "http://localhost:4000/api/userProfile/followingForTab", headerToSend: Utilities().getToken()) { (res) in
                guard let businessesFollow = res["businessesFollowing"] as? [[String: Any]] else {return}
                var businessesArray: [Business] = [];
                for businessFollowing in businessesFollow {
                    let newBusiness = Business(dic: businessFollowing);
                    businessesArray.append(newBusiness);
            }
                self.businesses = businessesArray;
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let businesses = businesses {
        if businesses.count == 0 {
            return 1;
        }
        else {
            return businesses.count;
        }
    }
    else {
        return 1;
    }
}
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let businesses = businesses {
            if businesses.count == 0 {
                let noBusinessesFollowingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoFollowingCell", for: indexPath) as! NoBusinessesFollowingCell;
                noBusinessesFollowingCell.configureCell()
                return noBusinessesFollowingCell;
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessFollowingCell", for: indexPath) as! BusinessesFollowingCollectionViewCell;
                cell.webText.text = businesses[indexPath.row].website;
                cell.phoneText.text = businesses[indexPath.row].phone;
                cell.businessName.text = businesses[indexPath.row].nameOfBusiness;
                cell.streetText.text = businesses[indexPath.row].street;
                cell.cityText.text = businesses[indexPath.row].city;
                cell.stateText.text = businesses[indexPath.row].state;
                cell.zipText.text = businesses[indexPath.row].zip;
                cell.bID = businesses[indexPath.row].id;
                cell.business = businesses[indexPath.row];
                cell.configureView();
                cell.delegate = self;
                cell.index_ = indexPath.row;
                return cell;
            }
        }
        else {
            print("anything")
        }
        let noBusinessesFollowingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoFollowingCell", for: indexPath) as! NoBusinessesFollowingCell;
        noBusinessesFollowingCell.configureCell()
        return noBusinessesFollowingCell;
    }
}

extension BusinessesFollowingCollection: UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 310);
    }
}



