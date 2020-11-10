//
//  Product.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/27/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//


import Foundation

struct Product {
    var name: String;
    var price: String;
    var id: String?
    
    init(name: String, price: String, idParam: String?) {
        self.name = name;
        self.price = price;
        if let idIsHere = idParam {
            self.id = idIsHere;
        }
    }
}
