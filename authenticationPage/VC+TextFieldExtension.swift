//
//  AuthenticationVC+textfieldExtension.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 4/27/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

//MARK:- keyboard settings
extension AuthenticationViewController: UITextFieldDelegate {
    // Close keyboard when view is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Constraints on the maximum input length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case passwordTextField, nickNameTextField:
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            return true
        }
    }
    
    // Close keyboard when RETURN is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: Color.alert.value,
            .paragraphStyle: style
            ] as [NSAttributedStringKey : Any]
        
        switch textField {
            
        case nickNameTextField:
            guard let userName = textField.text else { break }
            
            if let validationAlerts = Validation.shared.callValidation(for: (userName: userName, email: nil, password: nil), verificationHandler: { (isValid) in
                if isValid {
                    nickNameAlertLabel.attributedText = NSAttributedString(string: "", attributes: attributes)
                    emailTextField.becomeFirstResponder()
                }
            }) {
                if let alertNickName = validationAlerts[.userName]?.rawValue {
                    nickNameAlertLabel.attributedText = NSAttributedString(string: alertNickName, attributes: attributes)
                    nickNameTextField.resignFirstResponder()
                }
            }
        case emailTextField:
            guard let userName = nickNameTextField.text else { break }
            guard let email = textField.text else { break }
            
            if let validationAlerts = Validation.shared.callValidation(for: (userName: userName, email: email, password: nil), verificationHandler: { (isValid) in
                if isValid {
                    [nickNameAlertLabel, emailAlertLabel].forEach({ (label) in
                        label.attributedText = NSAttributedString(string: "", attributes: attributes)
                    })
                    passwordTextField.becomeFirstResponder()
                }
            }) {
                if let alertNickName = validationAlerts[.userName]?.rawValue {
                    nickNameAlertLabel.attributedText = NSAttributedString(string: alertNickName, attributes: attributes)
                    emailTextField.resignFirstResponder()
                } else {
                    nickNameAlertLabel.attributedText = NSAttributedString(string: "", attributes: attributes)
                }
                if let alertEmail = validationAlerts[.email]?.rawValue {
                    emailAlertLabel.attributedText = NSAttributedString(string: alertEmail, attributes: attributes)
                    emailTextField.resignFirstResponder()
                } else {
                    emailAlertLabel.attributedText = NSAttributedString(string: "", attributes: attributes)
                }
            }
        case passwordTextField:
            guard let userName = nickNameTextField.text else { break }
            guard let email = emailTextField.text else { break }
            guard let password = textField.text else { break }
            
            if let validationAlerts = Validation.shared.callValidation(for: (userName: userName, email: email, password: password), verificationHandler: { (isValid) in
                if isValid {
                    [nickNameAlertLabel, emailAlertLabel, passwordAlertLabel].forEach({ (label) in
                        label.attributedText = NSAttributedString(string: "", attributes: attributes)
                    })
                    passwordTextField.resignFirstResponder()
                }
            }) {
                if let alertNickName = validationAlerts[.userName]?.rawValue {
                    nickNameAlertLabel.attributedText = NSAttributedString(string: alertNickName, attributes: attributes)
                } else {
                    nickNameAlertLabel.attributedText = NSAttributedString(string: "", attributes: attributes)
                    
                }
                if let alertEmail = validationAlerts[.email]?.rawValue {
                    emailAlertLabel.attributedText = NSAttributedString(string: alertEmail, attributes: attributes)
                } else {
                    emailAlertLabel.attributedText = NSAttributedString(string: "", attributes: attributes)
                }
                if let alertPassword = validationAlerts[.password]?.rawValue {
                    passwordAlertLabel.attributedText = NSAttributedString(string: alertPassword, attributes: attributes)
                } else {
                    passwordAlertLabel.attributedText = NSAttributedString(string: "", attributes: attributes)
                }
            }
            passwordTextField.resignFirstResponder()
        default:
            print("never executed")
        }
        return true
    }
}
