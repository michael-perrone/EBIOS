import UIKit

class EditProductsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var products: [Product]? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData();
            }
        }
    }
    
    weak var otherDelegate: EditProductsDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: UITableView.Style.plain);
        delegate = self;
        dataSource = self;
        register(EditingProductsCell.self, forCellReuseIdentifier: "EPC");
        backgroundColor = .mainLav;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var any = "D";
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = self.products {
            return products.count;
        }
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "EPC", for: indexPath) as! EditingProductsCell;
        cell.selectionStyle = .none;
        if let products = self.products {
            if indexPath.row < products.count {
                cell.delegate = otherDelegate;
                cell.neededIndex = indexPath.row;
                cell.product = products[indexPath.row];
                cell.configureCell()
          
            }
        }
        return cell;
    }
    
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          // return 40;
    //}


}
