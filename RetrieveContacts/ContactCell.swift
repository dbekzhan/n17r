//
//  ContactCell.swift
//  Contacts_LBTA
//
//  Created by Dimash Bekzhan on 1/25/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var delegate: didSelectElementDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            button.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
            button.tintColor = .lightGray
            button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
            return button
        }()
        accessoryView = button
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init code has not been implemented")
    }
    
    @objc private func handleTap() {
        delegate?.didSelectItem(element: self)
    }
}


