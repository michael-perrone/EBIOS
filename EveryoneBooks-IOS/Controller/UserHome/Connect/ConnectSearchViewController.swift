import Foundation
import UIKit


class ConnectSearchViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainLav;
        configureSearchView();
    }
    
    private let searchTable = SearchTable();
    
    private let peopleFound: [Customer] = [];
    
    private let searchPeopleTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Search fellow Everyone-Bookers", fontSize: 20);
        uitf.setWidth(width: fullWidth / 1.3);
        return uitf;
    }();
    

    private let searchButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.addTarget(self, action: #selector(search), for: .touchUpInside);
        uib.setImage(UIImage(named: "sc"), for: .normal);
        uib.tintColor = .black;
        return uib;
    }()
    
    @objc func search() {
        let data = ["searchText": searchPeopleTextField.text!];
        API().post(url: myURL + "connect/search", headerToSend: Utilities().getToken(), dataToSend: data) { res in
            if let customers = res["user"] as? [[String: Any]] {
                var peopleArray: [Customer] = [];
            }
        }
    }
    
    lazy var searchPeopleInput: UIView = {
        let uiv = Components().createInput(textField: searchPeopleTextField, view: view, width: fullWidth / 1.3);
        return uiv;
    }();
    
    func configureSearchView() {
        view.addSubview(searchPeopleInput);
        searchPeopleInput.padLeft(from: view.leftAnchor, num: 20);
        searchPeopleInput.padTop(from: view.topAnchor, num: 40);
        view.addSubview(searchButton);
        searchButton.padLeft(from: searchPeopleInput.rightAnchor, num: 10);
        searchButton.padTop(from: view.topAnchor, num: 30);
    }
}

