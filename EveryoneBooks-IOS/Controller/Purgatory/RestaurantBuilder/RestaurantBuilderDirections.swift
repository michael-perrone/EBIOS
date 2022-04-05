//
//  RestaurantBuilderDirections.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 3/29/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

class RestaurantBuilderDirections: UIViewController {
    
    private let directionsText = Components().createNotAsLittleText(text: "Restaurant Builder Directions:", color: .mainLav);
    
    private let directionsOne: UITextView = {
        let uitv = UITextView();
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .clear;
        uitv.text = "1. Identify how many tables you have at your restaurant and estimate the number of people who will sit at each individual table. The number of estimated people at a table will help choose the size of the table for your layout.";
        uitv.font = .systemFont(ofSize: 16);
        uitv.setWidth(width: fullWidth - 20);
        return uitv;
    }();
    
    private let directionsTwo: UITextView = {
        let uitv = UITextView();
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .clear;
        uitv.text = "2. Use the number selector to create each table in your restaurant one at a time by choosing the number of people who will sit at the table you are creating.";
        uitv.font = .systemFont(ofSize: 16);
        uitv.setWidth(width: fullWidth - 20);
        return uitv;
    }();
    
    private let directionsThree: UITextView = {
        let uitv = UITextView();
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .clear;
        uitv.text = "3. Drag the table into the area below. Click on the save button when the table is in the spot you want it in."
        uitv.font = .systemFont(ofSize: 16);
        uitv.setWidth(width: fullWidth - 20);
        return uitv;
    }();
    
    private let directionsFour: UITextView = {
        let uitv = UITextView();
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .clear;
        uitv.text = "4. After hitting the save button, you can now drag a new table in your replica layout. Repeat the task of dragging the table in and saving until you are finished. When done, clicked finished!.";
        uitv.font = .systemFont(ofSize: 16);
        uitv.setWidth(width: fullWidth - 20);
        return uitv;
    }();

    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.addSubview(directionsText);
        directionsText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        directionsText.centerTo(element: view.centerXAnchor);
        
    }
}
