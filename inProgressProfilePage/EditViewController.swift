//
//  EditViewController.swift
//  FinalProject_ICT
//
//  Created by Dimash Bekzhan on 4/1/18.
//  Copyright © 2018 Dimash Bekzhan. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.background.value
        setUp()
    }
    
    private func setUp() {
        // place it in center
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
       // navigationController?.navigationBar.barTintColor = navigationController?.defaultBackgroundColor
        navigationController?.navigationBar.tintColor = navigationController?.defaultTintColor
        navigationController?.isNavigationBarHidden = false
    }
}
