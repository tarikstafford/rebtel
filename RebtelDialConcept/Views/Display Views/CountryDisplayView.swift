//
//  CountryDisplay.swift
//  RebtelDialConcept
//
//  Created by Tarik Stafford on 21/12/18.
//  Copyright © 2018 Tarik Stafford. All rights reserved.
//

import UIKit
import MapKit

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
        ai.color = .white
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

    lazy var mapButton: UIButton = {
       let btn = UIButton.init()
        btn.titleLabel?.font = Theme.fontAwesome
        btn.setTitle("\u{f276}", for: .normal)
        btn.setTitleColor(Theme.secondaryColor, for: .normal)
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var capital: LabelView = {
        let cap = LabelView.init(frame: CGRect.zero, fontAwesomeCode: "\u{f005}", title: "Capital")
        cap.translatesAutoresizingMaskIntoConstraints = false
        return cap
    }()
    
    lazy var population: LabelView = {
        let pop = LabelView.init(frame: CGRect.zero, fontAwesomeCode: "\u{f2b9}", title: "Population")
        pop.translatesAutoresizingMaskIntoConstraints = false
        return pop
    }()
    
    lazy var currencies: LabelView = {
        let curr = LabelView.init(frame: CGRect.zero, fontAwesomeCode: "\u{f0d6}", title: "Currency")
        curr.translatesAutoresizingMaskIntoConstraints = false
        return curr
    }()
    
    lazy var mapView: MKMapView = {
       let mV = MKMapView.init()
        mV.delegate = self
        mV.layer.cornerRadius = 10
        mV.isZoomEnabled = true
        mV.isScrollEnabled = false
        mV.translatesAutoresizingMaskIntoConstraints = false
        return mV
    }()
    
    lazy var annotation: MKPointAnnotation = {
        let anno = MKPointAnnotation.init()
        return anno
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
        self.addSubview(capital)
        self.addSubview(population)
        self.addSubview(mapView)
        self.addSubview(currencies)
        
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
        
        NSLayoutConstraint.activate([
            capital.topAnchor.constraint(equalTo: self.name.bottomAnchor, constant: 10),
            capital.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            capital.heightAnchor.constraint(equalToConstant: 50),
            capital.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
            ])
        
        NSLayoutConstraint.activate([
            population.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            population.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            population.topAnchor.constraint(equalTo: self.capital.bottomAnchor),
            population.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            currencies.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            currencies.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            currencies.topAnchor.constraint(equalTo: self.population.bottomAnchor),
            currencies.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            mapView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            mapView.topAnchor.constraint(equalTo: self.currencies.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
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
        guard let capital = country.capital,
            let population = country.population
            else { return }
    
        self.capital.labelTitle.text = capital == "" ? "None" : capital
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let commaSeparatedPop = numberFormatter.string(from: NSNumber(value: population)) {
            self.population.labelTitle.text = String(commaSeparatedPop)
        }
        
        centerMap(for: country.coords)
        var currencies = ""
        country.currencies?.forEach({ (currency) in
            currencies +=  (currency.name ?? "Unknown") + "(\(currency.symbol ?? "N/A")) "
        })
        
        self.currencies.labelTitle.text = currencies == "" ? "None" : currencies
    }
}

extension CountryDisplayView: MKMapViewDelegate {
    private func centerMap(for center: [Double]?) {
        guard let center = center,
            let lat = center.first,
            let long = center.last
            else { return }
        let coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(lat)
            , longitude: CLLocationDegrees.init(long))
        
        mapView.setCenter(coordinate, animated: true)
    }
}
