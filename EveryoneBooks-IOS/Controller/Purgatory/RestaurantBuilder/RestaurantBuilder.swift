//
//  Restaurant Builder.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 3/29/22.
//  Copyright © 2022 Michael Perrone. All rights reserved.
//

import UIKit

protocol RestaurantBuilderDelegate: RestaurantBuilder {
    func changed(selected: String);
}

class RestaurantBuilder: UIViewController, RestaurantBuilderDelegate {
    
    func changed(selected: String) {
        self.selected = selected;
    }
    
    private var frames: [UIView] = [];
    
    var selected: String = "1" {
        didSet {
            if selected == "1" || selected == "2" {
                if flipped {
                    DispatchQueue.main.async {
                        self.imageView?.removeFromSuperview();
                        self.imageView = self.twoPeopleVertical;
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.imageView?.removeFromSuperview();
                        self.imageView = self.twoPeopleHorizontal;
                    }
                }
            }
            if selected == "3" || selected == "4" {
                if flipped {
                    DispatchQueue.main.async {
                        self.imageView?.removeFromSuperview();
                        self.imageView = self.fourPeopleVertical;
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.imageView?.removeFromSuperview();
                        self.imageView = self.fourPeopleHorizontal;
                    }
                }
            }
        }
    }
    
    var rTables: [[RTable]] = [[], [], [], []];
    
