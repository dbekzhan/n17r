//
//  ProfileViewController.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 3/31/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: UICollectionViewController {
    
    let nickName = "rakamakofo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        collectionView?.backgroundColor = Color.background.value
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.delaysContentTouches = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(ProfileCollectionViewCell.self)
        collectionView?.registerHeader(HeaderView.self)
        
        navigationController?.navigationBar.isHidden = true
    }
}

extension ProfileCollectionViewController {
    
    enum Parameters: String {
        case Edit = "Edit", LogOut = "Log Out"
        static let cases = [Edit, LogOut]
        static var count: Int {
            return Parameters.cases.count
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let _ = layout.minimumInteritemSpacing
        return UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Parameters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: ProfileCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let parameter = Parameters.cases[indexPath.row]
        item.setNameLabel(text: parameter.rawValue)
        return item
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: HeaderView = collectionView.dequeueReusableHeader(for: indexPath)
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let parameter = Parameters.cases[indexPath.row]
        
        switch parameter {
        case .Edit:
            print("edit")
            navigationController?.pushViewController(EditViewController(), animated: true)
        case .LogOut:
            logOutAction()
        }
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = Color.controlSelection.value
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = .clear
    }
}

extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: UIScreen.main.bounds.height * 0.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}

