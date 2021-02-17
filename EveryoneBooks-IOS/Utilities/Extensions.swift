//
//  Extensions.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 4/21/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

extension UIView {
    func padLeft(from: NSLayoutXAxisAnchor, num: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false;
        leftAnchor.constraint(equalTo: from, constant: num).isActive = true;
    }
    
    func padTop(from: NSLayoutYAxisAnchor, num: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false;
        topAnchor.constraint(equalTo: from, constant: num).isActive = true;
    }
    
    func padBottom(from: NSLayoutYAxisAnchor, num: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false;
        bottomAnchor.constraint(equalTo: from, constant: -num).isActive = true;
    }
    
    func padRight(from: NSLayoutXAxisAnchor, num: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false;
        rightAnchor.constraint(equalTo: from, constant: -num).isActive = true;
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false;
        heightAnchor.constraint(equalToConstant: height).isActive = true;
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false;
        widthAnchor.constraint(equalToConstant: width).isActive = true;
    }
    
    func centerTo(element: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false;
        centerXAnchor.constraint(equalTo: element).isActive = true;
    }
}

extension UIColor {
    static func getColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha);
       }
    static let testLav = #colorLiteral(red: 0.8384333253, green: 0.8380990624, blue: 0.9487988353, alpha: 1)
    static let mainLav = #colorLiteral(red: 0.9736246434, green: 0.9194237233, blue: 0.9794825912, alpha: 1);
    static let literGray = #colorLiteral(red: 0.9406527602, green: 0.9406527602, blue: 0.9406527602, alpha: 1);
    static let liteGray = #colorLiteral(red: 0.8437410462, green: 0.8542793334, blue: 0.862652313, alpha: 1);
    static let darkGray2 = #colorLiteral(red: 0.2528883877, green: 0.2528883877, blue: 0.2528883877, alpha: 1)
   }

extension CGColor {
    static let CGBlack = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1);
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

extension UIViewController {
    func hkb() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
