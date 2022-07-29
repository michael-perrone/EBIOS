import UIKit

class ServicesSelectCell: UITableViewCell {
    
    var shortText: Bool? {
        didSet {
            if shortText! {
                serviceName.text = String(service!.serviceName.prefix(12) + "...");
            }
        }
    }
    
    var numForChars: Int?

    var service: Service? {
        didSet {
            if let numForChars = numForChars {
                serviceName.text = Utilities().cutStringIfNeeded(string: service!.serviceName, num: numForChars);
            }
            else {
                serviceName.text = service?.serviceName;
            }
        }
    }
    
    var added = false;
    
    weak var delegate: ServicesTableDelegate?;
    
    let serviceName: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    func configureName() {
        addSubview(serviceName);
        serviceName.padTop(from: topAnchor, num: 8);
        serviceName.setHeight(height: 30);
        serviceName.padLeft(from: leftAnchor, num: 2);
    }
}
