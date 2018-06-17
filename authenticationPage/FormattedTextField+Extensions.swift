//
//  FormattedTextField+Extensions.swift
//  
//
//  Created by Dimash Bekzhan on 4/26/18.
//

import UIKit

protocol Formatable {
    func makeAsString(string: String) -> String
}

class DefaultTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textColor = Color.mainText.value
        self.tintColor = Color.mainText.value
        self.keyboardAppearance = .light
        self.autocorrectionType = .no
        
        let placeholder = NSMutableAttributedString()
        placeholder.setAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), .foregroundColor: Color.attributedText.value], range: NSRange(location: 0, length: placeholder.length))
        
        self.attributedPlaceholder = placeholder
        
        self.font = UIFont.systemFont(ofSize: 18)
        
        self.borderStyle = .roundedRect
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //        self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 0.2)
        self.setLeftPaddingPoints(20)
    }
    
    public convenience init(placeholder: String, rightView: UIView?) {
        self.init(frame: CGRect.zero)
        self.placeholder = placeholder
        if let rightView = rightView {
            setRightView(view: rightView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRightView(view: UIView) {
        self.rightView = view
        self.rightView?.frame = CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height)
        self.rightViewMode = .always
    }
    
    func setLeftPaddingPoints(_ space: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

class FormattedTextField: DefaultTextField, Formatable {
    
    var formattingPattern = ""
    var replacementChar: Character = "*"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(placeholder: String, formattingPattern: String) {
        self.init(frame: CGRect.zero)
        self.placeholder = placeholder
        self.formattingPattern = formattingPattern
        registerForNotifications()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func makeAsString(string: String) -> String {
        
        return string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator:"")
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChange), name: .UITextFieldTextDidChange, object: self)
    }
    
    @objc func textDidChange() {
        
        guard let text = self.text else { return }
        if formattingPattern.count > 0 {
            
            let tempString = makeAsString(string: text)
            
            var finalText = ""
            var stop = false
            
            var formatterIndex = formattingPattern.startIndex
            var tempIndex = tempString.startIndex
            
            while !stop {
                
                let endIndex = formattingPattern.index(formatterIndex, offsetBy: 1)
                
                if formattingPattern[formatterIndex..<endIndex] != String(replacementChar) {
                    finalText.append(String(formattingPattern[formatterIndex..<endIndex]))
                } else if tempString.count > 0 {
                    let index = tempString.index(tempIndex, offsetBy: 1)
                    finalText.append(String(tempString[tempIndex..<index]))
                    tempIndex = tempString.index(after: tempIndex)
                }
                
                formatterIndex = formattingPattern.index(after: formatterIndex)
                
                
                if formatterIndex >= formattingPattern.endIndex || tempIndex >= tempString.endIndex {
                    stop = true
                }
            }
            
            self.text = finalText
        }
    }
}
