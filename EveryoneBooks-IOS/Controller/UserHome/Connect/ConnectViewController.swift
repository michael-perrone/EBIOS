import UIKit

class ConnectViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var friends: [Friend]? {
        didSet {
            collectionView.reloadData();
        }
    }
    
    lazy var searchButton: UIButton = {
        let uib = UIButton(type: .system);
        uib.setImage(UIImage(named: "business-search"), for: .normal);
        uib.tintColor = .black;
        uib.setHeight(height: 40);
        uib.addTarget(self, action: #selector(search), for: .touchUpInside);
        uib.setWidth(width: 40);
        return uib;
    }()
    
    @objc func search() {
        let svc = ConnectSearchViewController();
        self.present(svc, animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        configureView();
        getUserFriends();
    }
    
    func configureView() {
        navigationItem.title = "Connect";
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton);
        collectionView.register(ConnectCell.self, forCellWithReuseIdentifier: "Connect Cell")
        collectionView.backgroundColor = .mainLav;
    }
    
    func getUserFriends() {
        API().get(url: myURL + "connect", headerToSend: Utilities().getToken()) { res in
            print(res);
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let friends = friends {
            return friends.count;
        }
        else {
            return 0;
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Connect Cell", for: indexPath) as! ConnectCell;
        cell.configCell();
        if let friends = friends {
            
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fullWidth, height: 70);
    }
}


