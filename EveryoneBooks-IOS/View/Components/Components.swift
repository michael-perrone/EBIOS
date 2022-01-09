//  Utils.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/21/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

class Components {
    
    // MARK: - SIMPLE TEXT
    
    func createBigLogo() -> UIImageView {
        let uiiv = UIImageView();
        uiiv.image = UIImage(named: "logo-big");
        uiiv.backgroundColor = .mainLav;
        return uiiv;
    }
    
    func createLogoText() -> UITextView {
        let uitv = UITextView();
        uitv.text = "Everyone Books";
        uitv.backgroundColor = .mainLav;
        uitv.font = UIFont(name: "ChalkboardSE-Bold", size: 46);
        uitv.textAlignment = .center;
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        return uitv;
    }
    
    func createSimpleText(text: String, color: UIColor? = .mainLav) -> UITextView {
        let uitv = UITextView();
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.text = text;
        uitv.font = .systemFont(ofSize: 22);
        uitv.backgroundColor = color;
        return uitv;
    }
    
    func createNotAsSmallText(text: String, color: UIColor? = .literGray) -> UITextView {
        let uitv = UITextView();
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.text = text;
        uitv.font = .systemFont(ofSize: 14);
        if let colorComingIn = color {
            uitv.backgroundColor = colorComingIn;
        }
        else {
            uitv.backgroundColor = .literGray;
        }
        
        return uitv;
    }
    
    func createYesAnswer(answer: String) -> UIView {
        let uiv = UIView();
        let uiiv = UIImageView(image: UIImage(named: "suc"));
        uiv.addSubview(uiiv);
        uiv.setHeight(height: 72);
        uiv.setWidth(width: fullWidth / 1.2);
        uiiv.padTop(from: uiv.topAnchor, num: 0);
        uiiv.padLeft(from: uiv.leftAnchor, num: 15);
        let uitv = UITextView();
        uitv.text = answer;
        uiv.addSubview(uitv);
        uitv.padTop(from: uiv.topAnchor, num: 0);
        uitv.padLeft(from: uiiv.rightAnchor, num: 8);
        uitv.font = UIFont(name: "Noteworthy-Bold", size: 30);
        uitv.backgroundColor = .mainLav;
        uitv.setHeight(height: 40);
        uitv.setWidth(width: fullWidth / 1.3)
        uitv.isScrollEnabled = false;
        uitv.isEditable = false;
        return uiv;
       }
    
