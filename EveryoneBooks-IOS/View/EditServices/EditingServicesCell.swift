import UIKit

class EditingServicesCell: UITableViewCell {

    var service: Service? {
        didSet {
            serviceName.text = service?.serviceName;
            
        }
    }
    
    weak var delegate: EditServicesDelegate?;
    
    var neededIndex: Int?;
    
    let serviceName: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        return uitv;
    }()
    
    
    lazy var smallXButton: UIButton = {
        let cancelB = UIButton(type: .system);
        let title = NSAttributedString(string: "x", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]);
        cancelB.setAttributedTitle(title, for: .normal);
        cancelB.tintColor = .black;
        cancelB.addTarget(self, action: #selector(removeService), for: .touchUpInside);
        return cancelB;
    }()
    
    @objc func removeService() {
        delegate?.removeService(service: service!, index: neededIndex!);
    }
    
    func configureCell() {
        contentView.addSubview(serviceName);
        serviceName.padTop(from: topAnchor, num: 1);
        serviceName.setHeight(height: 30);
        serviceName.padLeft(from: leftAnchor, num: 16);
        contentView.backgroundColor = .mainLav;
        contentView.addSubview(smallXButton);
        serviceName.setWidth(width: contentView.frame.width - smallXButton.frame.width - 42);
        smallXButton.padTop(from: contentView.topAnchor, num: 0);
        smallXButton.setHeight(height: contentView.frame.height - 8);
        smallXButton.padRight(from: rightAnchor, num: 0);
    }
}
