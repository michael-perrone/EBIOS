//
//  BcnSelectorTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 1/22/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit


class BcnSelectorCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
 
    var bcns: [Int]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    var selectedBcn: Int? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    weak var del: BookingHit? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    weak var fromNotiDel: FromNotiBcnSelector? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let myLayout = UICollectionViewFlowLayout();
        myLayout.scrollDirection = .horizontal;
        myLayout.minimumInteritemSpacing = 0;
        myLayout.minimumLineSpacing = 0;
        super.init(frame: CGRect.zero, collectionViewLayout: myLayout);
        register(BcnSelectorCollectionCell.self, forCellWithReuseIdentifier: "bscv");
        register(BcnSelectorCollectionSelectedCell.self, forCellWithReuseIdentifier: "bscvs");
        bounces = false;
        delegate = self;
        dataSource = self;
        backgroundColor = .mainLav;
        showsHorizontalScrollIndicator = false;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let bcns = bcns {
            return bcns.count;
        }
        else {
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "bscv", for: indexPath) as! BcnSelectorCollectionCell;
        if let bcns = bcns {
            if let selectedBcn = selectedBcn {
                if bcns[indexPath.row] == selectedBcn {
                    let selectedCell = dequeueReusableCell(withReuseIdentifier: "bscvs", for: indexPath) as! BcnSelectorCollectionSelectedCell;
                    selectedCell.bcn = bcns[indexPath.row];
                    selectedCell.layoutCell();
                    return selectedCell;
                }
            }
            cell.bcn = bcns[indexPath.row];
            cell.layoutCell()
            cell.del = self.del;
            cell.fromNotiDel = self.fromNotiDel;
        }
        return cell;
    }
    
}
