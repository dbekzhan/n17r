//
//  ViewController.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 2/9/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit
import FirebaseFirestore


class AuthenticationViewController: UIViewController {
    
    // MARK:- Dependencies
    var authenticationViewModel: Authenticator!
    
    
    // MARK:- UI Objects
    private(set) lazy var nickNameTextField: DefaultTextField = {
        let textField = DefaultTextField(placeholder: Validation.AlertMessages.defaultUserName.rawValue, rightView: nil)
        textField.keyboardType = .default
        textField.returnKeyType = .continue
        return textField
    }()
    
    private(set) lazy var emailTextField: DefaultTextField = {
        let textField = DefaultTextField(placeholder: Validation.AlertMessages.defaultEmail.rawValue, rightView: nil)
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .continue
        return textField
    }()
    
    private(set) lazy var passwordTextField: DefaultTextField = {
        let textField = DefaultTextField(placeholder: Validation.AlertMessages.defaultPassword.rawValue, rightView: showPasswordButton)
        textField.returnKeyType = .continue
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private(set) lazy var showPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "password"), for: .normal)
        button.tintColor = Color.mainText.value
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        return button
    }()
    
    private(set) lazy var nickNameAlertLabel: DefaultAlertLabel = {
        let label = DefaultAlertLabel(text: "")
        return label
    }()
    
    private(set) lazy var emailAlertLabel: DefaultAlertLabel = {
        let label = DefaultAlertLabel(text: "")
        return label
    }()
    
    private(set) lazy var passwordAlertLabel: UILabel = {
        let label = UILabel()
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: Color.alert.value,
            .paragraphStyle: style
            ] as [NSAttributedStringKey : Any]
        label.attributedText = NSAttributedString(string: "", attributes: attributes)
        label.numberOfLines = 0
        label.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var stackViewTextFields: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nickNameAlertLabel, nickNameTextField, emailAlertLabel, emailTextField, passwordAlertLabel, passwordTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 3.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private(set) lazy var handleAuthButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(Color.mainText.value, for: .normal)
        button.tintColor = Color.controlSelection.value
        
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = Color.border.value.cgColor
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAuthentification), for: .touchUpInside)
        return button
    }()
    
    // switch between accounts
    private(set) lazy var switchUserTypeSegmentedControl: UISegmentedControl = {
        // set a list of users - respective discrete buttons
        let users = UserType.userTypes.map { $0.rawValue }
        let segControl = UISegmentedControl(items: users, type: .standard, selectedIndex: 1)
        return segControl
    }()
    
    private(set) lazy var authenticationTypeSegmentedControl: UISegmentedControl = {
        let titles = AuthType.authTypes.map { $0.rawValue }
        let segControl = UISegmentedControl(items: titles, type: .standard, selectedIndex: 0)
        segControl.addTarget(self, action: #selector(handleAuthChoice), for: .valueChanged)
        return segControl
    }()
    
    @objc private func showPassword() {
        let currentState = passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = !currentState
    }
    
    @objc func handleAuthChoice(sender: UISegmentedControl) {
        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)
        handleAuthButton.setTitle(title, for: .normal)
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstrains()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUpView() {
        self.view.backgroundColor = Color.background.value
        self.emailTextField.delegate = self
        // error was here - the delegate property assignment was missing - hence
        // text field could not respond 
        self.passwordTextField.delegate = self
        
        self.nickNameTextField.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        self.view.addSubview(authenticationTypeSegmentedControl)
        self.view.addSubview(stackViewTextFields)
        self.view.addSubview(switchUserTypeSegmentedControl)
        self.view.addSubview(handleAuthButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AuthenticationViewController {
    
    //MARK: - Actions
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "System message", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK:- Add UI Objects and Set Constrains
extension AuthenticationViewController {
    
    private func setUpConstrains() {
        
        let widthAnchor = self.view.widthAnchor
        
        
        stackViewTextFields.locateCenter(inRelationTo: self.view, withPadding: (x: 0, y: -20))
        authenticationTypeSegmentedControl.locateCenter(inRelationTo: self.view, withPadding: nil, inAxises: (x: true, y: false))
        switchUserTypeSegmentedControl.locateCenter(inRelationTo: self.view, withPadding: nil, inAxises: (x: true, y: false))
        handleAuthButton.locateCenter(inRelationTo: self.view, withPadding: nil, inAxises: (x: true, y: false))
        
        stackViewTextFields.setAnchor(widthAnchor: widthAnchor, heightAnchor: nil, withPadding: (x: -40, y: 0), width: nil, height: 300)
        authenticationTypeSegmentedControl.setAnchor(widthAnchor: widthAnchor, heightAnchor: nil, withPadding: (x: -40, y: 0), width: nil, height: UIControl.defaultHeight)
        switchUserTypeSegmentedControl.setAnchor(widthAnchor: widthAnchor, heightAnchor: nil, withPadding: (x: -40, y: 0), width: nil, height: UIControl.defaultHeight)
        handleAuthButton.setAnchor(widthAnchor: widthAnchor, heightAnchor: nil, withPadding: (x: -40, y: 0), width: nil, height: UIControl.defaultHeight)
        
        authenticationTypeSegmentedControl.bottomAnchor.constraint(equalTo: stackViewTextFields.topAnchor, constant: -10).isActive = true
        switchUserTypeSegmentedControl.bottomAnchor.constraint(equalTo: handleAuthButton.topAnchor, constant: -10).isActive = true
        handleAuthButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
    }
}
