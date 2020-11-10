//
//  EmployeeBusinessSearchCollection.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 8/1/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol EmployeeBusinessCollectionViewCellDelegate: EmployeeBusinessSearchCollection {
    func sendID(bpId: String)
}


class EmployeeBusinessSearchCollection: UICollectionViewController, EmployeeBusinessCollectionViewCellDelegate {
    
    func sendID(bpId: String) {
        let employeeId = Utilities().decodeEmployeeToken()!["id"] as! String;
        print(employeeId)
        API().post(url: myURL + "notifications/employeeSendingId",  dataToSend: ["businessId": bpId, "employeeId": employeeId]) { (res) in
            print("cool")
            if let statusCode = res["statusCode"] as? Int {
                if statusCode == 406 {
                    print("too many ids sent");
                }
                if statusCode == 409 {
                    print("already requested this business buddy");
                }
            }
        }
    }
    
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
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    
    func configureUI() {
        collectionView.register(EmployeeBusinessSearchCell.self, forCellWithReuseIdentifier: "EBSC");
        collectionView.backgroundColor = .literGray;
        navigationController?.navigationBar.backgroundColor = .mainLav;
        navigationController?.navigationBar.barTintColor = .mainLav;
        let logoView = UIImageView(image: UIImage(named: "logo-small"));
        logoView.setHeight(height: 36);
        logoView.setWidth(width: 36);
        navigationItem.titleView = logoView;
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain , target: self, action: #selector(goBack))
    }
}

extension EmployeeBusinessSearchCollection{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count;
        }
        else {
            return 0;
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EBSC", for: indexPath) as! EmployeeBusinessSearchCell;
        if let businesses = businesses {
            cell.businessName.text = businesses[indexPath.row].nameOfBusiness;
            cell.streetText.text = businesses[indexPath.row].street;
            cell.cityText.text = businesses[indexPath.row].city;
            cell.stateText.text = businesses[indexPath.row].state;
            cell.zipText.text = businesses[indexPath.row].zip;
            cell.bID = businesses[indexPath.row].id;
            cell.configureView();
            cell.index_ = indexPath.row;
            cell.delegate = self;
        }
        return cell;
    }
}

extension EmployeeBusinessSearchCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 160);
    }
}





