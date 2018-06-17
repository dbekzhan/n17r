//
//  AuthentificationBrain.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 2/23/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


// protocol determining main features of any class that handles authentication 
protocol Authenticator {
    // database link 
    var db: Firestore { get set }
    // type of the user 
    var typeIndex: Int { get set }
   
    func signUpUser(userName: String, email: String, password: String) -> Bool
    func signInUser(userName: String, email: String, password: String) -> Bool
}
// Enum cases used for convenient chaining 
enum AuthType: String {
    case signIn = "Sign In"
    case signUp = "Sign Up"
    
    static let authTypes = [signIn, signUp]
}

enum UserType: String {
    case Consumer, Supplier
    
    static let userTypes = [Consumer, Supplier]
}

// MARK:- Firebase Authentication Handler
class AuthenticationViewModel: Authenticator {
    // database link 
    var db = Firestore.firestore()
    
    func createUserInUsersCollection(userName: String, uid: String) -> Bool {
        var result = false
        let ref = self.db.collection("entities").document(uid)
        
        self.db.collection("users").document(userName).setData(["entity" : ref], options: SetOptions.merge()) { (err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                // successfully created user 
                result = true
            }
        }
        return result
    }
     
    func signUpUser(userName: String, email: String, password: String) -> Bool {
        var result = false
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)

            }
            
            if let uid = user?.uid {
                // create entity with uid as a primary key 
                self.db.collection("entities").document(uid).setData(["email" : email, "password": password], options: SetOptions.merge(), completion: { (storeError) in
                    if let err = storeError {
                        print(err.localizedDescription)
                    } else {
                        result = self.createUserInUsersCollection(userName: userName, uid: uid)
                    }
                })
            }
        }
        return result
    }
    
    func signInUser(userName: String, email: String, password: String) -> Bool {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            // successfully signed in the user
        }
        return true
    }
    
    var typeIndex = 0
    
}


// MARK:- Authentication Actions
extension AuthenticationViewController {
    // action called by authentication button in the viewcontroller 
    @objc func handleAuthentification(sender: UIButton) {
        // retrieve current user type based on selectedindex of segmentedcontrol 
        guard let userTitle = switchUserTypeSegmentedControl.titleForSegment(at: switchUserTypeSegmentedControl.selectedSegmentIndex) else { return }
        // enum instance of UserType based on retrieved title 
        guard let userType = UserType(rawValue: userTitle) else { return }
        
        print(userType.rawValue)
        
        // check selected auth path
        let authTitle = sender.currentTitle
        guard let userName = nickNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        let _ = Validation.shared.callValidation(for: (userName: userName, email: email, password: password), verificationHandler: { (isValid) in
            if isValid {
                var success = false
                if authTitle == AuthType.signIn.rawValue {
                    success = authenticationViewModel.signInUser(userName: userName, email: email, password: password)
                } else if authTitle == AuthType.signUp.rawValue {
                    success = authenticationViewModel.signUpUser(userName: userName, email: email, password: password)
                }
                
                if success {
                    // save logged users in standards defaults for future convenience - avoid unwanted repeatitions of authentication
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    self.present(MainTabBarController(), animated: true, completion: nil)
                }
            }
        })
    }
}

// MARK:- Text Fields' Input Validation
public class Validation: NSObject {
    static let shared = Validation()
    
    func callValidation(for values: (userName: String?, email: String?, password: String?), verificationHandler: (_ success: Bool) -> Void) -> [ValidationType : AlertMessages]? {
        
        var alertMessages: [ValidationType : AlertMessages]? = [ValidationType : AlertMessages]()
        
        guard let validationResults = Validation.shared.validate(values: (values.userName, .userName), (values.email, .email), (values.password, .password)) else { return nil }
        // create new dictionary that containts only pairs with .failure value and corresponding messages dictionary
        var messages: [ValidationType : AlertMessages] = [:]
        let failureResults = validationResults.filter({ (validType, validResult) -> Bool in
            if case .failure(_ , let message) = validResult {
                messages[validType] = message
                return true
            } else { return false }
        })
        
        if failureResults.isEmpty {
            // success
            verificationHandler(true)
            return nil
        } else {
            // something is wrong
            for result in failureResults {
                switch result.key {
                case .email:
                    alertMessages?[.email] = messages[.email]
                case .password:
                    alertMessages?[.password] = messages[.password]
                case .userName:
                    alertMessages?[.userName] = messages[.userName]
                }
            }
            verificationHandler(false)
            return alertMessages
        }
    }
    
    
    // main function that takes text value and its type, returns either .success or .failure with corresponding message
    func validate(values: (value: String?, ofType: ValidationType)...) -> [ValidationType : ValidationResult]? {
        var results: [ValidationType : ValidationResult]? = [ValidationType : ValidationResult]()
        
        for tuple in values {
            // proceed validation only if value is not nil
            guard let value = tuple.value else { continue }

            switch tuple.ofType {
            case .email:
                if let tempValue = isValidString(text: value, regex: RegEx.email, emptyAlert: .emptyEmail, invalidAlert: .inValidEmail) {
                    results?[.email] = tempValue
                } else { results?[.email] = .success }
            case .password:
                if let tempValue = isValidString(text: value, regex: RegEx.password, emptyAlert: .emptyPassword, invalidAlert: .inValidPassword) {
                    results?[.password] = tempValue
                } else { results?[.password] = .success }
            case .userName:
                if let tempValue = isValidString(text: value, regex: RegEx.userName, emptyAlert: .emptyUserName, invalidAlert: .inValidUserName) {
                    results?[.userName] = tempValue
                } else { results?[.userName] = .success }
            }
        }
        return results
    }
    
    // validates text value for presence and calls validation for its format
    func isValidString(text: String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages) -> ValidationResult? {
        // presence validation
        if text.isEmpty { return .failure(.error, emptyAlert) }
        // format validation
        if !isValidRegEx(text, regex) { return .failure(.error, invalidAlert) }
        
        return nil
    }
    // validates text input's format and returns Bool value
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
    
    // MARK: - Validation cases - for convenience 
    enum ValidationResult {
        case success
        case failure(Alert, AlertMessages)
    }
    
    enum ValidationType {
        case email
        case password
        case userName
    }
    // password validation regular expressions 
    enum RegEx: String {
        case email = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        case password = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z])[a-zA-Z0-9!?].{8,16}$"
        case userName = "^[a-zA-Z0-9\\_\\-]{5,16}$"
    }
    
    enum Alert {
        case success
        case failure
        case error
    }
    // messages for textfields' placeholders, and warning labels' messages 
    enum AlertMessages: String {
        
        case defaultEmail = "example@gmail.com"
        case defaultPassword = "Пароль от 8 до 16 символов"
        case defaultUserName = "Никнейм от 5 до 16 символов"
        
        case inValidEmail = "Почта неверного формата"
        case inValidPassword = "Проверьте длину; наличие цифры, заглавного и спец символа"
        case inValidUserName = "Проверьте длину; наличие точки недопустимо"
        
        case emptyEmail = "Почта не набрана"
        case emptyPassword = "Пароль не набран"
        case emptyUserName = "Никнейм не набран"
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}

