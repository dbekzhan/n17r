//
//  HeaderView.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 3/31/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

// Header view which contains user profile image, nickname, name and about info
class HeaderView: UICollectionReusableView, ReusableView {
    
    let nickName = "rakamakofo"
    
    // MARK: - UI objects presented on screen
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(style: .standard)
        imageView.image = #imageLiteral(resourceName: "picture")
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Dinmukhammad Bekzhan", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: Color.mainText.value])
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "@\(nickName)", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: Color.attributedText.value])
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var aboutMeLabel: UILabel = {
        let label = UILabel()
        
        let string = "Biography"
        label.attributedText = NSAttributedString(string: string, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin), NSAttributedStringKey.foregroundColor: Color.mainText.value])
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.preferredMaxLayoutWidth = self.bounds.width - 30 // ??
        label.layer.masksToBounds = true
        
        label.addBorders(edges: [.top])
        
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        self.invalidateIntrinsicContentSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews() {
        self.backgroundColor = Color.background.value
        self.addSubview(profileImageView)
        self.addSubview(nameLabel)
        self.addSubview(nickNameLabel)
        self.addSubview(aboutMeLabel)
        
        self.addBorders(edges: [.bottom], padding: 10.0, color: Color.theme.value, thickness: 5.0)
    }
    
    
    // Set rules for mutual placement 
    func setUpConstraints() {
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40).isActive = true
        
        nickNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        nickNameLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        
        aboutMeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        aboutMeLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 10).isActive = true
        aboutMeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40).isActive = true
    }
}


