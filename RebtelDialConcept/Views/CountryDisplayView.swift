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
        case loaded(country: Country)
        case loading
        case empty
    }
    
    private var state: State = .empty {
        didSet{
            switch state {
            case .empty:
                self.toggleEmpty(on: true)
            case .loaded(let country):
                self.updateUI(for: country)
            case .loading:
                self.toggleLoading(on: true)
            }
        }
    }
    
    var country: Country? {
        didSet{
            // Check for nil
            guard let country = country else {
                self.state = .empty
                return
            }
            self.toggleEmpty(on: false)
            // See if object is full loaded
            guard country.capital == nil else {
                self.state = .loaded(country: country)
                self.toggleLoading(on: false)
                return
            }
            self.state = .loading
        }
    }
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.isHidden = true
        ai.color = Theme.secondaryColor
        return ai
    }()
    
    lazy var name: UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Country Name"
        lbl.backgroundColor = .white
        lbl.textColor = Theme.primaryColor
        lbl.textAlignment = .center
        lbl.font = Theme.headerFont
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
        toggleEmpty(on: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addViews() {
        self.addSubview(name)
        self.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            name.leftAnchor.constraint(equalTo: self.leftAnchor),
            name.rightAnchor.constraint(equalTo: self.rightAnchor),
            name.topAnchor.constraint(equalTo: self.topAnchor),
            name.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 10),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 10)
            ])
    }
    
    private func toggleLoading(on: Bool) {
        if on {
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        } else {
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func toggleEmpty(on: Bool) {
        if on {
            self.addSubview(empty)
            NSLayoutConstraint.activate([
                empty.leftAnchor.constraint(equalTo: self.leftAnchor),
                empty.rightAnchor.constraint(equalTo: self.rightAnchor),
                empty.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                empty.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
                ])
        } else {
            empty.removeFromSuperview()
        }
    }
    
    private func updateUI(for country: Country) {
        self.name.text = country.name
    }
    
}