    private let newRoomButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Next Room", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]), for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(newRoomHit), for: .touchUpInside);
        return uib;
    }()
    
    @objc func newRoomHit() {
        if frameCount < 3 {
            frames[frameCount].isHidden = true;
            frameCount = frameCount + 1;
            frames[frameCount].isHidden = false;
        }
    }
    
    private let previousRoomButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "Prev Room", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]), for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(previousRoomHit), for: .touchUpInside);
        return uib;
    }()
    
    @objc func previousRoomHit() {
        if frameCount > 0 {
            frames[frameCount].isHidden = true;
            frameCount = frameCount - 1;
            frames[frameCount].isHidden = false;
        }
    }
    
    private let plusButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.tintColor = .black;
        let attStr = NSAttributedString(string: "+", attributes: [.font: UIFont.boldSystemFont(ofSize: 40)]);
        uib.setHeight(height: 42);
        uib.setWidth(width: 42);
        uib.setAttributedTitle(attStr, for: .normal);
        uib.addTarget(self, action: #selector(plusHit), for: .touchUpInside);
        return uib;
    }()
    
    var frameCount: Int = 0 {
        didSet {
            textView.text = "Room #: " + String(frameCount + 1);
        }
    }
    
    
    // i need to get how far the table is from the frame
    
    // for the x i need to do
    
    // imageview!.layer.postion.x - (self.frames[self.frameCount].layer.position.x - (self.tableFrame.frame.width / 2))
    
    @objc func plusHit() {
        if inside.count > 0 && outside.count == 0 {
            if selected == "1" || selected == "2" {
                DispatchQueue.main.async {
                    if self.flipped {
                        let newIV = UIImageView(image: UIImage(named: "2-people-ver"));
                        self.frames[self.frameCount].addSubview(newIV);
                        newIV.padTop(from: self.view.topAnchor, num: self.imageView!.center.y - self.imageView!.frame.height / 2);
                        newIV.padLeft(from: self.view.leftAnchor, num: self.imageView!.center.x  - self.imageView!.frame.width / 2);
                        newIV.setHeight(height: self.imageView!.frame.height);
                        newIV.setWidth(width: self.imageView!.frame.width);
                        self.rTables[self.frameCount].append(RTable(dic: ["x": (self.imageView!.layer.position.x - (self.frames[self.frameCount].layer.position.x - (self.tableFrame.frame.width / 2))), "y": self.imageView!.layer.position.y - (self.frames[self.frameCount].layer.position.y - (self.tableFrame.frame.height / 2)), "hor": false, "num": 2]))
                        self.imageView?.removeFromSuperview();
                        self.imageView = self.twoPeopleVertical;
                    }
                    else {
                        let newIV = UIImageView(image: UIImage(named: "2-people-hor"));
                        self.frames[self.frameCount].addSubview(newIV);
                        newIV.padTop(from: self.view.topAnchor, num: self.imageView!.center.y - self.imageView!.frame.height / 2);
                        newIV.padLeft(from: self.view.leftAnchor, num: self.imageView!.center.x  - self.imageView!.frame.width / 2);
                        newIV.setHeight(height: self.imageView!.frame.height);
                        newIV.setWidth(width: self.imageView!.frame.width);
                        self.rTables[self.frameCount].append(RTable(dic: ["x": (self.imageView!.layer.position.x - (self.frames[self.frameCount].layer.position.x - (self.tableFrame.frame.width / 2))), "y": self.imageView!.layer.position.y - (self.frames[self.frameCount].layer.position.y - (self.tableFrame.frame.height / 2)), "hor": true, "num": 2]))
                        self.imageView?.removeFromSuperview();
                        self.imageView = self.twoPeopleHorizontal;
                    }
                }
            }
            if selected == "3" || selected == "4" {
                DispatchQueue.main.async {
                    if self.flipped {
                        let newIV = UIImageView(image: UIImage(named: "4-people-ver"));
                        self.frames[self.frameCount].addSubview(newIV);
                        newIV.padTop(from: self.view.topAnchor, num: self.imageView!.center.y - self.imageView!.frame.height / 2);
                        newIV.padLeft(from: self.view.leftAnchor, num: self.imageView!.center.x  - self.imageView!.frame.width / 2);
                        newIV.setHeight(height: self.imageView!.frame.height);
                        newIV.setWidth(width: self.imageView!.frame.width);
                        self.rTables[self.frameCount].append(RTable(dic: ["x": (self.imageView!.layer.position.x - (self.frames[self.frameCount].layer.position.x - (self.tableFrame.frame.width / 2))), "y": self.imageView!.layer.position.y - (self.frames[self.frameCount].layer.position.y - (self.tableFrame.frame.height / 2)), "hor": false, "num": 4]))
                        self.imageView?.removeFromSuperview();
                        self.imageView = self.fourPeopleVertical;
                    }
                    else {
                        let newIV = UIImageView(image: UIImage(named: "4-people-hor"));
                        self.frames[self.frameCount].addSubview(newIV);
                        newIV.padTop(from: self.view.topAnchor, num: self.imageView!.center.y - self.imageView!.frame.height / 2);
                        newIV.padLeft(from: self.view.leftAnchor, num: self.imageView!.center.x  - self.imageView!.frame.width / 2);
                        newIV.setHeight(height: self.imageView!.frame.height);
                        newIV.setWidth(width: self.imageView!.frame.width);
                        self.rTables[self.frameCount].append(RTable(dic: ["x": (self.imageView!.layer.position.x - (self.frames[self.frameCount].layer.position.x - (self.tableFrame.frame.width / 2))), "y": self.imageView!.layer.position.y - (self.frames[self.frameCount].layer.position.y - (self.tableFrame.frame.height / 2)), "hor": true, "num": 4]))
                        self.imageView?.removeFromSuperview();
                        self.imageView = self.fourPeopleHorizontal;
                    }
                }
            }
        }
    }
    
    
    var dragGesture = UIPanGestureRecognizer()
    
    func setUpDrag() {
        dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView));
        imageView!.isUserInteractionEnabled = true;
        imageView!.addGestureRecognizer(dragGesture);
    }
    
    var outside: [UIImageView] = [];
    
    var inside: [UIImageView] = [];
    
    @objc func dragView(_ sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view);
        imageView!.center = CGPoint(x: imageView!.center.x + translation.x, y: imageView!.center.y + translation.y);
        sender.setTranslation(CGPoint.zero, in: self.view);
        if !inside.contains(imageView!) {
            if dragGesture.location(in: tableFrame).y - (imageView?.frame.height)! / 2 > 5 {
                outside.removeAll { iv in
                    iv == imageView!;
                }
                inside.append(imageView!);
            }
        }
        else if !outside.contains(imageView!) {
            if dragGesture.location(in: tableFrame).y - (imageView?.frame.height)! / 2 < 5 {
                inside.removeAll { iv in
                    iv == imageView!;
                }
                outside.append(imageView!);
            }
        }
    }

  weak var imageView: UIImageView? {
        didSet {
            DispatchQueue.main.async {
                self.view.addSubview(self.imageView!);
                self.imageView?.padTop(from: self.view.safeAreaLayoutGuide.topAnchor, num: 10);
                self.imageView?.padLeft(from: self.personCounter.rightAnchor, num: 20);
                self.setUpDrag()
            }
        }
    }
    
    private var flipped = false;
    
    private let personsText = Components().createNotAsLittleText(text: "# at Table:", color: .mainLav);

    private let personCounter: RestaurantBuilderDropDown = {
        let rbdd = RestaurantBuilderDropDown(frame: CGRect.zero);
        rbdd.setWidth(width: 75);
        rbdd.data = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20" ];
        return rbdd;
    }()
    
    
    private let tableFrame: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: 475);
        uiv.setWidth(width: 363);
        uiv.layer.borderWidth = 2.0;
        uiv.layer.borderColor = .CGBlack;
        return uiv;
    }()
    
    private let tableFrame2: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: 475);
        uiv.setWidth(width: 363);
        uiv.layer.borderWidth = 2.0;
        uiv.layer.borderColor = .CGBlack;
        return uiv;
    }()
    
    private let tableFrame3: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: 475);
        uiv.setWidth(width: 363);
        uiv.layer.borderWidth = 2.0;
        uiv.layer.borderColor = .CGBlack;
        return uiv;
    }()
    
    private let tableFrame4: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: 475);
        uiv.setWidth(width: 363);
        uiv.layer.borderWidth = 2.0;
        uiv.layer.borderColor = .CGBlack;
        return uiv;
    }()
    
    private let flipButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setImage(UIImage(named: "rotate"), for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(flipLeft), for: .touchUpInside);
        return uib;
    }();
    
    private var flipBackButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setImage(UIImage(named: "rotate-right"), for: .normal);
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(flipBack), for: .touchUpInside);
        return uib;
    }()
        
    @objc func flipLeft() {
        DispatchQueue.main.async {
            self.imageView?.removeFromSuperview();
            if self.selected == "1" || self.selected == "2" {
                self.imageView = self.twoPeopleVertical;
            }
            else if self.selected == "3" || self.selected == "4" {
                self.imageView = self.fourPeopleVertical;
            }
        }
            flipped = true;
    }
    
    @objc func flipBack() {
        DispatchQueue.main.async {
            self.imageView?.removeFromSuperview();
            if self.selected == "1" || self.selected == "2" {
                self.imageView = self.twoPeopleHorizontal;
            }
            else if self.selected == "3" || self.selected == "4" {
                self.imageView = self.fourPeopleHorizontal;
            }
        }
            flipped = false;
    }
    
    
    private var twoPeopleHorizontal: UIImageView = {
        let uiiv = UIImageView(image: UIImage(named: "2-people-hor.png"));
        uiiv.setWidth(width: 37);
        uiiv.isUserInteractionEnabled = true
        uiiv.setHeight(height: 32);
        uiiv.backgroundColor = .mainLav
        return uiiv;
    }();
    
    private var fourPeopleHorizontal: UIImageView = {
        let uiiv = UIImageView(image: UIImage(named: "4-people-hor.png"));
        uiiv.setWidth(width: 62);
        uiiv.isUserInteractionEnabled = true
        uiiv.setHeight(height: 37);
        uiiv.backgroundColor = .mainLav
        return uiiv;
    }();
    
    private var twoPeopleVertical: UIImageView = {
        let uiiv = UIImageView(image: UIImage(named: "2-people-ver.png"));
        uiiv.setWidth(width: 32);
        uiiv.isUserInteractionEnabled = true
        uiiv.setHeight(height: 37);
        uiiv.backgroundColor = .mainLav;
        return uiiv;
    }();
    
    private var fourPeopleVertical: UIImageView = {
        let uiiv = UIImageView(image: UIImage(named: "4-people-ver.png"));
        uiiv.setWidth(width: 37);
        uiiv.isUserInteractionEnabled = true
        uiiv.setHeight(height: 62);
        uiiv.backgroundColor = .mainLav
        return uiiv;
    }();
    
    private let textView: UITextView = {
        let uitv = Components().createNotAsLittleText(text: "Room #: 1", color: .mainLav);
        uitv.font = .boldSystemFont(ofSize: 18);
        return uitv;
    }()
    
    private let finishButton: UIButton = {
        let uib = Components().createNormalButton(title: "Finished!");
        uib.addTarget(self, action: #selector(finished), for: .touchUpInside);
        return uib;
    }()
    
    @objc func finished() {
        let alert = Components().createActionAlert(title: "Finished Confirm", message: "Are you sure you are finished creating your layout?", buttonTitle: "Yes!") { UIAlertAction in
        }
        let action = UIAlertAction(title: "Oops, no!", style: .cancel, handler: nil);
        alert.addAction(action);
        self.present(alert, animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureView();
    }
    
    func configureView() {
        personCounter.changeDelegate = self;
        view.backgroundColor = .mainLav;
        view.addSubview(personsText);
        personsText.padLeft(from: view.leftAnchor, num: 30);
        personsText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 10);
        view.addSubview(personCounter);
        personCounter.padLeft(from: personsText.rightAnchor, num: -5);
        personCounter.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: -18);
        view.addSubview(tableFrame);
        tableFrame.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 80);
        tableFrame.centerTo(element: view.centerXAnchor);
        view.addSubview(tableFrame2);
        tableFrame2.isHidden = true;
        tableFrame2.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 80);
        tableFrame2.centerTo(element: view.centerXAnchor);
        view.addSubview(tableFrame3);
        tableFrame3.isHidden = true;
        tableFrame3.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 80);
        tableFrame3.centerTo(element: view.centerXAnchor);
        view.addSubview(tableFrame4);
        tableFrame4.isHidden = true;
        tableFrame4.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 80);
        tableFrame4.centerTo(element: view.centerXAnchor);
        view.addSubview(flipButton);
        flipButton.padTop(from: personsText.bottomAnchor, num: -4);
        flipButton.padLeft(from: view.leftAnchor, num: 30);
        view.addSubview(flipBackButton);
        flipBackButton.padTop(from: personsText.bottomAnchor, num: -4);
        flipBackButton.padLeft(from: flipButton.rightAnchor, num: 20);
        view.addSubview(plusButton);
        plusButton.padBottom(from: tableFrame.topAnchor, num: 0);
        plusButton.padRight(from: tableFrame.rightAnchor, num: 10);
        view.addSubview(previousRoomButton);
        previousRoomButton.padLeft(from: view.leftAnchor, num: 30);
        previousRoomButton.padTop(from: tableFrame.bottomAnchor, num: 5);
        view.addSubview(newRoomButton);
        newRoomButton.padLeft(from: previousRoomButton.rightAnchor, num: 30);
        newRoomButton.padTop(from: tableFrame.bottomAnchor, num: 5);
        view.addSubview(textView);
        textView.padRight(from: tableFrame.rightAnchor, num: 15);
        textView.padTop(from: tableFrame.bottomAnchor, num: 2);
        finishButton.setWidth(width: 200);
        view.addSubview(finishButton);
        finishButton.centerTo(element: view.centerXAnchor);
        finishButton.padTop(from: newRoomButton.bottomAnchor, num: 10);
        imageView = twoPeopleHorizontal;
        setUpDrag();
        frames = [tableFrame, tableFrame2, tableFrame3, tableFrame4];
    }
}


extension UIImage {
    func rotate() -> UIImage? {
        let newImage = UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .left)
        return newImage;
    }
}

extension UIView {

var heightConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .height && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

var widthConstraint: NSLayoutConstraint? {
    get {
        return constraints.first(where: {
            $0.firstAttribute == .width && $0.relation == .equal
        })
    }
    set { setNeedsLayout() }
}

}
