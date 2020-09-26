import UIKit

class LoginController: UIViewController {
    
    var selected = "";
    // MARK: - Properties
    
    private let logoText: UIImageView = {
        let uiiv = UIImageView();
        uiiv.image = UIImage(named: "logo-medium");
        return uiiv;
    }()
    
    private let emailLoginText: UITextField = {
        let tf = UITextField();
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        tf.font = .systemFont(ofSize: 22);
        return tf;
    }()
    
    private let passwordLoginText: UITextField = {
        let tf = UITextField();
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        tf.isSecureTextEntry = true;
        tf.font = .systemFont(ofSize: 22);
        return tf;
    }()
    
    lazy var loginInput: UIView = {
        let uiv = Components().createInput( textField: emailLoginText, view: view, typeOfInput: "mail")
        return uiv;
    }()
    
    lazy var passwordInput: UIView = {
        let uiv = Components().createInput(textField: passwordLoginText, view: view, typeOfInput: "lock")
        return uiv;
    }()
    
    
    private let loginButton: UIButton = {
        let uib = Components().createNormalButton(title: "Login");
        uib.titleLabel?.font = .boldSystemFont(ofSize: 24)
        uib.addTarget(self, action: #selector(login), for: .touchUpInside);
        uib.backgroundColor = .white;
        return uib;
    }()
    
    
    lazy var registerAsUserButton: UIButton = {
        let uib = Components().createFrontButtons(title: "Register As User", view: view);
        uib.addTarget(self, action: #selector(goToRegisterUser), for: .touchUpInside);
        return uib;
    }()
    
    lazy var registerAsEmployeeButton: UIButton = {
        let uib = Components().createFrontButtons(title: "Register As Employee", view: view);
        uib.addTarget(self, action: #selector(goToRegisterEmployee), for: .touchUpInside);
        return uib;
    }()
    
    lazy var registerAsAdminButton: UIButton = {
        let uib = Components().createFrontButtons(title: "Register As Admin", view: view);
        uib.addTarget(self, action: #selector(goToRegisterAdmin), for: .touchUpInside);
        return uib;
    }()
    
    
    //MARK: - Selectors
    
    @objc func login() {
        if let email = emailLoginText.text, let password = passwordLoginText.text {
           
            let credentials = ["email": email, "password": password];
           
            BasicCalls().login(credentials: credentials) { (token, loggingIn) in
                if loggingIn == "admin" {
                    if Utilities().setTokenInKeyChain(token: token, key: "adminToken") {
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(AdminHomeController(), animated: true);
                        }
                    }
                }
                else if loggingIn == "employee" {
                    if Utilities().setTokenInKeyChain(token: token, key: "employeeToken") {
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(EmployeeHomeController(), animated: true);
                        }
                    }
                }
                else if loggingIn == "user" {
                    if Utilities().setTokenInKeyChain(token: token, key: "token") {
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(UserHomeViewController(), animated: true);
                        }
                        
                    }
                }
            }
        }
    }
    
    @objc func goToRegisterUser() {
        navigationController?.pushViewController(RegisterUserController(), animated: true);
    }
    
    @objc func goToRegisterEmployee() {
        navigationController?.pushViewController(RegisterEmployeeController(), animated: true);
    }
    
    @objc func goToRegisterAdmin() {
        navigationController?.pushViewController(RegisterAdminController(), animated: true);
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true;
        view.backgroundColor = .mainLav;
        
        view.addSubview(logoText);
        logoText.padTop(from: view.safeAreaLayoutGuide.topAnchor, num: 15);
        logoText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        logoText.setWidth(width: 60);
        logoText.setHeight(height: 60);
        
        view.addSubview(loginInput);
        loginInput.padTop(from: logoText.bottomAnchor, num: 40);
        loginInput.centerTo(element: view.centerXAnchor);
        
        view.addSubview(passwordInput);
        passwordInput.padTop(from: loginInput.bottomAnchor, num: 30);
        passwordInput.centerTo(element: view.centerXAnchor);
        
        view.addSubview(loginButton)
        loginButton.padTop(from: passwordInput.bottomAnchor, num: 20);
        loginButton.setHeight(height: 46);
        loginButton.centerTo(element: view.centerXAnchor);
        loginButton.setWidth(width: 120);
        
        view.addSubview(registerAsUserButton);
        registerAsUserButton.padTop(from: loginButton.bottomAnchor, num: view.frame.height / 6);
        registerAsUserButton.centerTo(element: view.centerXAnchor);
        
        view.addSubview(registerAsEmployeeButton);
        registerAsEmployeeButton.padTop(from: registerAsUserButton.bottomAnchor, num: view.frame.height / 20);
        registerAsEmployeeButton.centerTo(element: view.centerXAnchor);
        
        view.addSubview(registerAsAdminButton);
        registerAsAdminButton.padTop(from: registerAsEmployeeButton.bottomAnchor, num: view.frame.height / 20);
        registerAsAdminButton.centerTo(element: view.centerXAnchor);
        
    }
    
}
