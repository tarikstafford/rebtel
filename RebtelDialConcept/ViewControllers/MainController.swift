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
        sB.delegate = self
        sB.placeholder = "Filter countries..."
        sB.barTintColor = Theme.primaryColor
        sB.tintColor = UIColor.synthPurple
        sB.translatesAutoresizingMaskIntoConstraints = false
        sB.layer.borderWidth = 1
        sB.layer.borderColor = Theme.primaryColor.cgColor
        return sB
    }()
    
    lazy var countryDisplay: CountryDisplayView = {
       let cD = CountryDisplayView.init(country: nil, frame: CGRect.zero)
        cD.translatesAutoresizingMaskIntoConstraints = false
        cD.backgroundColor = Theme.primaryColor
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
        
        let nib = UINib.init(nibName: "CountryRotatingCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CountryRotatingCell")
        
        self.view.backgroundColor = .white
        self.title = "Country Finder"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = Theme.primaryColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Theme.headerFont,
            NSAttributedString.Key.foregroundColor:UIColor.white
        ]
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let sortbutton = UIBarButtonItem.init(title: "SORT", style: .plain, target: self, action: #selector(sort))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = sortbutton
        
        addViews()
        fetchAll()
    }
    
    fileprivate func addViews() {
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView)
        self.view.addSubview(countryDisplay)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height*0.3),
            
            countryDisplay.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            countryDisplay.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            countryDisplay.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            countryDisplay.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
    }
    
    fileprivate func fetchAll(){
        var countries = Country.fetchAll()
        countries.sort {
            $0.name < $1.name
        }
        self.countries = countries
    }
    
    fileprivate func updateDatasource(for country: Country) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        
        // Load name first
        countryDisplay.country = country
        
        loadData(for: country, indexPath: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let midPoint = collectionView.bounds.width/2 + collectionView.contentOffset.x
        
        collectionView.visibleCells.forEach({ (cell) in
            if midPoint > cell.frame.minX && midPoint < cell.frame.maxY {
                guard let indexPath = self.collectionView.indexPath(for: cell) else {
                    // Handle Error
                    return
                }
                let country = self.countries[indexPath.row]
                self.loadData(for: country, indexPath: indexPath)
            }
        })
    }
    
    private func loadData(for country: Country, indexPath: IndexPath) {
        // Unwrap ISO
        guard let iso = country.iso else {
            let alert = UIAlertController.init(title: "Invalid ISO Code", message: "Country code not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if the data has already been called ( this needs to be tested )
        guard country.capital == nil else {
            self.countryDisplay.country = countries[indexPath.row]
            return
        }
        
        // If not fetch the data and then push it to the display & update the datasource ( this needs to be tested )
        _ = CountryAPIService.countryAPIServiceShared.send(FetchCountry.init(isoCode: iso), completion: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case.success(let response):
                DispatchQueue.main.async {
                    self.countryDisplay.country = response
                    self.updateDatasource(for: response)
                }
            }
        })
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
         additive so we always query the complete collection of objects.
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

extension MainController {
    @objc func sort() {
        print("PRESSED")
    }
}
