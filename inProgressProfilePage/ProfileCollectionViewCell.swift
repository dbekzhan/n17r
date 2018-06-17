//
//  ProfileCell.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 3/31/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setNameLabel(text: String) {
        nameLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: Color.mainText.value])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("collection cell initialized")
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Color.border.value.cgColor
        self.clipsToBounds = true
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        addSubview(nameLabel)
    }
    
    func setUpConstraints() {
        let views = ["nameLabel": nameLabel]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[nameLabel]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
    }
}
