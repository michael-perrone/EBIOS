import UIKit

class ProductUnselectedTableCell: ProductsSelectCell {
    
    var bColor: UIColor?;
    var tColor: UIColor?
    
    lazy var addProduct: UIButton = {
        let uib = UIButton(type: .system);
        uib.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)]), for: .normal);
        uib.setHeight(height: 34);
        uib.setWidth(width: 34);
        uib.showsTouchWhenHighlighted = true;
        uib.tintColor = .black;
        uib.addTarget(self, action: #selector(addThisProduct), for: .touchUpInside);
        return uib;
    }()
    
    func configureColor() {
        if let bColorHere = bColor {
            backgroundColor = bColorHere;
        }
        else {
            backgroundColor = .literGray;
        }
        if let tColorHere = tColor {
            productName.backgroundColor = tColorHere;
        }
        else {
            backgroundColor = .mainLav;
        }
        addSubview(addProduct);
        addProduct.padTop(from: topAnchor, num: 1);
        addProduct.padRight(from: rightAnchor, num: 0);
    }
    
    
    @objc func addThisProduct() {
        delegate?.addProduct(product: self.product!);
    }
}
