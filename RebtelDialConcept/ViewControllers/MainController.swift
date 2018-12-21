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
    
    lazy var collectionView: UICollectionView = {
        let layout = RotatingCollectionLayout.init(gap: 10, itemSize: CGSize.init(width: 100, height: 100))
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.decelerationRate = .fast
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    lazy var searchBar: UISearchBar = {
        let sB = UISearchBar()
        sB.layer.borderColor = UIColor.clear.cgColor
        sB.layer.borderWidth = 0
        sB.delegate = self
        sB.placeholder = "Filter countries..."
        sB.barTintColor = .red
        sB.tintColor = .yellow
        sB.translatesAutoresizingMaskIntoConstraints = false
        return sB
    }()
    
    lazy var countryDisplay: CountryDisplayView = {
       let cD = CountryDisplayView.init(country: nil, frame: CGRect.zero)
        cD.translatesAutoresizingMaskIntoConstraints = false
        cD.backgroundColor = .green
        return cD
    }()
    
    lazy var stackViewRegionButtons: UIStackView = {
        let sv = UIStackView.init()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        for region in Region.allCases {
            guard region != .Error else { break }
            let b = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            b.setTitle(region.rawValue, for: .normal)
            b.backgroundColor = .red
            sv.addArrangedSubview(b)
        }
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var countries = [Country]() {
        didSet{
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var countriesCopy = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib.init(nibName: "CountryRotatingCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CountryRotatingCell")
        
        self.view.backgroundColor = .gray
    
        self.view.addSubview(collectionView)
        self.view.addSubview(searchBar)
        self.view.addSubview(countryDisplay)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.3),
            
            searchBar.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 75),
            searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            countryDisplay.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            countryDisplay.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            countryDisplay.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            countryDisplay.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
    
        fetchAll()
    }
    
    fileprivate func fetchAll(){
        var countries = Country.fetchAll()
        countries.sort {
            $0.name < $1.name
        }
        self.countries = countries
    }
    
    fileprivate func fetchCountry(for code: String, indexPath: IndexPath) {
        _ = CountryAPIService.countryAPIServiceShared.send(FetchCountry.init(isoCode: code), completion: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case.success(let response):
                DispatchQueue.main.async {
                    self.countries[indexPath.row] = response
                    self.loadDisplay(for: self.countries[indexPath.row])
                }
            }
        })
    }
}

// MARK: Collection View Delegate & Datasource
extension MainController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = countries.count //> 0 ? countries.count : 0
        return count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryRotatingCell", for: indexPath) as! CountryRotatingCell
        cell.flagView.image = countries[indexPath.row].getImage(type: .medium)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        
        guard let iso = country.iso else {
            let alert = UIAlertController.init(title: "Invalid ISO Code", message: "Country code not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default))
            present(alert, animated: true, completion: nil)
            return
            }
        
        guard country.capital != nil else {
            loadDisplay(for: country)
            return
            }
        fetchCountry(for: iso, indexPath: indexPath)
    }
    
    func loadDisplay(for country: Country) {
        print(country)
    }
}

// MARK: Search Bar Delegate
extension MainController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Reset the datasource if search query is deleted
        guard !searchText.isEmpty else {
            self.countries = countriesCopy.sorted(by: { $0.name < $1.name })
            return
        }
        
        var filteredCountries = [Country]()
        
        /*
         Create a set to create uniquness - this enables us to make the copy
         additive so we always query the complete collection of objects and it
         avoids duplication.
         */
        
        let set = Set(self.countriesCopy)
        let union = set.union(self.countries)
        self.countriesCopy = Array(union)
        filteredCountries = self.countriesCopy.filter { (country) -> Bool in
            country.name.contains(searchText)
        }
        
        guard !filteredCountries.isEmpty else {
            return
        }
        
        self.countries = filteredCountries
    }
}
