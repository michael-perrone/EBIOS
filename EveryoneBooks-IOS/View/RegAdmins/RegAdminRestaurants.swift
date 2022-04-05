import Foundation
import UIKit

class RegAdminRestaurants: UIView {
    
    private let directionsButton = Components().createFrontButtons(title: "Build Directions", view: UIView());
    
    private let exampleButton = Components().createFrontButtons(title: "Example Build", view: UIView());
    
    private let getStartedButton: UIButton = {
        let gsb = Components().createFrontButtons(title: "Get Started!", view: UIView());
        gsb.addTarget(self, action: #selector(goToBuilder), for: .touchUpInside);
        return gsb;
    }()
    

    
    @objc func goToBuilder() {
        delegate?.goToView(view: RestaurantBuilder());
    }
    
    weak var delegate: RegisterAdminController?;
    
    private let titleText: UITextView = {
        let uitv = UITextView();
        uitv.font = .boldSystemFont(ofSize: 20);
        uitv.text = "Restaurant Builder";
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .clear;
        return uitv;
    }()
    
 
    
    
    private let infoText: UITextView = {
        let uitv = UITextView();
        uitv.isEditable = false;
        uitv.isScrollEnabled = false;
        uitv.backgroundColor = .clear;
        uitv.text = "Welcome to the EveryoneBooks Restaurant Builder where you will create the layout for your restaurant. To do this, you will map out a replica layout of your restaurant. Start by choosing from the options below.";
        uitv.font = .systemFont(ofSize: 16);
        uitv.setWidth(width: fullWidth - 20);
        return uitv;
    }()

    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero);
        configureView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(titleText);
        titleText.padTop(from: topAnchor, num: 0);
        titleText.centerTo(element: centerXAnchor);
        addSubview(infoText);
        infoText.padTop(from: titleText.bottomAnchor, num: 8);
        infoText.padLeft(from: leftAnchor, num: 10);
        let stack = UIStackView(arrangedSubviews: [directionsButton, exampleButton, getStartedButton]);
        addSubview(stack);
        stack.distribution = .equalSpacing;
        stack.axis = .vertical;
        stack.setHeight(height: fullHeight / 2.8);
        stack.setWidth(width: fullWidth / 1.3);
        stack.padTop(from: infoText.bottomAnchor, num: 70);
        stack.centerTo(element: centerXAnchor);
       
    }
}
