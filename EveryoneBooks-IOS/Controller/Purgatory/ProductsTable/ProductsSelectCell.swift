import UIKit

class ProductsSelectCell: UITableViewCell {
    
    var shortText: Bool? {
        didSet {
            if shortText! {
                productName.text = String(product!.name.prefix(12) + "...");
            }
        }
    }

    var product: Product? {
        didSet {
            productName.text = product?.name;
        }
    }
    
    var added = false;
    
    weak var delegate: ProductsTableDelegate?;
    
    let productName: UITextView = {
        let uitv = Components().createLittleText(text: "");
        uitv.font = .boldSystemFont(ofSize: 16);
        return uitv;
    }()
    
    func configureName() {
        addSubview(productName);
        productName.padTop(from: topAnchor, num: 1);
        productName.setHeight(height: 30);
        productName.padLeft(from: leftAnchor, num: 16);
    }
}
