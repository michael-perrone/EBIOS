//
//  EditableText.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 10/16/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class EditableText: UIView {
    
    var editable = false;
    
    var topText: String;
    
    var showEditButton: Bool;
    
    private let textView: UITextView = {
        let uitv = UITextView();
        uitv.isScrollEnabled = false;
        uitv.isEditable = false;
        uitv.layer.borderColor = .CGBlack;
        uitv.setWidth(width: fullWidth / 1.3);
        uitv.setHeight(height: 40);
        uitv.font = .systemFont(ofSize: 19);
        uitv.textColor = .black;
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let editButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.addTarget(self, action: #selector(editTheText), for: .touchUpInside);
        uib.setImage(UIImage(named: "pencil"), for: .normal);
        uib.setHeight(height: 24);
        uib.setWidth(width: 24);
        return uib;
    }();
    
    private let topTextView: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.setHeight(height: 40)
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    @objc func editTheText() {
        if !editable {
            textView.isEditable = true;
            textView.layer.borderWidth = 1.2;
            textView.backgroundColor = .white;
            editable = true;
        }
        else {
            editable = false;
            textView.isEditable = false;
            textView.backgroundColor = .literGray;
            textView.layer.borderWidth = 0;
        }
    }
    
    init(topText: String, showEditButton: Bool) {
        self.showEditButton = showEditButton;
        self.topText = topText;
        super.init(frame: CGRect.zero)
        backgroundColor = .mainLav;
        configureMe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMe() {
        addSubview(textView);
        setWidth(width: fullWidth);
        setHeight(height: 80);
        addSubview(topTextView);
        topTextView.padTop(from: topAnchor, num: 0);
        topTextView.setHeight(height: 26);
        topTextView.padLeft(from: leftAnchor, num: 10);
        textView.padLeft(from: leftAnchor, num: 10);
        textView.padTop(from: topTextView.bottomAnchor, num: 0);
        topTextView.text = topText;
        if showEditButton {
            addSubview(editButton);
            editButton.padLeft(from: textView.rightAnchor, num: 20);
            editButton.padTop(from: textView.topAnchor, num: 3);
        }
    }
    
    func setText(text: String) {
    DispatchQueue.main.async {
        self.textView.text = text;
        }
    }
    

}
