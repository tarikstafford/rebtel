//
//  ViewController.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 17/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView.init()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        return iv
    }()
    
    var countries = [Country?](repeating: nil, count: 195)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
            ])
        
        getImageFor()
    }
    
    func getImageFor() {
        let country = Country.init(iso: "tg", name: nil, info: nil, region: .Africa)
        self.imageView.image = country.getImage(type: .thumbnail)
        
    }
}

