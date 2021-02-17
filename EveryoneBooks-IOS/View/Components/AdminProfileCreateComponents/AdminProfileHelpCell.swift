//
//  AdminProfileHelpCell.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/21/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class AdminProfileHelpCell: UICollectionViewCell {
    var title = "";
    var details = "";
      
      override init(frame: CGRect) {
          super.init(frame: frame)
      }
      
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
        
       }
      
      lazy var titleView: UITextView = {
          let uitv = Components().createSimpleText(text: title);
          uitv.textColor = .mainLav;
          uitv.backgroundColor = .clear;
          return uitv;
      }()
      
      lazy var detailView: UITextView = {
          let uitv = UITextView();
          uitv.isScrollEnabled = false;
          uitv.isEditable = false;
          uitv.font = .systemFont(ofSize: 18);
          uitv.text = details;
          uitv.backgroundColor = .clear;
          uitv.textColor = .mainLav;
          uitv.setHeight(height: 210);
          return uitv;
      }()
      
      private let borderBottom: UIView = {
          let uiv = UIView();
          uiv.backgroundColor = .mainLav;
          uiv.setWidth(width: UIScreen.main.bounds.width);
          uiv.setHeight(height: 2.0);
          return uiv;
      }()
       
      func configureUI() {
          addSubview(titleView);
          titleView.centerTo(element: centerXAnchor);
          titleView.padTop(from: topAnchor, num: 30);
          addSubview(detailView);
          detailView.padLeft(from: leftAnchor, num: 12);
          detailView.padTop(from: titleView.bottomAnchor, num: 20)
          detailView.padRight(from: rightAnchor, num: 20)
          addSubview(borderBottom);
          borderBottom.centerTo(element: centerXAnchor);
          borderBottom.padTop(from: detailView.bottomAnchor, num: 5);
      }
}
