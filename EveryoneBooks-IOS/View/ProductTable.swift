//
//  ProductTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/27/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import Foundation
import UIKit

class ProductTable: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var otherDelegate: RemoveProductProtocol?;
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.insetGrouped);
        register(ProductTableCell.self, forCellReuseIdentifier: "pc");
        backgroundColor = .mainLav;
        dataSource = self;
        delegate = self;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var products: [Product]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = products {
            print(products.count)
            return products.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "pc", for: indexPath) as! ProductTableCell;
        if let products = products {
            cell.product = products[indexPath.row];
            cell.configureCell()
            return cell;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let products = products {
            if editingStyle == .delete {
                otherDelegate?.removeProduct(productName: products[indexPath.row].name, index: indexPath.row);
            }
        }
    }

    
    
}
