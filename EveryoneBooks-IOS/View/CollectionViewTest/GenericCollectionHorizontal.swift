//
//  GenericCollectionHorizontal.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 2/22/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

protocol SelectCell: GenericCollectionHorizontal{
    func selectCell(index: Int, item: HorItem);
}


class GenericCollectionHorizontal: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectCell  {
   
    func selectCell(index: Int, item: HorItem) {
        self.indexChosen = index;
        self.selectedItem = item;
    }
    
    var selectedItem: HorItem? {
        didSet {
            print(selectedItem);
        }
    }
    
    var indexChosen: Int? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }

    var data: [HorItem]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let myLayout = UICollectionViewFlowLayout();
        myLayout.scrollDirection = .horizontal;
        myLayout.minimumInteritemSpacing = 5;
        myLayout.minimumLineSpacing = 5;
        super.init(frame: CGRect.zero, collectionViewLayout: myLayout);
        register(GenericCollectionHorizontalCell.self, forCellWithReuseIdentifier: "horCell");
        register(SelectedGenericHorizontalCell.self, forCellWithReuseIdentifier: "selectedHorCell");
        delegate = self;
        dataSource = self;
        backgroundColor = .mainLav;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = data {
            return data.count;
        }
        else {
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let horCell = collectionView.dequeueReusableCell(withReuseIdentifier: "horCell", for: indexPath) as! GenericCollectionHorizontalCell;
        if let data = data {
            if let indexChosen = indexChosen {
                if indexChosen == indexPath.row {
                    let selectedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedHorCell", for: indexPath) as! SelectedGenericHorizontalCell;
                    selectedCell.item = data[indexPath.row];
                    selectedCell.configureCell();
                    selectedCell.index = indexPath.row;
                    selectedCell.del = self;
                    return selectedCell;
                    }
                }
            horCell.item = data[indexPath.row];
            horCell.index = indexPath.row;
            horCell.configureCell();
            horCell.del = self;
            }
        return horCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let data = data {
            let item = data[indexPath.row];
            let titleArray = Array(item.title);
            if titleArray.count > 2 {
                return CGSize(width: (Double(titleArray.count) + 4.7) * 8.2, height: 40.0);
            }
            else {
                return CGSize(width: 40, height: 40);
            }
        }
        else {
            return CGSize(width: 50, height: 40);
        }
    }
}
