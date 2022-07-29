import UIKit

class BcnSelectorCollectionCell: UICollectionViewCell {
    
    weak var del: BookingHit?;
    
    weak var fromNotiDel: FromNotiBcnSelector?;
    
    var bcn: Int? {
        didSet {
            bcnText.text = String(bcn!);
        }
    }
    
    let topBorder = Components().createBorder(height: 1, width: 30, color: .black);
    let bottomBorder = Components().createBorder(height: 1, width: 30, color: .black);
    let leftBorder = Components().createBorder(height: 30, width: 1, color: .black);
    let rightBorder = Components().createBorder(height: 30, width: 1, color: .black);

    
    let bcnText = Components().createSimpleText(text: "");
    
    func layoutCell() {
        contentView.addSubview(bcnText);
        bcnText.centerTo(element: contentView.centerXAnchor);
        bcnText.padTop(from: contentView.topAnchor, num: 5);
        bcnText.setHeight(height: 40);
        bcnText.setWidth(width: 40);
        let tapped = UITapGestureRecognizer(target: self, action: #selector(iveBeenTapped));
        contentView.addGestureRecognizer(tapped);
        bcnText.addGestureRecognizer(tapped);
        bcnText.textAlignment = .center;
        bcnText.backgroundColor = .mainLav;
        contentView.setHeight(height: 40);
        contentView.setWidth(width: 40);
    }
    
    @objc func iveBeenTapped() {
        if let del = del {
            del.selectBcn(num: bcn!);
        }
        else if let fromNotiDel = fromNotiDel {
            fromNotiDel.notiBcnSelector(num: bcn!);
        }
       
    }
}
