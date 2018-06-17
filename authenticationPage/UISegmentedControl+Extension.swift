//
//  UISegmentedControl+Extension.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 4/9/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

public enum SegmentType {
    case standard
}

extension UISegmentedControl {
    
    public convenience init(items: [String], type: SegmentType, selectedIndex: Int) {
        self.init(items: items)
        self.selectedSegmentIndex = selectedIndex
        
        switch type {
        case .standard:
            self.tintColor = Color.controlSelection.value
            self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Color.mainText.value, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)], for: .selected)
            self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : Color.mainText.value, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], for: .normal)
            
            self.layer.borderColor = Color.border.value.cgColor
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 10.0
            self.layer.masksToBounds = true
//        default:
//            break
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
