

import UIKit
import Foundation

class BusinessesFollowingCollectionViewCell: UICollectionViewCell {
    
    var timer = Timer();
    
    var bID: String?;
    
    var index_: Int?
    
    weak var delegate: OtherCollectionViewCellDelegate?;
        
     var business: Business? {
           didSet {
               if self.business!.schedule?.sunOpen == "Closed" || self.business!.schedule?.sunClose == "Closed" {
                   sunText.text = "Sun: Closed"
               }
               else {
                   sunText.text = "Sun: \(self.business!.schedule?.sunOpen ?? "")-\(self.business!.schedule?.sunClose ?? "")"
               }
               if self.business?.schedule?.monOpen == "Closed" || self.business?.schedule?.monClose == "Closed" {
                   monText.text = "Mon: Closed"
               }
               else {
                   monText.text = "Mon: \(self.business!.schedule?.monOpen ?? "")-\(self.business!.schedule?.monClose ?? "")"
               }
               if self.business!.schedule?.tueOpen == "Closed" || self.business!.schedule?.tueClose == "Closed" {
                   tueText.text = "Tue: Closed"
               }
               else {
                   tueText.text = "Tue: \(self.business!.schedule?.tueOpen ?? "")-\(self.business!.schedule?.tueClose ?? "")"
               }
               if self.business!.schedule?.wedOpen == "Closed" || self.business!.schedule?.wedClose == "Closed" {
                   wedText.text = "Wed: Closed"
               }
               else {
                   wedText.text = "Wed: \(self.business!.schedule?.wedOpen ?? "")-\(self.business!.schedule?.wedClose ?? "")"
               }
               if self.business!.schedule?.thuOpen == "Closed" || self.business!.schedule?.thuClose == "Closed" {
                   thuText.text = "Thu: Closed"
               }
               else {
                   thuText.text = "Thu: \(self.business!.schedule?.thuOpen ?? "")-\(self.business!.schedule?.thuClose ?? "")"
               }
               if self.business!.schedule?.friOpen == "Closed" || self.business!.schedule?.friClose == "Closed" {
                   friText.text = "Fri: Closed"
               }
               else {
                   friText.text = "Fri: \(self.business!.schedule?.friOpen ?? "")-\(self.business!.schedule?.friClose ?? "")"
               }
               if self.business!.schedule?.satOpen == "Closed" || self.business!.schedule?.satClose == "Closed" {
                   satText.text = "Sat: Closed"
               }
               else {
                   satText.text = "Sat: \(self.business!.schedule?.satOpen ?? "")-\(self.business!.schedule?.satClose ?? "")"
               }
           }
       }
    
