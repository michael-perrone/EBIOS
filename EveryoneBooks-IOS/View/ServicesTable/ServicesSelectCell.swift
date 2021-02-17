import UIKit

class ServicesSelectCell: UITableViewCell {

    var service: Service? {
        didSet {
            serviceName.text = service?.serviceName;
            print("debugy", service!.serviceName)
        }
    }
    
    var added = false;
    
    weak var delegate: ServicesTableDelegate?;
    
    let serviceName: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    
    lazy var addService: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)]), for: .normal);
        uib.setHeight(height: 34);
        uib.setWidth(width: 34);
        uib.showsTouchWhenHighlighted = true;
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(addMinusThisService), for: .touchUpInside);
        return uib;
    }()
    
    
    @objc func addMinusThisService() {
        if !self.added {
            delegate?.addService(service: self.service!);
            self.added = true;
            DispatchQueue.main.async {
                self.backgroundColor = .darkGray;
                self.serviceName.backgroundColor = .darkGray;
                self.serviceName.textColor = .mainLav;
                self.addService.backgroundColor = .darkGray;
                self.addService.tintColor = .mainLav;
                self.addService.setAttributedTitle(NSAttributedString(string: "-", attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainLav, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 34)]), for: .normal);
            }
        } else {
            self.added = false;
            delegate?.minusService(service: self.service!);
            DispatchQueue.main.async {
                self.backgroundColor = .literGray;
                self.serviceName.backgroundColor = .literGray;
                self.serviceName.textColor = .black;
                self.addService.backgroundColor = .literGray;
                self.addService.tintColor = .black;
                self.addService.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 34)]), for: .normal);
            }
        }
    }
    
   
    func configureCell() {
        addSubview(serviceName);
        serviceName.padTop(from: topAnchor, num: 1);
        serviceName.setHeight(height: 30);
        serviceName.padLeft(from: leftAnchor, num: 16);
        addSubview(addService);
        addService.padRight(from: rightAnchor, num: 15);
        addService.padTop(from: topAnchor, num: 1);
        if added {
            backgroundColor = .darkGray;
        }
        else {
            backgroundColor = .literGray;
        }
    }
}
