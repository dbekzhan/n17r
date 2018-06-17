//
//  InputTextValidation.swift
//  
//
//  Created by Dimash Bekzhan on 4/26/18.
//

import Foundation


// Validation for phone number, password, ver code
public class Validation: NSObject {
    static let shared = Validation()
    
    func callValidation(for values: (phoneNumber: String?, password: String?, verCode: String?), verificationHandler: (_ success: Bool) -> Void) -> [ValidationType : AlertMessages]? {
        
        var alertMessages: [ValidationType : AlertMessages]? = [ValidationType : AlertMessages]()
        
        guard let validationResults = Validation.shared.validate(values: (values.phoneNumber, .phoneNo), (values.password, .password), (values.verCode, .verCode)) else { return nil }
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
                case .phoneNo:
                    alertMessages?[.phoneNo] = messages[.phoneNo]
                case .password:
                    alertMessages?[.password] = messages[.password]
                case .verCode:
                    alertMessages?[.verCode] = messages[.verCode]
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
            case .phoneNo:
                if let tempValue = isValidString(text: value, regex: RegEx.phoneNo, emptyAlert: .emptyPhone, invalidAlert: .inValidPhone) {
                    results?[.phoneNo] = tempValue
                } else { results?[.phoneNo] = .success }
            case .verCode:
                if let tempValue = isValidString(text: value, regex: RegEx.verCode, emptyAlert: .emptyVerCode, invalidAlert: .inValidVerCode) {
                    results?[.verCode] = tempValue
                } else { results?[.verCode] = .success }
            case .password:
                if let tempValue = isValidString(text: value, regex: RegEx.password, emptyAlert: .emptyPassword, invalidAlert: .inValidPassword) {
                    results?[.password] = tempValue
                } else { results?[.password] = .success }
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
    
    // Validation cases
    enum ValidationResult {
        case success
        case failure(Alert, AlertMessages)
    }
    
    enum ValidationType {
        case phoneNo
        case verCode
        case password
    }
    
    // check password validation
    enum RegEx: String {
        case phoneNo = "^[0-9]{11}$"
        case verCode = "^[0-9]{6}$"
        case password = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=*[0-9])(?=.*[a-z]).{8-16}$"
    }
    
    enum Alert {
        case success
        case failure
        case error
    }
    
    enum AlertMessages: String {
        
        case defaultPhone = "Phone number starting with 8"
        case defaultVerCode = "Verification code received in an sms"
        case defaultPassword = "Password of length 8-16 character with "
        
        case inValidPhone = "Phone number is invalid for Kazakhstan region"
        case inValidVerCode = "Verification code should consist of 6 decimal digits"
        case inValidPassword = "Provide at least one capital, numeric and special character"
        
        case emptyPhone = "Empty Phone Number"
        case emptyVerCode = "Empty Verification Code"
        case emptyPassword = "Empty Password"
        
        // cases for password for sign-ins
        
        func localized() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}
