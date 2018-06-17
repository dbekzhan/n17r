//
//  UITextField+Extension.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 4/3/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

// MARK:- Default appearence text field
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
        print("width of \(view.frame.width), height of \(view.frame.height)")
        // self.rightView?.frame = CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height)
        self.rightViewMode = .always
    }
    
    func setLeftPaddingPoints(_ space: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
