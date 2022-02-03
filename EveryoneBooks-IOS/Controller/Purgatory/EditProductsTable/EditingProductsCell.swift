import UIKit

class EditingProductsCell: UITableViewCell {

    var product: Product? {
        didSet {
            productName.text = product!.name;
        }
    }
    
    weak var delegate: EditProductsDelegate?
    
    var neededIndex: Int?;
    
    let productName: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 14);
        return uitv;
    }()
    
    
    lazy var smallXButton: UIButton = {
        let cancelB = UIButton(type: .system);
        let title = NSAttributedString(string: "x", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]);
        cancelB.setAttributedTitle(title, for: .normal);
        cancelB.tintColor = .black;
        cancelB.addTarget(self, action: #selector(removeProduct), for: .touchUpInside);
        return cancelB;
    }()
    
    @objc func removeProduct() {
        delegate?.removeProduct(product: product!, index: neededIndex!);
    }
    
    func configureCell() {
        contentView.addSubview(productName);
        productName.padTop(from: topAnchor, num: 1);
        productName.setHeight(height: 30);
        productName.padLeft(from: leftAnchor, num: 16);
        contentView.backgroundColor = .mainLav;
        contentView.addSubview(smallXButton);
        productName.setWidth(width: contentView.frame.width - smallXButton.frame.width - 42);
        smallXButton.padTop(from: contentView.topAnchor, num: 0);
        smallXButton.setHeight(height: contentView.frame.height - 8);
        smallXButton.padRight(from: rightAnchor, num: 0);
    }
}
