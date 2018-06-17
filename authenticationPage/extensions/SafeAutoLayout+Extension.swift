//
//  SafeAutoLayout+Extension.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 4/3/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

extension UIView {
    
    func locateCenter(inRelationTo superview: UIView, withPadding padding: (x: CGFloat, y: CGFloat)?, inAxises axises: (x: Bool, y: Bool) = (true, true)) {
        
        let padding = padding ?? (0, 0)
        
        self.setAnchor(centerXAnchor: (axises.x ? superview.centerXAnchor : nil),
                       centerYAnchor: (axises.y ? superview.centerYAnchor : nil),
                       top: nil,
                       left: nil,
                       bottom: nil,
                       right: nil,
                       widthAnchor: nil,
                       heightAnchor: nil,
                       paddingCenterX: padding.x,
                       paddingCenterY: padding.y)
    }
    
    func setAnchor(widthAnchor: NSLayoutDimension?, heightAnchor: NSLayoutDimension?, withPadding padding: (x: CGFloat, y: CGFloat)?, width: CGFloat?, height: CGFloat?) {
        
        let padding = padding ?? (0, 0)
        
        self.setAnchor(centerXAnchor: nil,
                       centerYAnchor: nil,
                       top: nil,
                       left: nil,
                       bottom: nil,
                       right: nil,
                       widthAnchor: widthAnchor ?? nil,
                       heightAnchor: heightAnchor ?? nil,
                       paddingCenterX: 0,
                       paddingCenterY: 0,
                       paddingWidth: padding.x,
                       paddingHeight: padding.y,
                       paddingTop: 0,
                       paddingLeft: 0,
                       paddingBottom: 0,
                       paddingRight: 0,
                       width: width ?? 0,
                       height: height ?? 0)
    }
    
    func setAnchor(centerXAnchor: NSLayoutXAxisAnchor?, centerYAnchor: NSLayoutYAxisAnchor?, top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,
                   bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, widthAnchor: NSLayoutDimension?, heightAnchor: NSLayoutDimension?,
                   paddingCenterX: CGFloat = 0, paddingCenterY: CGFloat = 0, paddingWidth: CGFloat = 0, paddingHeight: CGFloat = 0, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0,
                   paddingRight: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let centerXAnchor = centerXAnchor {
            self.centerXAnchor.constraint(equalTo: centerXAnchor, constant: paddingCenterX).isActive = true
        }
        
        if let centerYAnchor = centerYAnchor {
            self.centerYAnchor.constraint(equalTo: centerYAnchor, constant: paddingCenterY).isActive = true
        }
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let widthAnchor = widthAnchor {
            self.widthAnchor.constraint(equalTo: widthAnchor, constant: paddingWidth).isActive = true
        }
        
        if let heightAnchor = heightAnchor {
            self.heightAnchor.constraint(equalTo: heightAnchor, constant: paddingHeight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }
    
}

extension UIControl {
    static var defaultHeight: CGFloat = 64.0
}

