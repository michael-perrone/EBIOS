
import UIKit

class MenuCell: UITableViewCell {
    
    var clickedDelegate: MenuCellClicked?
    
    var selectionItem: SelectionItem? {
        didSet {
            
            simage.text = selectionItem?.image;
            text1.text = selectionItem?.title;
        }
    }
    
    private let simage: UITextView = {
        let uiiv = Components().createSimpleText(text: "");
        uiiv.font = .systemFont(ofSize: 28);
        uiiv.backgroundColor = .white;
        return uiiv;
    }()
    
    private let text1: UITextView = {
        let uiiv = Components().createSimpleText(text: "");
        uiiv.font = .systemFont(ofSize: 18);
        uiiv.backgroundColor = .white;
        uiiv.isUserInteractionEnabled = true;
        return uiiv;
    }()

    @objc func cellClicked() {
        if text1.text == "Logout" {
            clickedDelegate?.logout();
        }
        else {
            if let selectionItem = selectionItem {
                clickedDelegate?.cellClicked(vc: selectionItem.vc!);
            }
            
        }
    }
    
    func configureCell() {
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(cellClicked))
        contentView.addSubview(simage)
        simage.padLeft(from: leftAnchor, num: 4);
        simage.padTop(from: topAnchor, num: -2);
        contentView.addSubview(text1);
        text1.padTop(from: topAnchor, num: 4);
        text1.padLeft(from: simage.rightAnchor, num: 0);
        text1.addGestureRecognizer(tapGest);
    }

}
