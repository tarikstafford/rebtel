//
//  NavController.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 25/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        customBar()
    }
    
    private func customBar() {
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Theme.primaryColor
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Theme.headerFont,
            NSAttributedString.Key.foregroundColor:UIColor.white
        ]
        navigationBar.shadowImage = UIImage()
    }
}
