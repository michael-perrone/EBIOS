//
//  BusinessesCurrentlyWorking.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 11/23/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class BusinessesCurrentlyWorking: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var businesses: [Business]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    weak var otherDelegate: EmployeeProfileDelegate?
    
    var abc = "ABC";
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout());
        register(BusinessesCurrentlyWorkingCell.self, forCellWithReuseIdentifier: abc);
        backgroundColor = .mainLav;
        dataSource = self;
        delegate = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        }
        else {
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: abc, for: indexPath) as! BusinessesCurrentlyWorkingCell;
        if let businesses = businesses {
            cell.business = businesses[indexPath.row];
            cell.delegate = otherDelegate;
            cell.configureLayout()
            cell.index = 0;
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 160);
    }
}
