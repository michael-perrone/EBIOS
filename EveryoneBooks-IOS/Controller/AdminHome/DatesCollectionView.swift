//
//  DatesCollectionView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/14/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class DatesCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var dates: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let myLayout = UICollectionViewFlowLayout();
        myLayout.minimumLineSpacing = 20;
        myLayout.scrollDirection = .horizontal;
        super.init(frame: CGRect.zero, collectionViewLayout: myLayout);
        register(DatesCollectionViewCell.self, forCellWithReuseIdentifier: "DATES");
        dataSource = self;
        delegate = self;
        backgroundColor = .mainLav;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dates = dates {
            return dates.count;
        }
        else {
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let datesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DATES", for: indexPath) as! DatesCollectionViewCell;
        if let dates = dates {
            datesCell.date = dates[indexPath.row];
            datesCell.setupCell()
        }
        return datesCell;
    }
    
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     return 1
 }

 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return 1
 }
}

extension DatesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 40);
    }
}