    func createActionAlert(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let uiac = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let uiaa = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: handler);
        uiac.addAction(uiaa);
        return uiac;
    }
    
    func createNoAnswer(answer: String) -> UIView {
        let uiv = UIView();
        let uiiv = UIImageView(image: UIImage(named: "deny"));
        uiv.addSubview(uiiv);
        uiv.setHeight(height: 72);
        uiv.setWidth(width: fullWidth / 1.2);
        uiiv.padTop(from: uiv.topAnchor, num: 0);
        uiiv.padLeft(from: uiv.leftAnchor, num: 15);
        let uitv = UITextView();
        uitv.text = answer;
        uiv.addSubview(uitv);
        uitv.padTop(from: uiv.topAnchor, num: 0);
        uitv.padLeft(from: uiiv.rightAnchor, num: 20);
        uitv.font = UIFont(name: "Noteworthy", size: 30);
        uitv.backgroundColor = .mainLav;
        uitv.isScrollEnabled = false;
        uitv.isEditable = false;
        return uiv;
    }
    
    func createCancelButton(height: CGFloat, width: CGFloat) -> UIButton {
        let uib = UIButton(type: .system);
        uib.setTitle("Close", for: .normal)
        uib.titleLabel?.font = UIFont(name: "GillSans-Bold", size: 20);
        uib.setHeight(height: height);
        uib.setWidth(width: width);
        uib.backgroundColor = .darkGray;
        uib.tintColor = .mainLav;
        uib.layer.cornerRadius = height / 4;
        uib.layer.borderColor = .CGBlack;
        return uib;
    }
    
    // MARK: - TEXT FIELD INSIDE INPUT
    
    func createTextField(placeHolder: String, fontSize: CGFloat) -> UITextField {
        let uitf = UITextField();
        uitf.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray] )
        uitf.font = .systemFont(ofSize: fontSize)
        return uitf;
    }
    
    
    // MARK: - INPUT
    func createInput( textField: UITextField, view: UIView?, typeOfInput: String? = nil, width: CGFloat? = nil) -> UIView {
        let uiv = UIView();
        let bottomBorder = UIView();
        if let viewComing = view {
            uiv.setHeight(height: 35);
            if let width = width {
                uiv.setWidth(width: width)
                bottomBorder.setWidth(width: width)
            } else {
                uiv.setWidth(width: viewComing.frame.width / 1.3);
                bottomBorder.setWidth(width: viewComing.frame.width / 1.3);
            }
        }
        if let widthComing = width {
            uiv.setWidth(width: widthComing);
        }
        uiv.backgroundColor = .clear;
        bottomBorder.setHeight(height: 2);
        bottomBorder.backgroundColor = .black;
        uiv.addSubview(bottomBorder);
        uiv.addSubview(textField);
        textField.padBottom(from: uiv.bottomAnchor, num: 4);
        textField.padLeft(from: uiv.leftAnchor, num: 4);
        textField.padRight(from: uiv.rightAnchor, num: 4);
        bottomBorder.padLeft(from: uiv.leftAnchor, num: 0);
        bottomBorder.padTop(from: textField.bottomAnchor, num: 0);
        return uiv;
    }
    
    
    // MARK: - CREATE QUESTION BUTTON
    func createQuestionButton() -> UIButton {
        let uib = UIButton(type: .system);
         uib.setTitle("?", for: .normal);
         uib.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1);
         uib.layer.borderWidth = 3.0;
         uib.setHeight(height: 60);
         uib.setWidth(width: 60);
         uib.titleLabel?.font = UIFont.boldSystemFont(ofSize: 42);
         uib.layer.cornerRadius = 30.0;
         return uib;
    }
    
    // MARK: -CREATE TITLE TEXT
    
    func createTitleText(text: String) -> UITextView {
        let uitv = UITextView();
        uitv.font = .boldSystemFont(ofSize: 18);
        uitv.text = text;
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .clear;
        uitv.setWidth(width: fullWidth / 1.1);
        return uitv;
    }
    
    // MARK: -CREATE DETAIL TEXT
    
    func createDetailText(text: String) -> UITextView {
        let uitv = UITextView();
        uitv.font = .systemFont(ofSize: 15);
        uitv.text = text;
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .clear;
        uitv.setWidth(width: fullWidth / 1.1);
        return uitv;
    }
    // MARK: -BORDER
    
    func createBorder(height: CGFloat, width: CGFloat, color: UIColor) -> UIView {
        let uiv = UIView();
        uiv.setHeight(height: height);
        uiv.setWidth(width: width);
        uiv.backgroundColor = color;
        return uiv;
    }
    
    // MARK: - FRONT PAGE LOGIN SCREEN BUTTONS
    
    func createFrontButtons(title: String, view: UIView) -> UIButton {
        let frontButton = UIButton(type: .system);
        frontButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
        frontButton.setHeight(height: 50);
        frontButton.setWidth(width: view.frame.width / 1.3);
        frontButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1);
        frontButton.layer.borderWidth = 2.0;
        frontButton.layer.cornerRadius = 6;
        frontButton.backgroundColor = .white;
        frontButton.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]), for: .normal);
        return frontButton;
    }
    
    func createRightButton(title: String) -> UIButton {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide", size: 30)]), for: .normal);
        uib.tintColor = .black;
        return uib;
    }
    
    // MARK: - WHITE BUTTONS LOGIN/REGISTER
    
    func createNormalButton(title: String) -> UIButton {
        let loginButton = UIButton(type: .system);
        loginButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1);
        loginButton.layer.borderWidth = 2.0;
        loginButton.backgroundColor = .white;
        loginButton.setTitle(title, for: .normal);
        loginButton.tintColor = .black;
        loginButton.layer.cornerRadius = 2;
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 22);
        return loginButton;
    }
    
    func createXButton() -> UIButton {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "X", attributes: [NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide", size: 38)]), for: .normal);
        uib.tintColor = .black;
        return uib;
    }
    
    func createPinkXButton() -> UIButton {
           let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "X", attributes: [NSAttributedString.Key.foregroundColor: UIColor.mainLav, NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Wide", size: 38)]), for: .normal);
           uib.tintColor = .black;
           return uib;
       }
    
    func createAlternateButton(title: String) -> UIButton {
           let loginButton = UIButton(type: .system);
           loginButton.backgroundColor = .mainLav;
           loginButton.setTitle(title, for: .normal);
           loginButton.tintColor = .black;
           loginButton.layer.cornerRadius = 6;
           loginButton.titleLabel?.font = .boldSystemFont(ofSize: 22);
            
           return loginButton;
       }
    
    // MARK: - BACK BUTTON ARROW IMAGE
    
    func createBackButton() -> UIButton {
        let undoButton = UIButton(type: .system);
        undoButton.setImage(UIImage(named: "undo"), for: .normal);
        undoButton.tintColor = .black;
        return undoButton;
    }
    
    // MARK: - ERROR TEXT
    
    func createError(view: UIView) -> UITextView {
        let uitv = UITextView();
        uitv.font = .systemFont(ofSize: 18);
        uitv.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1);
        uitv.backgroundColor = .mainLav;
        uitv.text = "";
        uitv.isScrollEnabled = false;
        uitv.isEditable = false;
        uitv.setWidth(width: view.frame.width);
        uitv.textAlignment = .center;
        return uitv;
    }
    
    // MARK: - LARGER TEXT
    
    func createLargerText(text: String) -> UITextView {
        let uitv = UITextView()
        uitv.text = text;
        uitv.font = .boldSystemFont(ofSize: 28);
        return uitv;
    }
    
    // MARK: - NAVBARITEM
    
    func createNavBarItemController(image: UIImage?, viewController: UIViewController, title: String) -> UINavigationController {
        let navBarItem = UINavigationController(rootViewController: viewController);
        navBarItem.tabBarItem.image = image;
        navBarItem.title = title;
        navBarItem.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Hello", style: UIBarButtonItem.Style.plain, target: nil, action: nil);
        return navBarItem;
    }

    
    // MARK: - BARITEM
    
    func createBarItemController(image: UIImage?, viewController: UIViewController, title: String) -> UIViewController {
        let barItem = viewController;
        barItem.tabBarItem.image = image;
        barItem.title = title;
        return barItem;
    }
    
    // MARK: - Help Details
    
    func createHelpDetails(text: String) -> UITextView {
        let uitv = UITextView();
        uitv.text = text;
        uitv.font = .systemFont(ofSize: 18);
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .mainLav;
        return uitv;
    }
    
    // MARK: -COOL BUTTON
    
    func createCoolButton(title: String) -> UIButton {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Bold", size: 24)]), for: .normal);
        uib.backgroundColor = .liteGray;
        uib.layer.borderColor = .CGBlack;
        uib.layer.borderWidth = 0.8;
        uib.layer.cornerRadius = 3;
        uib.setHeight(height: 40);
        uib.setWidth(width: fullWidth / 1.2)
        return uib;
    }
    
    func createGoodButton(title: String) -> UIButton {
        let uib = UIButton(type: .system);
        uib.layer.borderColor = CGColor.CGBlack;
        uib.layer.borderWidth = 1.0;
        uib.setHeight(height: 30);
        uib.setWidth(width: 70);
        uib.setTitle(title, for: .normal);
        uib.tintColor = .black;
        return uib;
    }
    
//    func createBorder(view: UIView) -> UIView {
//        let uiv = UIView();
//        uiv.setWidth(width: view.frame.width);
//        uiv.setHeight(height: 2);
//        uiv.backgroundColor = .black;
//        return uiv;
//    }
//    
    func createLittleGuy() -> UIImageView {
        let uiiv = UIImageView();
        uiiv.image = UIImage(named: "logo-small");
        uiiv.setHeight(height: 30);
        uiiv.setWidth(width: 30);
        return uiiv;
    }
    
    func createBackDrop() -> UIView {
        let uiv = UIView();
        uiv.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height);
        uiv.backgroundColor = UIColor.black.withAlphaComponent(0.75);
        return uiv;
    }
    
    
    func createGoToBusinessEdit() -> UIButton {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Edit Business", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
        uib.setHeight(height: 30);
        uib.setWidth(width: 100);
        return uib;
    }
    
    func createAddBooking() -> UIButton {
           let uib = UIButton(type: .system);
           uib.setAttributedTitle(NSAttributedString(string: "Add Booking", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]), for: .normal)
           uib.setHeight(height: 30);
           uib.setWidth(width: 100);
           return uib;
       }
    
    func createWhiteUIView(width: CGFloat, height: CGFloat) -> UIView {
        let uiv = UIView();
        uiv.setWidth(width: UIScreen.main.bounds.width / width);
        uiv.setHeight(height: UIScreen.main.bounds.height /  height);
        uiv.layer.borderColor = .CGBlack;
        uiv.layer.borderWidth = 2.0;
        uiv.backgroundColor = .white;
        return uiv;
    }

    func createHelpLeftButton() -> UIButton {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Help", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]), for: .normal);
        uib.setWidth(width: 50);
        uib.setHeight(height: 30);
        return uib;
    }
    
    func createTableToggleButtons(title: String) -> UIButton {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]), for: .normal);
        uib.backgroundColor = .mainLav;
        uib.layer.borderWidth = 2.0;
        uib.layer.borderColor = .CGBlack;
        uib.setWidth(width: UIScreen.main.bounds.width / 2.06);
        uib.setHeight(height: 48);
        return uib;
    }
    
    func createSuccess(text: String) -> UIView {
        let uiv = UIView();
        let uiiv = UIImageView();
        uiiv.image = UIImage(named: "suc");
        uiv.setWidth(width: UIScreen.main.bounds.width);
        let uitv = createSimpleText(text: text);
        uiv.setHeight(height: 50);
        uiv.addSubview(uiiv);
        uiiv.setHeight(height: 40);
        uiiv.setWidth(width: 40);
        uiv.addSubview(uitv);
        uitv.padTop(from: uiv.topAnchor, num: 2);
        uitv.centerTo(element: uiv.centerXAnchor);
        uiiv.padRight(from: uitv.leftAnchor, num: 4);
        uitv.backgroundColor = .mainLav;
        return uiv;
    }
    
    func createContinueBookingButton() -> UIButton {
            let uib = UIButton(type: .system);
            let attributedTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.mainLav])
            uib.setAttributedTitle(attributedTitle, for: .normal);
            uib.backgroundColor = .darkGray;
            uib.layer.cornerRadius = 30;
            uib.setHeight(height: 60);
            uib.setWidth(width: UIScreen.main.bounds.width / 1.2);
            uib.showsTouchWhenHighlighted = true;
            return uib;
    }
    
    func createLittleText(text: String, color: UIColor? = .mainLav) -> UITextView {
        let uitv = UITextView();
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.text = text;
        uitv.font = .boldSystemFont(ofSize: 14);
        uitv.backgroundColor = color;
           return uitv;
    }
    
    func createNotAsLittleText(text: String, color: UIColor? = .literGray) -> UITextView {
             let uitv = UITextView();
             uitv.isEditable = false;
             uitv.isScrollEnabled = false;
             uitv.text = text;
             uitv.font = .boldSystemFont(ofSize: 16);
             uitv.backgroundColor = .literGray;
        if let colorComingIn = color {
            uitv.backgroundColor = colorComingIn;
        }
        else {
            uitv.backgroundColor = .literGray;
        }
             return uitv;
      }
    
    func createMenuButton() -> UIBarButtonItem {
        let uib = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItem.Style.plain, target: nil, action: nil);
        return uib;
    }
}
