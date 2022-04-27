//
//  PayrollCollectionView.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/15/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class PayrollCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var payrollNums: [PayrollNumbers]? {
        didSet {
            print(payrollNums);
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout());
        backgroundColor = .mainLav;
        register(PayrollCollectionViewCell.self, forCellWithReuseIdentifier: "PayrollCell")
        delegate = self;
        dataSource = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let payrollNums = payrollNums {
            print(payrollNums.count);
            return payrollNums.count;
        }
        else {
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "PayrollCell", for: indexPath) as! PayrollCollectionViewCell;
        if let payrollNums = payrollNums {
            cell.payrollNums = payrollNums[indexPath.row];
            cell.config();
        }
            return cell;
        }
    }

extension PayrollCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fullWidth, height: 210);
    }
}
    
    
