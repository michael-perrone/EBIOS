//
//  BioController.swift
//  EveryoneBooks-IOS
//
//  Created by Michael Perrone on 6/7/20.
//  Copyright © 2020 Michael Perrone. All rights reserved.
//

import UIKit

protocol RemoveProductProtocol: Products {
    func removeProduct(productName: String?, index: Int);
}

class Products: UIViewController, RemoveProductProtocol {
    
    func removeProduct(productName: String?, index: Int) {
        if let name = productName {
            API().post(url: myURL + "businessProfile/removeProduct", headerToSend: Utilities().getAdminToken(),                                                            dataToSend: ["name": name]) { (res) in
                if res["statusCode"] as? Int == 200 {
                    print(index)
                    print("INDEX IS ABOVE")
                    self.products!.remove(at: index);
                }
            }
        }
    }
    
    var products: [Product]? = [] {
        didSet {
            print(products)
            productsTable.products = self.products;
        }
    }
    
    private let productsTable: ProductTable = {
        let pt = ProductTable();
        return pt;
    }();
    
    private let ourProducts: UITextView = {
        let uitv = Components().createSimpleText(text: "Current Products");
        uitv.backgroundColor = .mainLav;
        return uitv;
    }()
    
    private let opd = Components().createBorder(height: 1, width: 180, color: .black);
    
    private let productTextField: UITextField = {
        let ptf = Components().createTextField(placeHolder: "Product Name", fontSize: 18);
        return ptf;
    }()
    
    lazy var productTextInput: UIView = {
        let pti = Components().createInput(textField: productTextField, view: view, width: 300);
        return pti;
    }()
    
    private let productCostTextField: UITextField = {
        let uitf = Components().createTextField(placeHolder: "Price", fontSize: 18);
        uitf.keyboardType = .decimalPad;
        return uitf;
    }();
    
    lazy var productCostInput: UIView = {
        let uiv = Components().createInput(textField: productCostTextField, view: view, width: 110);
        return uiv;
    }()
    
    private let addProductButton: UIButton = {
        let uib = Components().createNormalButton(title: "Add Product");
        uib.setHeight(height: 40);
        uib.setWidth(width: 180);
        uib.addTarget(self, action: #selector(addProduct), for: .touchUpInside);
        return uib;
    }()
    
    @objc func addProduct() {
        print("anyhting")
        var changingProducts: [Product] = [];
        if let productText = productTextField.text, let costText = productCostTextField.text {
            var correctCostText = "";
            var splitCostText = costText.split(separator: ".");
            if splitCostText.count == 1 {
                correctCostText = splitCostText[0] + ".00";
            }
            else if splitCostText.count == 2 {
                if splitCostText[1].count == 1 {
                    splitCostText[1] = "." + splitCostText[1] + "0";
                    correctCostText = String(splitCostText[0]) + String(splitCostText[1]);
                    print(correctCostText)
                }
                else if splitCostText[1].count > 2 {
                    let notValidNumberController = UIAlertController(title: "Error", message: "Please enter a number with only two decimal points", preferredStyle: .alert);
                    let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil);
                    notValidNumberController.addAction(okayButton);
                    DispatchQueue.main.async {
                        self.present(notValidNumberController, animated: true, completion: nil);
                    }
                    return;
                }
                else {
                    correctCostText = costText;
                }
            }
            else {
                let notValidNumberController = UIAlertController(title: "Error", message: "The text you entered in the product cost text field is not a valid number.", preferredStyle: .alert);
                let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil);
                notValidNumberController.addAction(okayButton);
                DispatchQueue.main.async {
                    self.present(notValidNumberController, animated: true, completion: nil);
                }
                return;
            }
            if let doubleCost = Double(correctCostText) {
                print("GOOD")
            }
            else {
                print(correctCostText)
                print("HUH")
                let notValidNumberController = UIAlertController(title: "Error", message: "The text you entered in the product cost text field is not a valid number.", preferredStyle: .alert);
                let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil);
                notValidNumberController.addAction(okayButton);
                DispatchQueue.main.async {
                    self.present(notValidNumberController, animated: true, completion: nil);
                }
                return;
            }
            changingProducts = self.products!;
            changingProducts.append(Product(name: productText, price: correctCostText, idParam: nil));
            self.products = changingProducts;
            API().post(url: myURL + "businessProfile/addproduct", headerToSend: Utilities().getAdminToken(), dataToSend: ["price": correctCostText, "name": productText]) { (res) in
                print(res)
                if res["statusCode"] as? Int == 200{
                    print("good")
                }
            }
        }
        else {
            print("product info not filled out")
        }
    }
    
    private let dollarSign: UITextView = {
        let ds = UITextView();
        ds.isScrollEnabled = false;
        ds.text = "$";
        ds.isEditable = false;
        ds.font = .systemFont(ofSize: 24);
        ds.setWidth(width: 24);
        ds.setHeight(height: 32);
        ds.backgroundColor = .clear;
        return ds;
    }();

    lazy var leftBarButton: UIButton = {
        let uib = Components().createHelpLeftButton();
        uib.addTarget(self, action: #selector(help), for: .touchUpInside)
        return uib;
    }()
    
    @objc func help() {
        let help = EditBusinessHelp(collectionViewLayout: UICollectionViewFlowLayout());
        help.modalPresentationStyle = .fullScreen;
        self.present(help, animated: true, completion: nil);
    }
    
    @objc func done() {
        self.dismiss(animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    
        
    func configureView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton);
        view.backgroundColor = .mainLav;
        navigationItem.title = "Products";
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        configureSubViews()
        getProducts()
    }
    
    func getProducts() {
        API().get(url: myURL + "businessProfile/getProducts", headerToSend: Utilities().getAdminToken()) { (res) in
            print(res)
            if let products = res["products"] as? [[String: Any]] {
                var toBeProducts: [Product] = [];
                for product in products {
                    let newProduct = Product(name: product["name"] as! String, price: product["cost"] as! String, idParam: product["_id"] as! String);
                    toBeProducts.append(newProduct)
                }
                print(toBeProducts);
                self.products = toBeProducts;
            }
        }
    }
    
    func configureSubViews() {
        productsTable.otherDelegate = self;
        view.addSubview(productTextInput);
        productTextInput.centerTo(element: view.centerXAnchor);
        productTextInput.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 20);
        view.addSubview(productCostInput);
        productCostInput.padLeft(from: productTextInput.leftAnchor, num: 0);
        productCostInput.padTop(from: productTextInput.bottomAnchor, num: 20);
        view.addSubview(dollarSign);
        dollarSign.padRight(from: productCostInput.leftAnchor, num: -2);
        dollarSign.padTop(from: productCostInput.topAnchor, num: -1);
        view.addSubview(addProductButton);
        addProductButton.padLeft(from: productCostInput.rightAnchor, num: 20);
        addProductButton.padTop(from: productTextInput.bottomAnchor, num: 20);
        view.addSubview(ourProducts);
        ourProducts.padTop(from: addProductButton.bottomAnchor, num: 40);
        ourProducts.centerTo(element: view.centerXAnchor);
        view.addSubview(opd);
        opd.centerTo(element: ourProducts.centerXAnchor);
        opd.padTop(from: ourProducts.bottomAnchor, num: 0);
        view.addSubview(productsTable);
        productsTable.padTop(from: opd.bottomAnchor, num: 8);
        productsTable.centerTo(element: view.centerXAnchor);
        productsTable.setWidth(width: fullWidth / 1.06);
        productsTable.setHeight(height: 320);
    }
}
