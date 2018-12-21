//
//  CountryDisplay.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 21/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit

class CountryDisplayView: UIView {
    
    enum State {
        case loaded, loading, empty
    }
    
    private var state: State = .empty {
        didSet{
            switch state {
            case .empty:
                self.toggleEmpty(on: true)
            default:
                print("")
            }
        }
    }
    
    var country: Country? {
        didSet{
            guard let country = country else {
                self.state = .empty
                return
            }
        }
    }
    
    lazy var name: UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Country Name"
        lbl.backgroundColor = .red
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var empty: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Scroll or select a country!"
        lbl.backgroundColor = .lightGray
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    init(country: Country?, frame: CGRect){
        self.country = country
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addViews() {
        self.addSubview(name)
        
        NSLayoutConstraint.activate([
            name.leftAnchor.constraint(equalTo: self.leftAnchor),
            name.rightAnchor.constraint(equalTo: self.rightAnchor),
            name.topAnchor.constraint(equalTo: self.topAnchor),
            name.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    private func toggleEmpty(on: Bool) {
        if on {
            self.addSubview(empty)
            
            NSLayoutConstraint.activate([
                empty.leftAnchor.constraint(equalTo: self.leftAnchor),
                empty.rightAnchor.constraint(equalTo: self.rightAnchor),
                empty.topAnchor.constraint(equalTo: self.topAnchor),
                empty.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                ])
        }
    }
    
}