    override init(frame: CGRect) {
           super.init(frame:frame);
           backgroundColor = .literGray;
           configureView();
       }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented");
       }
    
    lazy var followButton: UIButton = {
        let uib = Components().createNormalButton(title: "");
        uib.setHeight(height: 44);
        uib.setWidth(width: 100);
        uib.backgroundColor = .mainLav;
        uib.addTarget(self, action: #selector(follow_unfollow), for: .touchUpInside)
        uib.showsTouchWhenHighlighted = true;
        uib.setTitle("Unfollow", for: .normal);
        return uib;
    }()
    
    @objc func follow_unfollow() {
                let data = ["businessId": bID!, "userId": Utilities().getUserId()!]
                API().post(url: "http://localhost:4000/api/userSubscribe/unfollow", dataToSend: data) { (res) in
                    if res["statusCode"] as? Int == 200 {
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.3) {
                                                      [weak self] in
                                                      self?.alpha = 0;
                                self!.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self?.remove), userInfo: nil, repeats: false);
                            }
                        }
                    }
                }
            }
    
    
    @objc func remove() {
        self.delegate?.removeBusiness(index: self.index_!)
    }

    
    lazy var bookButton: UIButton = {
        let uib = Components().createNormalButton(title: "Book");
        uib.setWidth(width: 100);
        uib.setHeight(height: 44);
        uib.backgroundColor = .mainLav;
        uib.showsTouchWhenHighlighted = true;
        uib.addTarget(self, action: #selector(goToBooking), for: .touchUpInside);
        return uib;
    }()
    
    @objc func goToBooking() {
        delegate?.bookAtBusiness(business: business!)
    }
    
    lazy var viewButton: UIButton = {
        let uib = Components().createNormalButton(title: "View");
        uib.setWidth(width: 100);
        uib.setHeight(height: 44);
        uib.backgroundColor = .mainLav;
        uib.showsTouchWhenHighlighted = true;
        uib.addTarget(self, action: #selector(goToBusiness), for: .touchUpInside)
        return uib;
    }()
    
    @objc func goToBusiness() {
        delegate?.showBusiness(bpId: bID!);
    }
    
    var businessName: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 22);
        return uitv;
    }();
    
    var streetText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        return uitv;
    }()
    
     var cityText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        return uitv;
    }()
    
     var stateText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        return uitv;
    }()
    
    var zipText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        return uitv;
    }()
    
    var phoneText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        return uitv;
    }()
    
    var webText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        return uitv;
    }()
    
   private var sunText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        uitv.setHeight(height: 25);
        return uitv;
    }()
    
    private var monText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        uitv.setHeight(height: 25);
        return uitv;
    }()
    
    private var tueText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        uitv.setHeight(height: 25);
        return uitv;
    }()
    
    private var wedText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        uitv.setHeight(height: 25);
        return uitv;
    }()
    
    private var thuText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        uitv.setHeight(height: 25);
        return uitv;
    }()
    
    private var friText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        uitv.setHeight(height: 25);
        return uitv;
    }()
    
    private var satText: UITextView = {
        let uitv = Components().createSimpleText(text: "");
        uitv.font = .systemFont(ofSize: 14);
        uitv.setHeight(height: 25);
        return uitv;
    }()
    
    private let borderBottom: UIView = {
        let uiv = UIView();
        uiv.setHeight(height: 2);
        uiv.setWidth(width: UIScreen.main.bounds.width);
        uiv.backgroundColor = .black;
        return uiv;
    }()

    func configureView() {
        addSubview(businessName);
        businessName.centerTo(element: centerXAnchor);
        businessName.padTop(from: topAnchor, num: 0);
        addSubview(streetText);
        streetText.padTop(from: businessName.bottomAnchor, num: -2);
        streetText.padLeft(from: leftAnchor, num: 14);
        addSubview(cityText);
        cityText.padTop(from: streetText.bottomAnchor, num: -2);
        cityText.padLeft(from: leftAnchor, num: 14);
        addSubview(stateText);
        stateText.padTop(from: cityText.bottomAnchor, num: -2);
        stateText.padLeft(from: leftAnchor, num: 14);
        addSubview(zipText);
        zipText.padLeft(from: leftAnchor, num: 14);
        zipText.padTop(from: stateText.bottomAnchor, num: -2);
        addSubview(phoneText);
        phoneText.padTop(from: zipText.bottomAnchor, num: -2);
        phoneText.padLeft(from: leftAnchor, num: 14);
        addSubview(webText);
        webText.padLeft(from: leftAnchor, num: 14);
        webText.padTop(from: phoneText.bottomAnchor, num: -7);
        addSubview(borderBottom);
        borderBottom.padBottom(from: bottomAnchor, num: 0);
        borderBottom.centerTo(element: centerXAnchor);
        let stack = UIStackView(arrangedSubviews: [sunText, monText, tueText, wedText, thuText, friText, satText]);
        stack.axis = .vertical;
        stack.setHeight(height: 175);
        stack.setWidth(width: UIScreen.main.bounds.width / 2.2);
        addSubview(followButton);
        followButton.padBottom(from: bottomAnchor, num: 20);
        followButton.padLeft(from: leftAnchor, num: 20);
        addSubview(viewButton);
        viewButton.padBottom(from: bottomAnchor, num: 20);
        viewButton.centerTo(element: centerXAnchor);
        addSubview(bookButton);
        bookButton.padBottom(from: bottomAnchor, num: 20);
        bookButton.padRight(from: rightAnchor, num: 20);
        addSubview(stack);
        stack.padRight(from: rightAnchor, num: 0);
        stack.padTop(from: businessName.bottomAnchor, num: -2);
    }
}
