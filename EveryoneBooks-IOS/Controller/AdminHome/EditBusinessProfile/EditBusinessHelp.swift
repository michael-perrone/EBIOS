//
//  EditBusinessHelp.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/8/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EditBusinessHelp: UICollectionViewController {
    
    private let cellName = "AdminProfileRegHelp";
    
    private let data = [["title": "Adding/Editing Employees", "info": "In the corresponding text box, enter your employee's given ID that they were assigned when signing up for the app. Once you have entered the ID, hit ADD to confirm this is the employee you want to add. You can also remove employees from your business by swiping an employee name to the left in the employee list below."], ["title": "Adding/Editing Services", "info": "Add one or multiple services that you would like to make available to your customers through our app. Please add a name, cost, and time duration for each service. You can delete a service by swiping left on the service you want to delete in the list below."], ["title":"Adding/Editing Products", "info": "Below you can add or edit products that your business sells to customers. You will want to clearly state the product name and the price including two decimal points if neccesary."]]
    
    
    private let doneButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setBackgroundImage(UIImage(named: "backer"), for: .normal);
        uib.addTarget(self, action: #selector(done), for: .touchUpInside);
        return uib;
    }();
    
    @objc func done() {
        dismiss(animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    

    func configureView() {
        collectionView.register(AdminProfileHelpCell.self, forCellWithReuseIdentifier: cellName);
        collectionView.backgroundColor = .black;
        view.addSubview(doneButton);
        doneButton.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 0);
        doneButton.padLeft(from: view.leftAnchor, num: 10)
        doneButton.setHeight(height: 45);
        doneButton.setWidth(width: 45);
    }
}

extension EditBusinessHelp {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return data.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! AdminProfileHelpCell;
       cell.title = data[indexPath.row]["title"]!
       cell.details = data[indexPath.row]["info"]!
       cell.configureUI()
        return cell;
    }
}

extension EditBusinessHelp: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300);
    }
}
