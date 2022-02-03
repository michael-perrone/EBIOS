//
//  ProductsTable.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 12/27/21.
//  Copyright © 2021 Michael Perrone. All rights reserved.
//


import UIKit

protocol ProductsTableDelegate: ProductsTable {
    func addProduct(product: Product)
    func minusProduct(product: Product)
}

class ProductsTable: UITableView, UITableViewDelegate, UITableViewDataSource, ProductsTableDelegate  {
   
    func minusProduct(product: Product) {
        selectedProducts.removeAll(where: { (eachProduct) -> Bool in
           return product.id == eachProduct.id
        })
        reloadData();
    }
    
    func addProduct(product: Product) {
        selectedProducts.append(product);
        reloadData();
    }
    /// Delegate Functions
    
    var shortText: Bool = false;

    var selectedProducts: [Product] = [];
    
    var data: [Product]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    var unselectedCellBackgroundColor: UIColor?;
    
    var unselectedCellTextColor: UIColor?;
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.grouped)
        delegate = self;
        dataSource = self;
        register(ProductSelectedTableCell.self, forCellReuseIdentifier: "PSC");
        register(ProductUnselectedTableCell.self, forCellReuseIdentifier: "UPC");
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unwrappedData = data {
            return unwrappedData.count;
        }
        else {
            return 0;
        }
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = data {
            if selectedProducts.contains(where: { (product) -> Bool in
                product.id == data[indexPath.row].id
            }) {
                let unSelectedCell = dequeueReusableCell(withIdentifier: "PSC", for: indexPath) as! ProductSelectedTableCell;
                unSelectedCell.product = data[indexPath.row];
                unSelectedCell.delegate = self;
                if shortText {
                    unSelectedCell.shortText = true;
                }
                unSelectedCell.configureName();
                unSelectedCell.configureColor();
                unSelectedCell.selectionStyle = .none;
                return unSelectedCell;
            }
            else {
                let selectedCell = dequeueReusableCell(withIdentifier: "UPC", for: indexPath) as! ProductUnselectedTableCell;
                if let bColorComingIn = unselectedCellBackgroundColor {
                    selectedCell.bColor = bColorComingIn;
                }
                if let tColorComingIn = unselectedCellTextColor {
                    selectedCell.tColor = tColorComingIn;
                }
                
                selectedCell.product = data[indexPath.row];
                selectedCell.delegate = self;
                if shortText {
                    selectedCell.shortText = true;
                }
                selectedCell.configureName();
                selectedCell.configureColor();
                selectedCell.selectionStyle = .none;
                return selectedCell;
            }
        }
        else {
            return UITableViewCell();
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedProducts.contains(where: { service in
            service.id == data![indexPath.row].id
        }) {
            minusProduct(product: data![indexPath.row]);
        }
        else {
            addProduct(product: data![indexPath.row])
        }
    }
}
